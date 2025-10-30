import 'package:flutter/material.dart';

import '../../domain/entities/property.dart';

class PriceTag extends StatelessWidget {
  const PriceTag({super.key, required this.primaryPrice, this.originalPrice});

  final PriceInfo primaryPrice;
  final PriceInfo? originalPrice;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final showOriginal =
        originalPrice != null && originalPrice!.amount > primaryPrice.amount;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: theme.colorScheme.primary.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            primaryPrice.formatted,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.primary,
            ),
          ),
        ),
        if (showOriginal) ...[
          const SizedBox(width: 8),
          Text(
            originalPrice!.formatted,
            style: theme.textTheme.bodySmall?.copyWith(
              decoration: TextDecoration.lineThrough,
              color: theme.colorScheme.onSurface.withValues(alpha: 0.4),
            ),
          ),
        ],
      ],
    );
  }
}
