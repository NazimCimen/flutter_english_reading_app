import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:english_reading_app/core/size/constant_size.dart';
import 'package:english_reading_app/core/size/padding_extension.dart';
import 'package:english_reading_app/core/size/app_border_radius_extensions.dart';

/// Shimmer loading widget for word detail sheet
class WordDetailShimmer extends StatelessWidget {
  const WordDetailShimmer({super.key});

  /// Builds the shimmer loading UI
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: context.paddingAllMedium,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _WordDetailShimmerDragHandle(),
          _WordDetailShimmerHeader(),
          SizedBox(height: context.cLowValue),
          _WordDetailShimmerActionButtons(),
          SizedBox(height: context.cMediumValue),
          _WordDetailShimmerOrigin(),
          SizedBox(height: context.cMediumValue),
          ...List.generate(2, (i) => _WordDetailShimmerMeaningSection()),
          SizedBox(height: context.cXLargeValue),
        ],
      ),
    );
  }
}

/// Shimmer widget for the drag handle
class _WordDetailShimmerDragHandle extends StatelessWidget {
  /// Builds the drag handle shimmer UI
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: context.cXLargeValue,
        height: context.cLowValue / 2,
        margin: EdgeInsets.only(bottom: context.cLargeValue),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.outline,
          borderRadius: context.borderRadiusAllXLow,
        ),
      ),
    );
  }
}

/// Shimmer widget for the word header
class _WordDetailShimmerHeader extends StatelessWidget {
  /// Builds the header shimmer UI
  @override
  Widget build(BuildContext context) {
    return Center(
      child: ShimmerContainer(
        height: context.cXLargeValue,
        width: context.cXxLargeValue,
        borderRadius: context.cLowValue,
      ),
    );
  }
}

/// Shimmer widget for the action buttons
class _WordDetailShimmerActionButtons extends StatelessWidget {
  /// Builds the action buttons shimmer UI
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ShimmerContainer(
          height: context.cXLargeValue, 
          width: context.cXLargeValue, 
          borderRadius: context.cXLargeValue
        ),
        SizedBox(width: context.cMediumValue),
        ShimmerContainer(
          height: context.cXLargeValue, 
          width: context.cXLargeValue, 
          borderRadius: context.cXLargeValue
        ),
      ],
    );
  }
}

/// Shimmer widget for the origin section
class _WordDetailShimmerOrigin extends StatelessWidget {
  /// Builds the origin shimmer UI
  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ShimmerContainer(
          height: context.cLargeValue, 
          width: context.cLargeValue, 
          borderRadius: context.cLowValue
        ),
        SizedBox(width: context.cLowValue),
        Expanded(
          child: ShimmerContainer(
            height: context.cMediumValue,
            width: double.infinity,
            borderRadius: context.cLowValue,
          ),
        ),
      ],
    );
  }
}

/// Shimmer widget for the meaning section
class _WordDetailShimmerMeaningSection extends StatelessWidget {
  /// Builds the meaning section shimmer UI
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            ShimmerContainer(
              height: context.cMediumValue, 
              width: context.cMediumValue, 
              borderRadius: context.cLowValue / 2
            ),
            SizedBox(width: context.cLowValue / 2),
            ShimmerContainer(
              height: context.cMediumValue, 
              width: context.cXLargeValue, 
              borderRadius: context.cLowValue
            ),
          ],
        ),
        SizedBox(height: context.cLowValue / 2),
        ...List.generate(2, (i) => _WordDetailShimmerDefinitionSection()),
        SizedBox(height: context.cMediumValue),
      ],
    );
  }
}

/// Shimmer widget for the definition section
class _WordDetailShimmerDefinitionSection extends StatelessWidget {
  /// Builds the definition section shimmer UI
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: context.cLowValue, bottom: context.cLowValue),
      padding: context.paddingAllLow,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: context.borderRadiusAllLow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ShimmerContainer(
            height: context.cMediumValue, 
            width: double.infinity, 
            borderRadius: context.cLowValue
          ),
          SizedBox(height: context.cLowValue / 2),
          ShimmerContainer(
            height: context.cMediumValue, 
            width: context.cXxLargeValue, 
            borderRadius: context.cLowValue
          ),
          SizedBox(height: context.cLowValue / 2),
          Row(
            children: [
              ...List.generate(
                3,
                (i) => Padding(
                  padding: EdgeInsets.only(right: context.cLowValue / 2),
                  child: ShimmerContainer(
                    height: context.cLargeValue,
                    width: context.cXLargeValue,
                    borderRadius: context.cMediumValue,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Reusable shimmer container widget
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

  /// Builds the shimmer container UI
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