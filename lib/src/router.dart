import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'domain/models/word.dart';
import 'features/about/about_screen.dart';
import 'features/favourites/favourites_screen.dart';
import 'features/home/home_screen.dart';
import 'features/practice/kanji_practice_screen.dart';
import 'features/search/search_screen.dart';
import 'features/word_detail/word_detail_screen.dart';

GoRouter createRouter() {
  return GoRouter(
    routes: <RouteBase>[
      GoRoute(path: '/', builder: (context, state) => const HomeScreen()),
      GoRoute(
        path: '/search',
        builder: (context, state) => const SearchScreen(),
      ),
      GoRoute(
        path: '/favourites',
        builder: (context, state) => const FavouritesScreen(),
      ),
      GoRoute(path: '/about', builder: (context, state) => const AboutScreen()),
      GoRoute(
        path: '/practice/kanji',
        builder: (context, state) {
          final character = state.extra;
          if (character is! String || character.isEmpty) {
            return const Scaffold(body: Center(child: Text('Invalid kanji')));
          }
          return KanjiPracticeScreen(character: character);
        },
      ),
      GoRoute(
        path: '/word',
        builder: (context, state) {
          final w = state.extra;
          if (w is! Word) {
            return const Scaffold(body: Center(child: Text('Invalid word')));
          }
          return WordDetailScreen(word: w);
        },
      ),
    ],
    errorBuilder: (context, state) {
      return Scaffold(
        appBar: AppBar(title: const Text('N2 Kanji')),
        body: Center(child: Text(state.error.toString())),
      );
    },
  );
}
