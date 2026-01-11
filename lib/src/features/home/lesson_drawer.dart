import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/core.dart';
import '../../widgets/furigana_text.dart';
import 'week_day_data.dart';

class LessonDrawer extends StatefulWidget {
  const LessonDrawer({
    required this.currentWeek,
    required this.currentDay,
    required this.onSelect,
    super.key,
  });

  final int currentWeek;
  final int currentDay;
  final Future<void> Function(int week, int day) onSelect;

  @override
  State<LessonDrawer> createState() => _LessonDrawerState();
}

class _LessonDrawerState extends State<LessonDrawer> {
  int? _openWeek;
  late int _selectedWeek;
  late int _selectedDay;

  @override
  void initState() {
    super.initState();
    _openWeek = widget.currentWeek;
    _selectedWeek = widget.currentWeek;
    _selectedDay = widget.currentDay;
  }

  @override
  void didUpdateWidget(covariant LessonDrawer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.currentWeek != widget.currentWeek) {
      _openWeek = widget.currentWeek;
    }
    if (oldWidget.currentWeek != widget.currentWeek ||
        oldWidget.currentDay != widget.currentDay) {
      _selectedWeek = widget.currentWeek;
      _selectedDay = widget.currentDay;
    }
  }

  @override
  Widget build(BuildContext context) {
    const dividerColor = AppColors.divider;
    const leftIconSize = 18.0;
    const leftIconGap = AppSizes.sm;
    const headerHorizontalPadding = AppSizes.md;

    final weekStyle = Theme.of(
      context,
    ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700);

    return Drawer(
      child: SafeArea(
        top: false,
        child: Column(
          children: [
            Container(
              width: double.infinity,
              color: Theme.of(context).colorScheme.primary,
              child: SafeArea(
                bottom: false,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSizes.lg,
                    vertical: AppSizes.xl,
                  ),
                  child: Column(
                    children: [
                      Text(
                        '日本語総まとめ',
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.headlineSmall
                            ?.copyWith(
                              color: Theme.of(context).colorScheme.onPrimary,
                              fontWeight: FontWeight.w900,
                              letterSpacing: 1.2,
                            ),
                      ),
                      const SizedBox(height: AppSizes.lg),
                      Text(
                        'N2 漢字',
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.displaySmall
                            ?.copyWith(
                              color: Theme.of(context).colorScheme.onPrimary,
                              fontWeight: FontWeight.w900,
                              letterSpacing: 1.2,
                            ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                padding: EdgeInsets.zero,
                itemCount: weekTitles.length,
                itemBuilder: (context, weekIndex) {
                  final week = weekIndex + 1;
                  final isExpanded = _openWeek == week;

                  return Column(
                    children: [
                      if (weekIndex != 0)
                        const Divider(
                          height: 1,
                          thickness: 1,
                          color: dividerColor,
                        ),
                      InkWell(
                        onTap: () {
                          setState(() {
                            _openWeek = isExpanded ? null : week;
                          });
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: headerHorizontalPadding,
                            vertical: AppSizes.xs,
                          ),
                          child: Row(
                            children: [
                              Icon(
                                isExpanded
                                    ? Icons.expand_less
                                    : Icons.expand_more,
                                size: leftIconSize,
                                color: Colors.grey,
                              ),
                              const SizedBox(width: leftIconGap),
                              Expanded(
                                child: FuriganaText(
                                  weekTitles[weekIndex],
                                  baseStyle: weekStyle,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      if (isExpanded)
                        _DrawerWeekBody(
                          week: week,
                          days: dayTitlesByWeek[weekIndex],
                          selectedWeek: _selectedWeek,
                          selectedDay: _selectedDay,
                          dividerColor: dividerColor,
                          leftIndent:
                              headerHorizontalPadding +
                              leftIconSize +
                              leftIconGap,
                          onSelect: (selectedWeek, selectedDay) async {
                            setState(() {
                              _selectedWeek = selectedWeek;
                              _selectedDay = selectedDay;
                            });
                            await widget.onSelect(selectedWeek, selectedDay);
                          },
                        ),
                    ],
                  );
                },
              ),
            ),
            const Divider(height: 1, thickness: 1, color: dividerColor),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSizes.sm,
                vertical: AppSizes.s6,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: InkWell(
                      onTap: () => context.push('/about'),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: AppSizes.s6,
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.info_outline, size: 22),
                            const SizedBox(height: 4),
                            Text(
                              'About',
                              style: Theme.of(context).textTheme.labelSmall
                                  ?.copyWith(fontWeight: FontWeight.w700),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: InkWell(
                      onTap: () => context.push('/favourites'),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: AppSizes.s6,
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.star_border, size: 22),
                            const SizedBox(height: 4),
                            Text(
                              'Favourites',
                              style: Theme.of(context).textTheme.labelSmall
                                  ?.copyWith(fontWeight: FontWeight.w700),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: InkWell(
                      onTap: () => context.push('/search'),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: AppSizes.s6,
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.search_outlined, size: 22),
                            const SizedBox(height: 4),
                            Text(
                              'Search',
                              style: Theme.of(context).textTheme.labelSmall
                                  ?.copyWith(fontWeight: FontWeight.w700),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DrawerWeekBody extends StatelessWidget {
  const _DrawerWeekBody({
    required this.week,
    required this.days,
    required this.selectedWeek,
    required this.selectedDay,
    required this.dividerColor,
    required this.leftIndent,
    required this.onSelect,
  });

  final int week;
  final List<String> days;
  final int selectedWeek;
  final int selectedDay;
  final Color dividerColor;
  final double leftIndent;
  final Future<void> Function(int week, int day) onSelect;

  @override
  Widget build(BuildContext context) {
    final dayStyle = Theme.of(
      context,
    ).textTheme.bodyMedium?.copyWith(fontSize: 14, fontWeight: FontWeight.w600);
    final selectedTextColor = Theme.of(context).colorScheme.primary;

    return Column(
      children: [
        for (var dayIndex = 0; dayIndex < days.length; dayIndex++) ...[
          Divider(height: 1, thickness: 1, color: dividerColor),
          ListTile(
            dense: true,
            visualDensity: VisualDensity.compact,
            contentPadding: EdgeInsetsDirectional.only(
              start: leftIndent,
              end: 8,
            ),
            selected: week == selectedWeek && (dayIndex + 1) == selectedDay,
            title: FuriganaText(
              days[dayIndex],
              baseStyle: (week == selectedWeek && (dayIndex + 1) == selectedDay)
                  ? dayStyle?.copyWith(
                      color: selectedTextColor,
                      fontWeight: FontWeight.w900,
                    )
                  : dayStyle,
            ),
            onTap: () => onSelect(week, dayIndex + 1),
          ),
        ],
      ],
    );
  }
}
