import 'package:english_reading_app/core/size/dynamic_size.dart';
import 'package:english_reading_app/core/size/padding_extension.dart';
import 'package:flutter/material.dart';
import 'package:english_reading_app/product/widgets/custom_text_widgets.dart';

class CustomErrorWidget extends StatelessWidget {
  final String title;
  final IconData iconData;
  const CustomErrorWidget({
    required this.title,
    required this.iconData,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: context.paddingHorizAllXlarge,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              iconData,
              size: context.dynamicWidht(0.28),
              color: Theme.of(context).colorScheme.tertiary,
            ),
            SizedBox(height: context.dynamicHeight(0.02)),
            CustomTextGreySubTitleWidget(
              maxLine: 3,
              subTitle: title,
            ),
            SizedBox(height: context.dynamicHeight(0.02)),
          ],
        ),
      ),
    );
  }
}
