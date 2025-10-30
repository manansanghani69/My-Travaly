import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../domain/entities/hotel.dart';
import '../../domain/entities/property.dart';
import 'price_tag.dart';
import 'rating_widget.dart';

class HotelCard extends StatelessWidget {
  const HotelCard({super.key, required this.hotel});

  final Hotel hotel;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 1.5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _HotelImage(imageUrl: hotel.propertyImage),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        hotel.propertyName,
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(fontWeight: FontWeight.w700),
                      ),
                    ),
                    if (hotel.propertyType.isNotEmpty)
                      _PropertyTypeBadge(propertyType: hotel.propertyType),
                  ],
                ),
                const SizedBox(height: 12),
                RatingWidget(
                  propertyStar: hotel.propertyStar,
                  reviewRating: hotel.googleReview?.rating,
                  totalReviews: hotel.googleReview?.totalReviews,
                ),
                const SizedBox(height: 12),
                _AddressSection(address: hotel.address),
                const SizedBox(height: 16),
                PriceTag(
                  primaryPrice: hotel.staticPrice,
                  originalPrice: hotel.markedPrice,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _HotelImage extends StatelessWidget {
  const _HotelImage({required this.imageUrl});

  final String imageUrl;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      width: double.infinity,
      child: imageUrl.isEmpty
          ? Container(
              color: Colors.grey.shade200,
              child: const Icon(Icons.hotel, size: 48, color: Colors.grey),
            )
          : CachedNetworkImage(
              imageUrl: imageUrl,
              fit: BoxFit.cover,
              placeholder: (context, url) => Container(
                color: Colors.grey.shade200,
                child: const Center(child: CircularProgressIndicator()),
              ),
              errorWidget: (context, url, error) => Container(
                color: Colors.grey.shade200,
                child: const Icon(
                  Icons.broken_image,
                  size: 48,
                  color: Colors.grey,
                ),
              ),
            ),
    );
  }
}

class _PropertyTypeBadge extends StatelessWidget {
  const _PropertyTypeBadge({required this.propertyType});

  final String propertyType;

  @override
  Widget build(BuildContext context) {
    if (propertyType.isEmpty) {
      return const SizedBox.shrink();
    }

    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: theme.colorScheme.secondary.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        propertyType,
        style: theme.textTheme.labelMedium?.copyWith(
          color: theme.colorScheme.secondary,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class _AddressSection extends StatelessWidget {
  const _AddressSection({required this.address});

  final PropertyAddress address;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          Icons.location_on_outlined,
          color: theme.colorScheme.error,
          size: 20,
        ),
        const SizedBox(width: 6),
        Expanded(
          child: Text(
            [
              address.addressLine,
              address.city,
              address.state,
              address.country,
            ].where((element) => element.isNotEmpty).join(', '),
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.textTheme.bodySmall?.color?.withValues(alpha: 0.75),
            ),
          ),
        ),
      ],
    );
  }
}
