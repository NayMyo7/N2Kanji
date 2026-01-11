import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';

import '../../core/core.dart';
import '../../domain/models/word.dart';

/// Flashcards feature with clean state management
///
/// Navigation modes:
/// - Sequential: Cards in order 0→1→2→...→N
/// - Shuffle: Random cards without duplicates in history
///
/// User actions:
/// - Swipe: Advance to next card (any direction)
/// - Next button: Move forward in navigation
/// - Prev button: Go back in history
/// - Shuffle toggle: Switch between modes
class FlashcardsTab extends StatefulWidget {
  const FlashcardsTab({required this.words, super.key});

  final List<Word> words;

  @override
  State<FlashcardsTab> createState() => _FlashcardsTabState();
}

class _FlashcardsTabState extends State<FlashcardsTab> {
  final CardSwiperController _controller = CardSwiperController();
  final Random _random = Random();

  // Navigation state
  late _NavigationState _navState;

  // UI state
  bool _showFront = true;
  bool _reverse = false;

  @override
  void initState() {
    super.initState();
    _navState = _NavigationState(totalCards: widget.words.length);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant FlashcardsTab oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.words != widget.words) {
      setState(() {
        _navState = _NavigationState(totalCards: widget.words.length);
        _showFront = true;
      });
      _controller.moveTo(0);
    }
  }

  // ==================== Navigation Logic ====================

  /// Navigate to next card
  void _next() {
    if (widget.words.isEmpty) return;

    if (_navState.shuffleMode) {
      // In shuffle mode, handle state update here since we use moveTo
      final result = _navState.moveNext(_random);

      if (result.isCompleted) {
        setState(() {
          _navState = _navState.copyWith(isCompleted: true);
        });
        return;
      }

      if (result.newIndex == null) return;

      setState(() {
        _navState = result.newState;
        _showFront = true;
      });
      _controller.moveTo(result.newIndex!);
    } else {
      // In sequential mode, just trigger swipe - onSwipe callback will handle state
      _controller.swipe(CardSwiperDirection.right);
    }
  }

  /// Navigate to previous card
  void _prev() {
    if (widget.words.isEmpty) return;

    final result = _navState.movePrev();

    if (result.newIndex == null) return; // At start of history

    setState(() {
      _navState = result.newState;
      _showFront = true;
    });

    _controller.moveTo(result.newIndex!);
  }

  /// Handle swipe gesture (always advances forward)
  void _handleSwipe() {
    final result = _navState.moveNext(_random);

    if (result.isCompleted) {
      setState(() {
        _navState = _navState.copyWith(isCompleted: true);
      });
      return;
    }

    if (result.newIndex != null) {
      setState(() {
        _navState = result.newState;
        _showFront = true;
      });
    }
  }

  /// Toggle shuffle mode
  void _toggleShuffle() {
    setState(() {
      _navState = _navState.copyWith(shuffleMode: !_navState.shuffleMode);
    });
  }

  /// Restart flashcards
  void _restart() {
    setState(() {
      _navState = _NavigationState(totalCards: widget.words.length);
      _showFront = true;
    });
    _controller.moveTo(0);
  }

  // ==================== UI ====================

  @override
  Widget build(BuildContext context) {
    if (widget.words.isEmpty) {
      return const Center(child: Text('No words for this kanji.'));
    }

    if (_navState.isCompleted) {
      return _buildCompletionScreen();
    }

    return Column(
      children: [
        _buildHeader(),
        Expanded(child: _buildCardSwiper()),
        _buildNavigationControls(),
      ],
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSizes.lg,
        vertical: AppSizes.sm,
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              'Words: ${_navState.currentIndex + 1}/${widget.words.length}',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
            ),
          ),
          Expanded(
            child: TextButton.icon(
              onPressed: () => setState(() => _reverse = !_reverse),
              icon: const Icon(Icons.swap_horiz),
              label: Text(_reverse ? 'Meaning → Kanji' : 'Kanji → Meaning'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCardSwiper() {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSizes.lg,
        vertical: AppSizes.md,
      ),
      child: CardSwiper(
        controller: _controller,
        cardsCount: widget.words.length,
        numberOfCardsDisplayed: min(3, widget.words.length),
        backCardOffset: const Offset(20, 18),
        padding: EdgeInsets.zero,
        isLoop: false,
        allowedSwipeDirection: const AllowedSwipeDirection.only(
          left: true,
          right: true,
        ),
        initialIndex: _navState.currentIndex,
        onSwipe: (previousIndex, currentIndex, direction) {
          _handleSwipe();
          return !_navState.shuffleMode; // Allow animation in sequential mode
        },
        cardBuilder: (context, index, horizontalThreshold, verticalThreshold) {
          if (index >= widget.words.length) {
            return const SizedBox.shrink();
          }

          final word = widget.words[index];
          final isTopCard = index == _navState.currentIndex;
          final showFront = isTopCard ? _showFront : true;

          return Card(
            elevation: 5,
            child: InkWell(
              onTap: isTopCard
                  ? () => setState(() => _showFront = !_showFront)
                  : null,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(AppSizes.lg),
                alignment: Alignment.center,
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 220),
                  switchInCurve: Curves.easeOut,
                  switchOutCurve: Curves.easeIn,
                  transitionBuilder: (child, animation) {
                    return ScaleTransition(scale: animation, child: child);
                  },
                  child: KeyedSubtree(
                    key: ValueKey('$index-$showFront'),
                    child: _buildCardFace(word, showFront),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildCardFace(Word word, bool showFront) {
    if (showFront) {
      return _reverse
          ? _FlashCardFace(word: word, variant: _FaceVariant.meaning)
          : _FlashCardFace(word: word, variant: _FaceVariant.kanji);
    } else {
      return _reverse
          ? _FlashCardFace(word: word, variant: _FaceVariant.kanjiKana)
          : _FlashCardFace(
              word: word,
              variant: _FaceVariant.kanaMeaningEnglish,
            );
    }
  }

  Widget _buildNavigationControls() {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSizes.lg,
        vertical: AppSizes.s6,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconButton(
            onPressed: _navState.canMovePrev ? _prev : null,
            icon: const Icon(Icons.chevron_left),
            iconSize: 32,
            tooltip: 'Previous card',
          ),
          const Spacer(),
          IconButton(
            onPressed: _toggleShuffle,
            icon: Icon(
              Icons.shuffle,
              color: _navState.shuffleMode
                  ? AppColors.accent
                  : Theme.of(
                      context,
                    ).colorScheme.onSurface.withValues(alpha: 0.6),
            ),
            iconSize: 28,
            tooltip: _navState.shuffleMode ? 'Shuffle: ON' : 'Shuffle: OFF',
          ),
          const Spacer(),
          IconButton(
            onPressed: _next,
            icon: const Icon(Icons.chevron_right),
            iconSize: 32,
            tooltip: 'Next card',
          ),
        ],
      ),
    );
  }

  Widget _buildCompletionScreen() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.check_circle_outline,
            size: 64,
            color: AppColors.accent,
          ),
          const SizedBox(height: AppSizes.lg),
          Text(
            'All cards reviewed!',
            style: Theme.of(
              context,
            ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: AppSizes.xl),
          ElevatedButton.icon(
            onPressed: _restart,
            icon: const Icon(Icons.refresh),
            label: const Text('Restart'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.accent,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(
                horizontal: AppSizes.xl,
                vertical: AppSizes.md,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ==================== Navigation State ====================

/// Immutable navigation state with all logic encapsulated
class _NavigationState {
  final int currentIndex;
  final List<int> history;
  final int historyPosition;
  final Set<int> visitedCards;
  final bool shuffleMode;
  final bool isCompleted;
  final int totalCards;

  _NavigationState({
    this.currentIndex = 0,
    List<int>? history,
    this.historyPosition = 0,
    Set<int>? visitedCards,
    this.shuffleMode = false,
    this.isCompleted = false,
    required this.totalCards,
  }) : history = history ?? [0],
       visitedCards = visitedCards ?? {0};

  /// Check if can move to previous card
  bool get canMovePrev => historyPosition > 0;

  /// Check if all cards have been visited
  bool get allCardsVisited => visitedCards.length >= totalCards;

  /// Move to next card
  _NavigationResult moveNext(Random random) {
    // Check if we can move forward in existing history
    if (historyPosition < history.length - 1) {
      final nextIndex = history[historyPosition + 1];
      final newVisited = {...visitedCards, nextIndex};
      return _NavigationResult(
        newState: copyWith(
          currentIndex: nextIndex,
          historyPosition: historyPosition + 1,
          visitedCards: newVisited,
        ),
        newIndex: nextIndex,
        isCompleted: false,
      );
    }

    // Check if all cards already visited before generating new card
    if (allCardsVisited) {
      return _NavigationResult(
        newState: this,
        newIndex: null,
        isCompleted: true,
      );
    }

    // Generate new card
    final nextIndex = _getNextIndex(random);

    if (nextIndex == currentIndex) {
      // Can't move forward (at end in sequential mode)
      return _NavigationResult(
        newState: this,
        newIndex: null,
        isCompleted: true,
      );
    }

    final newVisited = {...visitedCards, nextIndex};
    return _NavigationResult(
      newState: copyWith(
        currentIndex: nextIndex,
        history: [...history, nextIndex],
        historyPosition: historyPosition + 1,
        visitedCards: newVisited,
      ),
      newIndex: nextIndex,
      isCompleted: false,
    );
  }

  /// Move to previous card
  _NavigationResult movePrev() {
    if (!canMovePrev) {
      return _NavigationResult(
        newState: this,
        newIndex: null,
        isCompleted: false,
      );
    }

    final prevIndex = history[historyPosition - 1];
    return _NavigationResult(
      newState: copyWith(
        currentIndex: prevIndex,
        historyPosition: historyPosition - 1,
        visitedCards: {...visitedCards, prevIndex},
      ),
      newIndex: prevIndex,
      isCompleted: false,
    );
  }

  /// Get next card index based on mode
  int _getNextIndex(Random random) {
    if (shuffleMode) {
      // Get cards not in history to avoid duplicates
      final historySet = history.toSet();
      final availableCards = List.generate(
        totalCards,
        (i) => i,
      ).where((i) => !historySet.contains(i)).toList();

      if (availableCards.isNotEmpty) {
        return availableCards[random.nextInt(availableCards.length)];
      }

      // All cards in history, pick random different from current
      int nextIndex;
      do {
        nextIndex = random.nextInt(totalCards);
      } while (nextIndex == currentIndex && totalCards > 1);
      return nextIndex;
    } else {
      // Sequential mode
      final nextIndex = currentIndex + 1;
      return nextIndex >= totalCards ? currentIndex : nextIndex;
    }
  }

  /// Create a copy with updated fields
  _NavigationState copyWith({
    int? currentIndex,
    List<int>? history,
    int? historyPosition,
    Set<int>? visitedCards,
    bool? shuffleMode,
    bool? isCompleted,
  }) {
    return _NavigationState(
      currentIndex: currentIndex ?? this.currentIndex,
      history: history ?? this.history,
      historyPosition: historyPosition ?? this.historyPosition,
      visitedCards: visitedCards ?? this.visitedCards,
      shuffleMode: shuffleMode ?? this.shuffleMode,
      isCompleted: isCompleted ?? this.isCompleted,
      totalCards: totalCards,
    );
  }
}

/// Result of a navigation operation
class _NavigationResult {
  final _NavigationState newState;
  final int? newIndex;
  final bool isCompleted;

  _NavigationResult({
    required this.newState,
    required this.newIndex,
    required this.isCompleted,
  });
}

// ==================== Card Face Widget ====================

class _FlashCardFace extends StatelessWidget {
  const _FlashCardFace({required this.word, required this.variant});

  final Word word;
  final _FaceVariant variant;

  @override
  Widget build(BuildContext context) {
    switch (variant) {
      case _FaceVariant.kanji:
        return Text(
          word.kanji,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 48, fontWeight: FontWeight.w800),
        );
      case _FaceVariant.kanaMeaningEnglish:
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              word.kana,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: AppSizes.md),
            Text(
              word.meaning,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: AppSizes.sm),
            Text(
              word.english,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16, color: Colors.black54),
            ),
          ],
        );
      case _FaceVariant.meaning:
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              word.meaning,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: AppSizes.radiusSm),
            Text(
              word.english,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 18, color: Colors.black54),
            ),
          ],
        );
      case _FaceVariant.kanjiKana:
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              word.kanji,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 40, fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: AppSizes.md),
            Text(
              word.kana,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w700),
            ),
          ],
        );
    }
  }
}

enum _FaceVariant { kanji, kanaMeaningEnglish, meaning, kanjiKana }
