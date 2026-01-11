import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/core.dart';
import '../../state/providers.dart';
import '../../utils/word_info_snackbar.dart';
import '../../widgets/widgets.dart';

class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key});

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  String _query = '';
  int? _selectedWeek;
  int? _selectedDay;
  bool _favouritesOnly = false;
  bool _shuffled = false;

  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final wordsAsync = ref.watch(wordStoreProvider);

    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        titleSpacing: 0,
        toolbarHeight: 72,
        title: Padding(
          padding: const EdgeInsets.only(right: AppSizes.lg),
          child: Container(
            height: 44,
            padding: const EdgeInsets.symmetric(horizontal: AppSizes.md),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: Theme.of(
                  context,
                ).colorScheme.primary.withValues(alpha: 0.35),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.search,
                  size: 22,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: TextField(
                    controller: _controller,
                    autofocus: true,
                    textAlignVertical: TextAlignVertical.center,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                    decoration: InputDecoration(
                      hintText: 'Search',
                      hintStyle:
                          Theme.of(context).textTheme.titleSmall?.copyWith(
                                color: Theme.of(
                                  context,
                                ).colorScheme.onSurfaceVariant,
                                fontWeight: FontWeight.w600,
                              ),
                      border: InputBorder.none,
                      isCollapsed: true,
                    ),
                    onChanged: (v) =>
                        setState(() => _query = v.trim().toLowerCase()),
                  ),
                ),
                if (_query.isNotEmpty)
                  IconButton(
                    tooltip: 'Clear',
                    visualDensity: VisualDensity.compact,
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints.tightFor(
                      width: 32,
                      height: 32,
                    ),
                    onPressed: () {
                      _controller.clear();
                      setState(() => _query = '');
                    },
                    icon: Icon(
                      Icons.close,
                      size: 20,
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          // Filters section
          Container(
            padding: const EdgeInsets.all(AppSizes.md),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              border: Border(
                bottom: BorderSide(
                  color: Theme.of(context).dividerColor,
                  width: 1,
                ),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Filter label and actions row
                Row(
                  children: [
                    Icon(
                      Icons.filter_list,
                      size: 18,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      'Filters',
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(
                            fontWeight: FontWeight.w700,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                    ),
                    const Spacer(),
                    // Shuffle button
                    IconButton(
                      tooltip: _shuffled ? 'Unshuffle' : 'Shuffle',
                      visualDensity: VisualDensity.compact,
                      icon: Icon(
                        Icons.shuffle,
                        size: 20,
                        color: _shuffled
                            ? Theme.of(context).colorScheme.primary
                            : Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                      onPressed: () => setState(() => _shuffled = !_shuffled),
                    ),
                    // Clear all button
                    if (_selectedWeek != null ||
                        _selectedDay != null ||
                        _favouritesOnly)
                      TextButton.icon(
                        onPressed: () {
                          setState(() {
                            _selectedWeek = null;
                            _selectedDay = null;
                            _favouritesOnly = false;
                          });
                        },
                        icon: const Icon(Icons.clear_all, size: 16),
                        label: const Text('Clear'),
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          visualDensity: VisualDensity.compact,
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: AppSizes.sm),
                // Filter chips
                Wrap(
                  spacing: AppSizes.sm,
                  runSpacing: AppSizes.sm,
                  children: [
                    _FilterChip(
                      icon: Icons.calendar_month,
                      label: _selectedWeek == null
                          ? 'Week'
                          : 'Week $_selectedWeek',
                      selected: _selectedWeek != null,
                      onTap: () => _showWeekPicker(),
                      onClear: _selectedWeek != null
                          ? () => setState(() => _selectedWeek = null)
                          : null,
                    ),
                    _FilterChip(
                      icon: Icons.today,
                      label: _selectedDay == null ? 'Day' : 'Day $_selectedDay',
                      selected: _selectedDay != null,
                      onTap: () => _showDayPicker(),
                      onClear: _selectedDay != null
                          ? () => setState(() => _selectedDay = null)
                          : null,
                    ),
                    _FilterChip(
                      icon: Icons.star,
                      label: 'Favourites',
                      selected: _favouritesOnly,
                      onTap: () =>
                          setState(() => _favouritesOnly = !_favouritesOnly),
                      onClear: _favouritesOnly
                          ? () => setState(() => _favouritesOnly = false)
                          : null,
                    ),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: wordsAsync.when(
              data: (words) {
                var filtered = words;

                // Apply text search filter
                if (_query.isNotEmpty) {
                  filtered = filtered.where((w) {
                    return w.kanji.toLowerCase().contains(_query) ||
                        w.kana.toLowerCase().contains(_query) ||
                        w.english.toLowerCase().contains(_query) ||
                        w.meaning.toLowerCase().contains(_query);
                  }).toList(growable: false);
                }

                // Apply week filter
                if (_selectedWeek != null) {
                  filtered = filtered.where((w) {
                    final week = ((w.day - 1) ~/ 7) + 1;
                    return week == _selectedWeek;
                  }).toList(growable: false);
                }

                // Apply day filter
                if (_selectedDay != null) {
                  filtered = filtered.where((w) {
                    final dayOfWeek = ((w.day - 1) % 7) + 1;
                    return dayOfWeek == _selectedDay;
                  }).toList(growable: false);
                }

                // Apply favourites filter
                if (_favouritesOnly) {
                  filtered = filtered
                      .where((w) => w.isFavourite)
                      .toList(growable: false);
                }

                // Apply shuffle
                if (_shuffled) {
                  filtered = List.from(filtered)..shuffle();
                }

                return Column(
                  children: [
                    // Word count
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSizes.md,
                        vertical: AppSizes.sm,
                      ),
                      color: Theme.of(
                        context,
                      ).colorScheme.surfaceContainerHighest,
                      child: Row(
                        children: [
                          Icon(
                            Icons.list_alt,
                            size: 16,
                            color: Theme.of(
                              context,
                            ).colorScheme.onSurfaceVariant,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            '${filtered.length} ${filtered.length == 1 ? 'word' : 'words'}',
                            style: Theme.of(context)
                                .textTheme
                                .labelMedium
                                ?.copyWith(
                                  fontWeight: FontWeight.w600,
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.onSurfaceVariant,
                                ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: WordListView(
                        words: filtered,
                        emptyText: 'No results.',
                        onWordLongPress: (word) =>
                            WordInfoSnackBar.show(context, word),
                      ),
                    ),
                  ],
                );
              },
              error: (e, st) => Center(child: Text(e.toString())),
              loading: () => const Center(child: CircularProgressIndicator()),
            ),
          ),
        ],
      ),
      bottomNavigationBar: const AdBanner(),
    );
  }

  void _showWeekPicker() {
    showDialog<int>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Select Week'),
        content: SizedBox(
          width: double.minPositive,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: 8,
            itemBuilder: (context, index) {
              final week = index + 1;
              return ListTile(
                title: Text('Week $week'),
                selected: _selectedWeek == week,
                onTap: () {
                  Navigator.of(context).pop();
                  setState(() => _selectedWeek = week);
                },
              );
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }

  void _showDayPicker() {
    showDialog<int>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Select Day'),
        content: SizedBox(
          width: double.minPositive,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: 7,
            itemBuilder: (context, index) {
              final day = index + 1;
              return ListTile(
                title: Text('Day $day'),
                selected: _selectedDay == day,
                onTap: () {
                  Navigator.of(context).pop();
                  setState(() => _selectedDay = day);
                },
              );
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  const _FilterChip({
    required this.label,
    required this.selected,
    required this.onTap,
    this.icon,
    this.onClear,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;
  final IconData? icon;
  final VoidCallback? onClear;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSizes.md,
          vertical: AppSizes.sm,
        ),
        decoration: BoxDecoration(
          color: selected
              ? Theme.of(context).colorScheme.primaryContainer
              : Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: selected
                ? Theme.of(context).colorScheme.primary
                : Theme.of(context).colorScheme.outline.withValues(alpha: 0.5),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Icon(
                icon,
                size: 16,
                color: selected
                    ? Theme.of(context).colorScheme.onPrimaryContainer
                    : Theme.of(context).colorScheme.onSurface,
              ),
              const SizedBox(width: 6),
            ],
            Text(
              label,
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    color: selected
                        ? Theme.of(context).colorScheme.onPrimaryContainer
                        : Theme.of(context).colorScheme.onSurface,
                    fontWeight: selected ? FontWeight.w700 : FontWeight.w600,
                  ),
            ),
            if (onClear != null) const SizedBox(width: 4),
            if (onClear != null)
              InkWell(
                onTap: onClear,
                child: Icon(
                  Icons.close,
                  size: 16,
                  color: Theme.of(context).colorScheme.onPrimaryContainer,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
