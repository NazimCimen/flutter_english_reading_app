import 'package:english_reading_app/core/size/app_border_radius_extensions.dart';
import 'package:english_reading_app/core/size/constant_size.dart';
import 'package:english_reading_app/product/constants/app_colors.dart';
import 'package:flutter/material.dart';

class CustomBoxDecoration {
  CustomBoxDecoration._();
  static BoxDecoration customBoxDecorationForImage(BuildContext context) {
    return BoxDecoration(
      borderRadius: context.borderRadiusAllLow,
      color: Theme.of(context).colorScheme.onPrimaryContainer,
      border: Border.all(
        color: Theme.of(context).colorScheme.tertiary,
        width: 2,
      ),
    );
  }

  static BoxDecoration customBoxDecoration(BuildContext context) {
    return BoxDecoration(
      color: Theme.of(context).colorScheme.surface,
      borderRadius: context.borderRadiusAllLow,
    );
  }

  static BoxDecoration customBoxDecorationTopRadius(BuildContext context) {
    return BoxDecoration(
      //  color: AppColors.background,
      border: const Border(top: BorderSide(color: AppColors.grey)),
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(context.cMediumValue),
        topRight: Radius.circular(context.cMediumValue),
      ),
    );
  }
}
