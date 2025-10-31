import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../domain/entities/hotel.dart';
import '../../domain/entities/property.dart';

class SearchResultCard extends StatelessWidget {
  const SearchResultCard({
    super.key,
    required this.hotel,
    this.onTap,
  });

  final Hotel hotel;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final rating = hotel.googleReview?.rating;
    final hasRating = rating != null && rating > 0;
    final hasDiscount = hotel.markedPrice.amount > hotel.staticPrice.amount;
    final ratingValue = rating ?? 0;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Material(
        elevation: 0,
        borderRadius: BorderRadius.circular(16),
        color: Colors.white,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: onTap,
          splashColor: Colors.black.withValues(alpha: 0.05),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (hasRating)
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.star_rounded,
                                size: 16, color: Color(0xFFFFB400)),
                            const SizedBox(width: 4),
                            Text(
                              ratingValue.toStringAsFixed(1),
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF1C1C1C),
                                fontSize: 13,
                              ),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '•',
                              style: TextStyle(
                                color: Colors.grey.shade500,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '${hotel.propertyStar}-star',
                              style: const TextStyle(
                                color: Color(0xFF6F7A85),
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      if (!hasRating) ...[
                        const Icon(Icons.star_border_rounded,
                            size: 16, color: Color(0xFFFFB400)),
                        const SizedBox(height: 6),
                      ] else
                        const SizedBox(height: 6),
                      Text(
                        hotel.propertyName,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF1C1C1C),
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 6),
                      _LocationDetails(address: hotel.address),
                      const SizedBox(height: 8),
                      _PricePill(
                        staticPrice: hotel.staticPrice,
                        markedPrice: hasDiscount ? hotel.markedPrice : null,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                _ImageSection(imageUrl: hotel.propertyImage),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ImageSection extends StatelessWidget {
  const _ImageSection({required this.imageUrl});

  final String imageUrl;

  @override
  Widget build(BuildContext context) {
    final placeholder = Container(
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Icon(
        Icons.photo_outlined,
        color: Colors.grey,
        size: 36,
      ),
    );

    return SizedBox(
      width: 96,
      height: 96,
      child: Stack(
        children: [
          Positioned.fill(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: imageUrl.isEmpty
                  ? placeholder
                  : CachedNetworkImage(
                      imageUrl: imageUrl,
                      fit: BoxFit.cover,
                      placeholder: (_, __) => placeholder,
                      errorWidget: (_, __, ___) => placeholder,
                    ),
            ),
          ),
          Positioned(
            top: 10,
            right: 10,
            child: Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.12),
                    blurRadius: 6,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: const Icon(
                Icons.favorite_border,
                size: 16,
                color: Color(0xFF757575),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _LocationDetails extends StatelessWidget {
  const _LocationDetails({required this.address});

  final PropertyAddress address;

  @override
  Widget build(BuildContext context) {
    final location = [
      address.city,
      address.state,
    ].where((element) => element.isNotEmpty).join(', ');
    final country = address.country;

    return Row(
      children: [
        const Icon(
          Icons.location_on_outlined,
          size: 14,
          color: Color(0xFF757575),
        ),
        const SizedBox(width: 6),
        Expanded(
          child: Text(
            location.isEmpty ? address.country : location,
            style: const TextStyle(
              fontSize: 13,
              color: Color(0xFF757575),
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        if (country.isNotEmpty) ...[
          const SizedBox(width: 6),
          const Text(
            '•',
            style: TextStyle(
              fontSize: 12,
              color: Color(0xFF9E9E9E),
            ),
          ),
          const SizedBox(width: 6),
          Text(
            country,
            style: const TextStyle(
              fontSize: 12,
              color: Color(0xFF9E9E9E),
            ),
          ),
        ],
      ],
    );
  }
}

class _PricePill extends StatelessWidget {
  const _PricePill({required this.staticPrice, this.markedPrice});

  final PriceInfo staticPrice;
  final PriceInfo? markedPrice;

  @override
  Widget build(BuildContext context) {
    final hasOriginal =
        markedPrice != null && markedPrice!.amount > staticPrice.amount;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: const Color(0xFFE8F1FF),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Text(
            '${staticPrice.formatted}/night',
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              color: Color(0xFF1966C0),
              fontSize: 13,
            ),
          ),
        ),
        if (hasOriginal) ...[
          const SizedBox(width: 8),
          Text(
            markedPrice!.formatted,
            style: const TextStyle(
              decoration: TextDecoration.lineThrough,
              color: Color(0xFF9E9E9E),
              fontSize: 12,
            ),
          ),
        ],
      ],
    );
  }
}
