import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/core.dart';
import '../../domain/models/word.dart';
import '../../services/tts_provider.dart';
import '../../state/providers.dart';
import '../../widgets/widgets.dart';
import 'kanjidic2_service.dart';
import 'word_examples_provider.dart';

class WordDetailScreen extends ConsumerWidget {
  const WordDetailScreen({required this.word, super.key});

  final Word word;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scheme = Theme.of(context).colorScheme;

    final w = ref.watch(wordByIdValueProvider(word.wordId)) ?? word;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Word'),
        actions: [
          IconButton(
            tooltip: w.isFavourite ? 'Remove favourite' : 'Add favourite',
            onPressed: () =>
                ref.read(wordStoreProvider.notifier).toggleFavourite(w),
            icon: Icon(
              w.isFavourite ? Icons.star : Icons.star_border,
              size: 22,
              color:
                  w.isFavourite ? AppColors.favouriteActive : scheme.onSurface,
            ),
          ),
          IconButton(
            tooltip: 'Speak',
            onPressed: () {
              final tts = ref.read(ttsServiceProvider);
              final kanji = w.kanji.trim();
              final kana = tts.sanitizeKana(w.kana);
              final text = kanji.isNotEmpty ? kanji : kana;
              tts.speak(text);
            },
            icon: const Icon(Icons.volume_up_outlined, size: 22),
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            height: 130,
            color: Theme.of(context).primaryColor,
            padding: const EdgeInsets.symmetric(
              horizontal: AppSizes.md,
              vertical: AppSizes.md,
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  width: 120,
                  child: Center(
                    child: Text(
                      w.kanji,
                      textAlign: TextAlign.center,
                      style:
                          Theme.of(context).textTheme.headlineLarge?.copyWith(
                                fontWeight: FontWeight.w900,
                                color: Colors.white,
                              ),
                    ),
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (w.kana.trim().isNotEmpty)
                          Text(
                            w.kana,
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                ),
                            textAlign: TextAlign.left,
                          ),
                        if (w.meaning.trim().isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.only(top: 12),
                            child: Text(
                              w.meaning,
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium
                                  ?.copyWith(
                                    color: Colors.white.withValues(alpha: 0.9),
                                    fontWeight: FontWeight.w600,
                                  ),
                              textAlign: TextAlign.left,
                            ),
                          ),
                        if (w.english.trim().isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.only(top: 6),
                            child: Text(
                              w.english,
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium
                                  ?.copyWith(
                                    color: Colors.white.withValues(alpha: 0.9),
                                    fontWeight: FontWeight.w600,
                                  ),
                              textAlign: TextAlign.left,
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 0, 0, AppSizes.xl),
                  child: Column(
                    children: [
                      _Section(
                        title: 'Kanji',
                        child: _KanjiList(
                          word: w,
                          onTapKanji: (k) =>
                              context.push('/practice/kanji', extra: k),
                        ),
                      ),
                      _Section(
                        title: 'Examples',
                        child: _Examples(word: w),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppSizes.md),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: const AdBanner(),
    );
  }
}

class _KanjiRow extends StatelessWidget {
  const _KanjiRow({
    required this.literal,
    required this.entry,
    required this.onTap,
  });

  final String literal;
  final KanjiDicEntry? entry;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final meanings = entry?.meanings ?? const <String>[];
    final on = entry?.onyomi ?? const <String>[];
    final kun = entry?.kunyomi ?? const <String>[];

    return InkWell(
      onTap: onTap,
      child: Container(
        color: Colors.white,
        padding: const EdgeInsets.symmetric(
          horizontal: AppSizes.md,
          vertical: AppSizes.sm,
        ),
        child: Row(
          children: [
            // Left side: Kanji
            SizedBox(
              width: 50,
              child: Text(
                literal,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w900,
                    ),
              ),
            ),
            const SizedBox(width: AppSizes.md),
            // Right side: Meaning, Onyomi, Kunyomi
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Line 1: Meanings
                  if (meanings.isNotEmpty)
                    Text(
                      meanings.join(', '),
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  // Line 2: Onyomi
                  if (on.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 2),
                      child: Text(
                        on.join(' / '),
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: scheme.onSurfaceVariant,
                              fontWeight: FontWeight.w600,
                            ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  // Line 3: Kunyomi
                  if (kun.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 2),
                      child: Text(
                        kun.join(' / '),
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: scheme.onSurfaceVariant,
                              fontWeight: FontWeight.w600,
                            ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                ],
              ),
            ),
            // Trailing icon
            const Icon(Icons.chevron_right, size: 20),
          ],
        ),
      ),
    );
  }
}

class _Section extends StatelessWidget {
  const _Section({required this.title, required this.child});

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Card(
          elevation: 2,
          margin: EdgeInsets.zero,
          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
          color: Colors.white70,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSizes.listTileHorizontalPadding,
              vertical: AppSizes.md,
            ),
            child: Text(
              title,
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w800,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
            ),
          ),
        ),
        const Divider(height: 1, thickness: 1, color: AppColors.divider),
        Card(
          elevation: 0,
          margin: EdgeInsets.zero,
          color: Colors.white,
          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
          clipBehavior: Clip.antiAlias,
          child: child,
        ),
      ],
    );
  }
}

class _KanjiList extends StatelessWidget {
  const _KanjiList({required this.word, required this.onTapKanji});

  final Word word;
  final ValueChanged<String> onTapKanji;

  @override
  Widget build(BuildContext context) {
    final kanjis = _extractKanjis(word.kanji);

    if (kanjis.isEmpty) {
      return Padding(
        padding: const EdgeInsets.all(AppSizes.lg),
        child: Text(
          'No kanji found in this word.',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
        ),
      );
    }

    return FutureBuilder<Map<String, KanjiDicEntry>>(
      future: KanjiDicService().load(),
      builder: (context, snap) {
        final dic = snap.data ?? const <String, KanjiDicEntry>{};

        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            for (var i = 0; i < kanjis.length; i++) ...[
              if (i != 0)
                const Divider(
                  height: 1,
                  thickness: 1,
                  color: AppColors.divider,
                ),
              _KanjiRow(
                literal: kanjis[i],
                entry: dic[kanjis[i]],
                onTap: () => onTapKanji(kanjis[i]),
              ),
            ],
          ],
        );
      },
    );
  }

  List<String> _extractKanjis(String text) {
    final result = <String>[];
    for (final rune in text.runes) {
      final ch = String.fromCharCode(rune);
      final isKanji = (rune >= 0x4E00 && rune <= 0x9FFF) ||
          (rune >= 0x3400 && rune <= 0x4DBF) ||
          (rune >= 0xF900 && rune <= 0xFAFF);
      if (isKanji && !result.contains(ch)) {
        result.add(ch);
      }
    }
    return result;
  }
}

class _Examples extends ConsumerWidget {
  const _Examples({required this.word});

  final Word word;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final query =
        word.kanji.trim().isNotEmpty ? word.kanji.trim() : word.kana.trim();
    if (query.isEmpty) {
      return Padding(
        padding: const EdgeInsets.all(AppSizes.lg),
        child: Text(
          'No query available for examples.',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
        ),
      );
    }

    final examplesAsync = ref.watch(
      wordExamplesProvider(query: query, limit: 6),
    );

    return examplesAsync.when(
      loading: () => const Padding(
        padding: EdgeInsets.symmetric(vertical: 18),
        child: Center(child: LoadingIndicator()),
      ),
      error: (e, st) => Padding(
        padding: const EdgeInsets.all(AppSizes.lg),
        child: Text(
          'Failed to load examples. Check your internet connection.',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
        ),
      ),
      data: (examples) {
        if (examples.isEmpty) {
          return Padding(
            padding: const EdgeInsets.all(AppSizes.lg),
            child: Text(
              'No examples found.',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
            ),
          );
        }

        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            for (var i = 0; i < examples.length; i++) ...[
              if (i != 0)
                const Divider(
                  height: 1,
                  thickness: 1,
                  color: AppColors.divider,
                ),
              Padding(
                padding: const EdgeInsets.fromLTRB(
                  AppSizes.listTileHorizontalPadding,
                  AppSizes.md,
                  AppSizes.listTileHorizontalPadding,
                  AppSizes.md,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        examples[i].japanese,
                        textAlign: TextAlign.left,
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              fontWeight: FontWeight.w700,
                            ),
                      ),
                    ),
                    const SizedBox(height: AppSizes.sm),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        examples[i].english,
                        textAlign: TextAlign.left,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: Theme.of(context)
                                  .colorScheme
                                  .onSurfaceVariant,
                            ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
            const Divider(height: 1, thickness: 1, color: AppColors.divider),
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSizes.listTileHorizontalPadding,
                10,
                AppSizes.listTileHorizontalPadding,
                10,
              ),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Source: Tatoeba (CC BY 2.0 FR)',
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
