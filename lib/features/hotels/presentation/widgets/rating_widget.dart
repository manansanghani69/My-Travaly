import 'package:flutter/material.dart';

class RatingWidget extends StatelessWidget {
  const RatingWidget({
    super.key,
    required this.propertyStar,
    this.reviewRating,
    this.totalReviews,
  });

  final int propertyStar;
  final double? reviewRating;
  final int? totalReviews;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final hasReviews = reviewRating != null && reviewRating! > 0;

    return Wrap(
      crossAxisAlignment: WrapCrossAlignment.center,
      spacing: 12,
      runSpacing: 4,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.star_rounded, size: 18, color: Colors.amber),
            const SizedBox(width: 4),
            Text(
              propertyStar.toString(),
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(width: 4),
            Text(
              'Property rating',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.textTheme.bodySmall?.color?.withValues(alpha: 0.6),
              ),
            ),
          ],
        ),
        if (hasReviews)
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.reviews_outlined, size: 18, color: Colors.teal),
              const SizedBox(width: 4),
              Text(
                reviewRating!.toStringAsFixed(1),
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              if (totalReviews != null && totalReviews! > 0) ...[
                const SizedBox(width: 4),
                Text(
                  '(${totalReviews!})',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.textTheme.bodySmall?.color?.withValues(
                      alpha: 0.6,
                    ),
                  ),
                ),
              ],
            ],
          ),
      ],
    );
  }
}
