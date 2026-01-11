import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/core.dart';
import '../../state/providers.dart';
import '../../utils/furigana_util.dart';
import '../../widgets/widgets.dart';
import 'week_day_data.dart';
import 'flashcards_tab.dart';
import 'home_providers.dart';
import 'lesson_drawer.dart';
import 'quiz_tab.dart';
import 'study_tab.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();

  String _screenTitle(int week, int day) {
    final weekTitle = weekTitles[week - 1];
    final dayTitle = dayTitlesByWeek[week - 1][day - 1];
    final mTitle = '$week-$day ${_extractDayTitle(dayTitle)}';
    return furiganaOriginalText(mTitle.isNotEmpty ? mTitle : weekTitle);
  }

  String _extractDayTitle(String raw) {
    if (raw.startsWith('1')) {
      return raw.length > 9 ? raw.substring(9) : raw;
    }
    return raw.length > 8 ? raw.substring(8) : raw;
  }
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  int _tabIndex = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final selectionAsync = ref.watch(lessonSelectionProvider);

    return selectionAsync.when(
      data: (selection) {
        final title = widget._screenTitle(selection.week, selection.day);

        return Scaffold(
          appBar: AppBar(
            centerTitle: false,
            titleSpacing: 0,
            title: Text(title),
          ),
          drawer: LessonDrawer(
            currentWeek: selection.week,
            currentDay: selection.day,
            onSelect: (w, d) async {
              if (w == selection.week && d == selection.day) {
                if (context.mounted) Navigator.of(context).pop();
                return;
              }
              await ref.read(lessonSelectionProvider.notifier).setWeekDay(w, d);
              await ref
                  .read(selectedKanjiIdProvider.notifier)
                  .setSelectedId(null);
              ref.invalidate(kanjiListProvider);
              ref.invalidate(selectedKanjiIdProvider);
              setState(() => _tabIndex = 0);
              if (context.mounted) Navigator.of(context).pop();
            },
          ),
          body: _MainBody(
            tabIndex: _tabIndex,
            dayOfCourse: selection.dayOfCourse,
          ),
          bottomNavigationBar: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const AdBanner(),
              BottomNavigationBar(
                currentIndex: _tabIndex,
                onTap: (index) => setState(() => _tabIndex = index),
                items: const [
                  BottomNavigationBarItem(
                    icon: Icon(Icons.menu_book),
                    label: 'Study',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.style),
                    label: 'Flash Card',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.quiz),
                    label: 'Quiz',
                  ),
                ],
              ),
            ],
          ),
        );
      },
      error: (e, st) => Scaffold(body: ErrorView(message: e.toString())),
      loading: () => const Scaffold(body: LoadingIndicator()),
    );
  }
}

class _MainBody extends ConsumerWidget {
  const _MainBody({required this.tabIndex, required this.dayOfCourse});

  final int tabIndex;
  final int dayOfCourse;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (tabIndex == 0) {
      return const StudyTab();
    }

    final dayWordsAsync = ref.watch(dayWordsProvider);
    return dayWordsAsync.when(
      data: (dayWords) {
        if (tabIndex == 1) {
          return FlashcardsTab(words: dayWords);
        }
        final allWords = ref.watch(wordStoreProvider).value ?? dayWords;
        return QuizTab(words: dayWords, allWords: allWords);
      },
      error: (e, st) => ErrorView(message: e.toString()),
      loading: () => const LoadingIndicator(),
    );
  }
}
