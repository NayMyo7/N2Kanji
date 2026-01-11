import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../state/providers.dart';
import '../../utils/word_info_snackbar.dart';
import '../../widgets/widgets.dart';

class FavouritesScreen extends ConsumerWidget {
  const FavouritesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final allAsync = ref.watch(wordStoreProvider);
    final favWords = ref.watch(favouriteWordsValueProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Favourites')),
      body: allAsync.when(
        data: (_) => WordListView(
          words: favWords,
          emptyText: 'No favourites yet.',
          onWordLongPress: (word) => WordInfoSnackBar.show(context, word),
        ),
        error: (e, st) => Center(child: Text(e.toString())),
        loading: () => const Center(child: CircularProgressIndicator()),
      ),
      bottomNavigationBar: const AdBanner(),
    );
  }
}
