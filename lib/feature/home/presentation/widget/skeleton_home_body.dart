import 'package:english_reading_app/core/size/app_border_radius_extensions.dart';
import 'package:english_reading_app/core/size/constant_size.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class SkeletonHomeBody extends StatelessWidget {
  const SkeletonHomeBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: context.cLowValue),
        Expanded(
          child: Column(
            children: [
              ...List.generate(
                3,
                (index) => Padding(
                  padding: EdgeInsets.only(bottom: context.cMediumValue),
                  child: const SkeletonArticleCard(),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class SkeletonArticleCard extends StatelessWidget {
  const SkeletonArticleCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      shape: ContinuousRectangleBorder(
        borderRadius: context.borderRadiusAllLow,
      ),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: context.cLowValue),
        width: double.infinity,

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: context.cMediumValue),
            const ImageShimmer(),
            SizedBox(height: context.cLowValue),
            Shimmer.fromColors(
              baseColor: Theme.of(context).colorScheme.surface,
              highlightColor: Theme.of(context).colorScheme.outline,
              child: Container(
                height: 20,
                width: double.infinity,
                color: Colors.white,
              ),
            ),
            SizedBox(height: context.cLowValue / 2),
            Row(
              children: [
                Shimmer.fromColors(
                  baseColor: Theme.of(context).colorScheme.surface,
                  highlightColor: Theme.of(context).colorScheme.outline,
                  child: Container(height: 16, width: 50, color: Colors.white),
                ),
                SizedBox(width: context.cLowValue / 2),
                Icon(
                  Icons.circle,
                  size: 6,
                  color: Theme.of(context).colorScheme.outline,
                ),
                SizedBox(width: context.cLowValue / 2),
                Shimmer.fromColors(
                  baseColor: Theme.of(context).colorScheme.surface,
                  highlightColor: Theme.of(context).colorScheme.outline,
                  child: Container(height: 14, width: 60, color: Colors.white),
                ),
              ],
            ),
            SizedBox(height: context.cMediumValue),
          ],
        ),
      ),
    );
  }
}

class ImageShimmer extends StatelessWidget {
  const ImageShimmer({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 16 / 9,
      child: Shimmer.fromColors(
        baseColor: Theme.of(context).colorScheme.surface,
        highlightColor: Theme.of(context).colorScheme.outline,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.vertical(
              top: context.cBorderRadiusAllMedium.topLeft,
            ),
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
