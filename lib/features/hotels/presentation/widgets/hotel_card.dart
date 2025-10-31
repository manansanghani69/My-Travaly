import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../domain/entities/hotel.dart';
import '../../domain/entities/property.dart';

class HotelCard extends StatefulWidget {
  const HotelCard({super.key, required this.hotel});

  final Hotel hotel;

  @override
  State<HotelCard> createState() => _HotelCardState();
}

class _HotelCardState extends State<HotelCard> {
  bool _isPressed = false;

  void _setPressed(bool value) {
    setState(() => _isPressed = value);
  }

  @override
  Widget build(BuildContext context) {
    final hotel = widget.hotel;
    final theme = Theme.of(context);
    final rating = hotel.googleReview?.rating;
    final reviewCount = hotel.googleReview?.totalReviews;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: AnimatedScale(
        duration: const Duration(milliseconds: 120),
        scale: _isPressed ? 0.97 : 1,
        child: Material(
          elevation: 1,
          borderRadius: BorderRadius.circular(20),
          color: Colors.white,
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            onTap: () {},
            onTapDown: (_) => _setPressed(true),
            onTapCancel: () => _setPressed(false),
            onTapUp: (_) => _setPressed(false),
            splashColor: Colors.black.withValues(alpha: 0.05),
            highlightColor: Colors.transparent,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _HotelImageSection(
                  imageUrl: hotel.propertyImage,
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 18),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
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
                            _LocationRow(address: hotel.address),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                const Icon(Icons.star_rounded,
                                    color: Color(0xFFFFB400), size: 18),
                                const SizedBox(width: 4),
                                Text(
                                  rating != null
                                      ? rating.toStringAsFixed(1)
                                      : hotel.propertyStar.toString(),
                                  style: theme.textTheme.bodyMedium?.copyWith(
                                    fontWeight: FontWeight.w600,
                                    color: const Color(0xFF1C1C1C),
                                  ),
                                ),
                                if (reviewCount != null && reviewCount > 0)
                                  Text(
                                    '  (${reviewCount.toString()})',
                                    style: theme.textTheme.bodySmall?.copyWith(
                                      color: const Color(0xFF6F7A85),
                                    ),
                                  ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 12),
                      TextButton(
                        onPressed: () {},
                        style: TextButton.styleFrom(
                          backgroundColor: const Color(0xFF1976D2),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 18,
                            vertical: 10,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        child: const Text(
                          'View Details',
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _HotelImageSection extends StatelessWidget {
  const _HotelImageSection({
    required this.imageUrl,
  });

  final String imageUrl;

  @override
  Widget build(BuildContext context) {
    final placeholder = Container(
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: const Center(
        child: Icon(Icons.hotel_outlined, color: Colors.grey, size: 42),
      ),
    );

    return SizedBox(
      height: 180,
      width: double.infinity,
      child: ClipRRect(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        child: imageUrl.isEmpty
            ? placeholder
            : CachedNetworkImage(
                imageUrl: imageUrl,
                fit: BoxFit.cover,
                placeholder: (_, __) => placeholder,
                errorWidget: (_, __, ___) => placeholder,
              ),
      ),
    );
  }
}

class _LocationRow extends StatelessWidget {
  const _LocationRow({required this.address});

  final PropertyAddress address;

  @override
  Widget build(BuildContext context) {
    final text = [
      address.city,
      address.state,
      address.country,
    ].where((element) => element.isNotEmpty).join(', ');

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Icon(
          Icons.location_on_outlined,
          size: 16,
          color: Color(0xFF6F7A85),
        ),
        const SizedBox(width: 6),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              color: Color(0xFF6F7A85),
              fontSize: 13,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
