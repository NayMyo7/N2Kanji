import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../core/core.dart';
import '../domain/models/word.dart';
import '../services/tts_provider.dart';
import '../state/providers.dart';

class WordListView extends ConsumerWidget {
  const WordListView({
    required this.words,
    super.key,
    this.emptyText,
    this.onWordLongPress,
  });

  final List<Word> words;
  final String? emptyText;
  final void Function(Word word)? onWordLongPress;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (words.isEmpty) {
      return Center(child: Text(emptyText ?? 'No words.'));
    }

    return ListView.separated(
      itemCount: words.length,
      separatorBuilder: (context, index) =>
          const Divider(height: 1, thickness: 1, color: AppColors.divider),
      itemBuilder: (context, index) {
        final w = words[index];
        return _WordListItem(word: w, onLongPress: onWordLongPress);
      },
    );
  }
}

class _WordListItem extends ConsumerWidget {
  const _WordListItem({required this.word, this.onLongPress});

  final Word word;
  final void Function(Word word)? onLongPress;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(
        vertical: AppSizes.listTileVerticalPadding,
        horizontal: AppSizes.listTileHorizontalPadding,
      ),
      onTap: () => context.push('/word', extra: word),
      onLongPress: onLongPress != null ? () => onLongPress!(word) : null,
      leading: Text(
        word.kanji,
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w400,
          color: Colors.black87,
        ),
      ),
      minLeadingWidth: 100,
      tileColor: Colors.white70,
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            word.kana,
            style: const TextStyle(fontSize: 13, color: Colors.black),
          ),
          const SizedBox(height: AppSizes.sm),
          Text(
            word.meaning,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 12,
              color: Color(0xFF212121),
              height: 1.2,
            ),
          ),
          const SizedBox(height: AppSizes.xs),
          Text(
            word.english,
            style: const TextStyle(fontSize: 14, color: Color(0xFF212121)),
          ),
        ],
      ),
      trailing: _WordTrailingActions(word: word),
    );
  }
}

class _WordTrailingActions extends ConsumerWidget {
  const _WordTrailingActions({required this.word});

  final Word word;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SizedBox(
      width: AppSizes.trailingWidth,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: AppSizes.iconButtonBox,
            height: AppSizes.iconButtonBox,
            child: IconButton(
              tooltip: word.isFavourite ? 'Remove favourite' : 'Add favourite',
              padding: EdgeInsets.zero,
              visualDensity: AppSizes.compactIconDensity,
              constraints: AppSizes.iconButtonTightConstraints,
              icon: Icon(
                word.isFavourite ? Icons.star : Icons.star_border,
                size: AppSizes.iconSizeSm,
                color: word.isFavourite
                    ? AppColors.favouriteActive
                    : AppColors.favouriteInactive,
              ),
              onPressed: () =>
                  ref.read(wordStoreProvider.notifier).toggleFavourite(word),
            ),
          ),
          const SizedBox(height: AppSizes.xxs),
          SizedBox(
            width: AppSizes.iconButtonBox,
            height: AppSizes.iconButtonBox,
            child: IconButton(
              tooltip: 'Speak',
              padding: EdgeInsets.zero,
              visualDensity: AppSizes.compactIconDensity,
              constraints: AppSizes.iconButtonTightConstraints,
              icon: const Icon(
                Icons.volume_up_outlined,
                size: AppSizes.iconSizeSm,
              ),
              onPressed: () {
                final tts = ref.read(ttsServiceProvider);
                final kanji = word.kanji.trim();
                final kana = tts.sanitizeKana(word.kana);
                final text = kanji.isNotEmpty ? kanji : kana;
                tts.speak(text);
              },
            ),
          ),
        ],
      ),
    );
  }
}
