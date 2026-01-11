import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/core.dart';
import '../../domain/models/kanji.dart';
import '../../state/providers.dart';
import '../../utils/word_info_snackbar.dart';
import '../../widgets/widgets.dart';
import 'home_providers.dart';

class StudyTab extends ConsumerWidget {
  const StudyTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final kanjiAsync = ref.watch(kanjiListProvider);
    final selectedIdAsync = ref.watch(selectedKanjiIdProvider);

    if (kanjiAsync.isLoading || selectedIdAsync.isLoading) {
      return const LoadingIndicator();
    }

    if (kanjiAsync.hasError) {
      return ErrorView(message: kanjiAsync.error.toString());
    }

    if (selectedIdAsync.hasError) {
      return ErrorView(message: selectedIdAsync.error.toString());
    }

    final kanjis = kanjiAsync.value ?? const <Kanji>[];
    final selectedId = selectedIdAsync.value;

    Kanji? effectiveSelected;
    if (kanjis.isNotEmpty) {
      effectiveSelected = selectedId == null
          ? kanjis.first
          : kanjis.firstWhere(
              (k) => k.id == selectedId,
              orElse: () => kanjis.first,
            );

      // If the stored id doesn't exist for this day, clear it to avoid confusion.
      if (selectedId != null && effectiveSelected.id != selectedId) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          ref.read(selectedKanjiIdProvider.notifier).setSelectedId(null);
        });
      }
    }

    return Column(
      children: [
        _KanjiDetail(kanji: effectiveSelected),
        _KanjiHorizontalList(
          kanjis: kanjis,
          selectedId: selectedId ?? effectiveSelected?.id,
        ),
        Expanded(child: _WordTabBody(selectedKanji: effectiveSelected)),
      ],
    );
  }
}

class _WordTabBody extends ConsumerWidget {
  const _WordTabBody({required this.selectedKanji});

  final Kanji? selectedKanji;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (selectedKanji == null) {
      return const Center(child: Text('No kanji.'));
    }

    final wordsAsync = ref.watch(wordsByKanjiProvider(selectedKanji!.id));
    final words = ref.watch(wordsByKanjiValueProvider(selectedKanji!.id));

    return wordsAsync.when(
      data: (_) => WordListView(
        words: words,
        emptyText: 'No words.',
        onWordLongPress: (word) => WordInfoSnackBar.show(context, word),
      ),
      error: (e, st) => ErrorView(message: e.toString()),
      loading: () => const LoadingIndicator(),
    );
  }
}

class _KanjiDetail extends StatelessWidget {
  const _KanjiDetail({required this.kanji});

  final Kanji? kanji;

  @override
  Widget build(BuildContext context) {
    if (kanji == null) {
      return const Padding(
        padding: EdgeInsets.all(AppSizes.lg),
        child: Text('No kanji.'),
      );
    }

    final hasOnyomi = kanji!.onyomi.trim().isNotEmpty;
    final hasKunyomi = kanji!.kunyomi.trim().isNotEmpty;
    final hasBothReadings = hasOnyomi && hasKunyomi;

    return Container(
      height: 130,
      color: Theme.of(context).primaryColor,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSizes.md,
        vertical: AppSizes.md,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Center(
              child: InkWell(
                onTap: () =>
                    context.push('/practice/kanji', extra: kanji!.kanji),
                child: KanjiStrokePreview(character: kanji!.kanji),
              ),
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (hasOnyomi)
                    Text(
                      kanji!.onyomi,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: AppColors.onyomiReading,
                      ),
                      textAlign: TextAlign.left,
                    ),
                  if (hasBothReadings) const SizedBox(height: AppSizes.sm),
                  if (hasKunyomi)
                    Text(
                      kanji!.kunyomi,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: AppColors.kunyomiReading,
                      ),
                      textAlign: TextAlign.left,
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _KanjiHorizontalList extends ConsumerWidget {
  const _KanjiHorizontalList({required this.kanjis, required this.selectedId});

  final List<Kanji> kanjis;
  final int? selectedId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (kanjis.isEmpty) {
      return const SizedBox.shrink();
    }

    const selectedColor = Colors.black87;
    const unselectedColor = Color(0xFFBDBDBD);

    return SizedBox(
      height: 44,
      child: Material(
        color: Theme.of(context).colorScheme.surface,
        elevation: 2,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: kanjis.length,
          itemBuilder: (context, index) {
            final k = kanjis[index];
            final isSelected = selectedId == k.id;

            return InkWell(
              onTap: () => ref
                  .read(selectedKanjiIdProvider.notifier)
                  .setSelectedId(k.id),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSizes.md),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Expanded(
                      child: Center(
                        child: Text(
                          k.kanji,
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: isSelected
                                ? FontWeight.w700
                                : FontWeight.w500,
                            color: isSelected ? selectedColor : unselectedColor,
                          ),
                        ),
                      ),
                    ),
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 150),
                      height: 2,
                      width: 24,
                      decoration: BoxDecoration(
                        color: isSelected
                            ? AppColors.secondary
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(AppSizes.xxs),
                      ),
                    ),
                    const SizedBox(height: AppSizes.xs),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
