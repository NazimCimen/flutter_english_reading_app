import 'package:english_reading_app/product/constants/app_contants.dart';
import 'package:flutter/material.dart';
import 'package:english_reading_app/core/size/app_border_radius_extensions.dart';
import 'package:english_reading_app/core/size/constant_size.dart';
import 'package:english_reading_app/product/constants/app_colors.dart';

class Categories extends StatefulWidget {
  final void Function(String) onCategoryChanged;
  const Categories({required this.onCategoryChanged, super.key});

  @override
  State<Categories> createState() => _CategoriesState();
}

class _CategoriesState extends State<Categories> {
  int selectedCategoryIndex = 0;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: List.generate(AppContants.categories.length, (index) {
          return GestureDetector(
            onTap: () {
              setState(() {
                selectedCategoryIndex = index;
              });
              widget.onCategoryChanged(AppContants.categories[index].name);
            },
            child: Card(
              margin: EdgeInsets.only(
                left: index == 0 ? context.cLowValue : 0,
                right: context.cLowValue,
                top: context.cLowValue / 2,
                bottom: context.cLowValue / 2,
              ),
              color:
                  selectedCategoryIndex == index
                      ? AppColors.primaryColor
                      : Theme.of(context).colorScheme.surface,
              shape: ContinuousRectangleBorder(
                borderRadius: context.borderRadiusAllMedium,
              ),
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: context.cMediumValue,
                  vertical: context.cLowValue,
                ),
                child: Row(
                  children: [
                    Text(AppContants.categories[index].emoji),
                    const SizedBox(width: 8),
                    Text(
                      AppContants.categories[index].displayName,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color:
                            selectedCategoryIndex == index
                                ? AppColors.white
                                : Theme.of(context).colorScheme.onSurface,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}
