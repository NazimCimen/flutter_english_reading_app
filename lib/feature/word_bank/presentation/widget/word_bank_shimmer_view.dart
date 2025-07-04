import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:english_reading_app/core/size/constant_size.dart';
import 'package:english_reading_app/core/size/padding_extension.dart';
import 'package:english_reading_app/core/size/app_border_radius_extensions.dart';

class WordBankLoadingView extends StatelessWidget {
  const WordBankLoadingView({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: context.paddingAllLow,
      itemCount: 10,
      itemBuilder: (context, index) {
        return Container(
          margin: context.paddingVertBottomMedium,
          padding: context.paddingAllMedium,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: context.borderRadiusAllMedium,
            boxShadow: [
              BoxShadow(
                color: Theme.of(
                  context,
                ).colorScheme.onSurface.withOpacity(0.05),
                blurRadius: context.cLowValue + 2,
                offset: Offset(0, context.cLowValue / 4),
              ),
            ],
          ),
          child: Shimmer.fromColors(
            baseColor: Theme.of(context).colorScheme.onSurface.withOpacity(0.3),
            highlightColor: Theme.of(
              context,
            ).colorScheme.onSurface.withOpacity(0.1),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: context.cMediumValue + 4,
                  width: context.cXLargeValue + 20,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surface,
                    borderRadius: context.borderRadiusAllXLow,
                  ),
                ),
                SizedBox(height: context.cLowValue),
                Container(
                  height: context.cMediumValue,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surface,
                    borderRadius: context.borderRadiusAllXLow,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
