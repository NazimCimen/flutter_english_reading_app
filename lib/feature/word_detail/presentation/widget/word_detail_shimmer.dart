import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:english_reading_app/core/size/constant_size.dart';
import 'package:english_reading_app/core/size/padding_extension.dart';
import 'package:english_reading_app/core/size/app_border_radius_extensions.dart';

class WordDetailShimmer extends StatelessWidget {
  const WordDetailShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: context.paddingAllMedium,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildDragHandle(context),
          _buildWordHeaderShimmer(context),
          SizedBox(height: context.cLowValue),
          _buildActionButtonsShimmer(context),
          SizedBox(height: context.cMediumValue),
          _buildOriginShimmer(context),
          SizedBox(height: context.cMediumValue),
          ...List.generate(2, (i) => _MeaningSectionShimmer()),
          SizedBox(height: context.cXLargeValue),
        ],
      ),
    );
  }
  
  Widget _buildDragHandle(BuildContext context) {
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
  
  Widget _buildWordHeaderShimmer(BuildContext context) {
    return Center(
      child: ShimmerContainer(
        height: context.cXLargeValue,
        width: context.cXxLargeValue,
        borderRadius: context.cLowValue,
      ),
    );
  }
  
  Widget _buildActionButtonsShimmer(BuildContext context) {
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
  
  Widget _buildOriginShimmer(BuildContext context) {
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

class _MeaningSectionShimmer extends StatelessWidget {
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
        ...List.generate(2, (i) => _DefinitionSectionShimmer()),
        SizedBox(height: context.cMediumValue),
      ],
    );
  }
}

class _DefinitionSectionShimmer extends StatelessWidget {
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