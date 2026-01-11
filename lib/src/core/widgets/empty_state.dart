import 'package:flutter/material.dart';

/// Reusable empty state display widget.
class EmptyState extends StatelessWidget {
  const EmptyState({required this.message, super.key, this.icon});

  final String message;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null)
            Icon(
              icon,
              size: 48,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          if (icon != null) const SizedBox(height: 16),
          Text(
            message,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}
