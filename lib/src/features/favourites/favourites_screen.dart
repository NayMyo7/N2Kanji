import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../utils/word_info_snackbar.dart';
import '../../widgets/widgets.dart';
import 'favourites_providers.dart';

class FavouritesScreen extends ConsumerStatefulWidget {
  const FavouritesScreen({super.key});

  @override
  ConsumerState<FavouritesScreen> createState() => _FavouritesScreenState();
}

class _FavouritesScreenState extends ConsumerState<FavouritesScreen> {
  @override
  void initState() {
    super.initState();
    // Load initial favourites on screen open
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(paginatedFavouritesProvider.notifier).loadInitial();
    });
  }

  @override
  Widget build(BuildContext context) {
    final favouritesState = ref.watch(paginatedFavouritesProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Favourites')),
      body: favouritesState.error != null
          ? Center(child: Text(favouritesState.error.toString()))
          : favouritesState.words.isEmpty && favouritesState.isLoadingMore
              ? const Center(child: CircularProgressIndicator())
              : favouritesState.words.isEmpty
                  ? const Center(child: Text('No favourites yet.'))
                  : PaginatedWordListView(
                      words: favouritesState.words,
                      hasMore: favouritesState.hasMore,
                      isLoadingMore: favouritesState.isLoadingMore,
                      onLoadMore: () => ref
                          .read(paginatedFavouritesProvider.notifier)
                          .loadMore(),
                      emptyText: 'No favourites yet.',
                      onWordLongPress: (word) =>
                          WordInfoSnackBar.show(context, word),
                    ),
      bottomNavigationBar: const AdBanner(),
    );
  }
}
