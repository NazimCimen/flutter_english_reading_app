import 'package:english_reading_app/core/size/app_border_radius_extensions.dart';
import 'package:english_reading_app/core/size/padding_extension.dart';
import 'package:english_reading_app/product/constants/app_colors.dart';
import 'package:flutter/material.dart';

class SquareGoBackButton extends StatelessWidget {
  const SquareGoBackButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pop(context);
      },
      child: Padding(
        padding: context.cPaddingSmall,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: context.cBorderRadiusAllLow,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: const Center(
            child: Icon(
              Icons.arrow_back,
              color: AppColors.primaryColor,
            ),
          ),
        ),
      ),
    );
  }
}
