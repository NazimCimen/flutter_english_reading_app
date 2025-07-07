import 'package:english_reading_app/core/size/constant_size.dart';
import 'package:english_reading_app/core/size/padding_extension.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ProfileSkeleton extends StatelessWidget {
  const ProfileSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Profil Kartı
        ShimmerContainer(
          height: context.cXxLargeValue * 1.25,
          width: double.infinity,
          borderRadius: context.cLowValue * 1.5,
        ),
        SizedBox(height: context.cMediumValue),

        // Kişisel Bilgiler
        Padding(
          padding: context.cPaddingMedium,
          child: _buildInfoSkeleton(context),
        ),
        SizedBox(height: context.cMediumValue),
      ],
    );
  }

  // Kişisel Bilgiler İçin Skeleton
  Widget _buildInfoSkeleton(BuildContext context) {
    return Column(
      children: List.generate(
        7,
        (index) => Padding(
          padding: EdgeInsets.only(bottom: context.cLowValue * 1.5),
          child: Row(
            children: [
              ShimmerContainer(
                height: context.cXLargeValue * 1.5,
                width: context.cXLargeValue * 1.5,
                borderRadius: 10,
              ),
              const SizedBox(width: 16),
              const Expanded(
                child: ShimmerContainer(
                  height: 20,
                  width: double.infinity,
                  borderRadius: 8,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Shimmer İçin Ortak Kullanılan Container Widget'ı
class ShimmerContainer extends StatelessWidget {
  final double height;
  final double width;
  final double borderRadius;

  const ShimmerContainer({
    required this.height,
    required this.width,
    required this.borderRadius,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Theme.of(context).colorScheme.surface,
      highlightColor: Theme.of(context).colorScheme.outline,
      child: Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
      color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(borderRadius),
        ),
      ),
    );
  }
}
