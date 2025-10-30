import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerHotelCard extends StatelessWidget {
  const ShimmerHotelCard({super.key});

  @override
  Widget build(BuildContext context) {
    final baseColor = Colors.grey.shade300;
    final highlightColor = Colors.grey.shade100;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Shimmer.fromColors(
        baseColor: baseColor,
        highlightColor: highlightColor,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 180,
              decoration: BoxDecoration(
                color: baseColor,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(16),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 16,
                    width: 180,
                    decoration: _boxDecoration(baseColor),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    height: 14,
                    width: double.infinity,
                    decoration: _boxDecoration(baseColor),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    height: 14,
                    width: 140,
                    decoration: _boxDecoration(baseColor),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    height: 20,
                    width: 120,
                    decoration: _boxDecoration(baseColor),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  BoxDecoration _boxDecoration(Color color) {
    return BoxDecoration(color: color, borderRadius: BorderRadius.circular(8));
  }
}
