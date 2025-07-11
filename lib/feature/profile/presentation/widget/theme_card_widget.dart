import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:english_reading_app/config/localization/string_constants.dart';
import 'package:english_reading_app/config/theme/theme_manager.dart';
import 'package:english_reading_app/core/size/app_border_radius_extensions.dart';
import 'package:english_reading_app/core/size/constant_size.dart';
import 'package:english_reading_app/core/size/padding_extension.dart';
import 'package:english_reading_app/product/constants/app_colors.dart';

class ThemeCardWidget extends StatefulWidget {
  const ThemeCardWidget({super.key});

  @override
  State<ThemeCardWidget> createState() => _ThemeCardWidgetState();
}

class _ThemeCardWidgetState extends State<ThemeCardWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: context.cMediumValue),
      child: Padding(
        padding: EdgeInsets.only(bottom: context.cMediumValue),
        child: Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(context.cLargeValue),
            ),
          ),
          padding: EdgeInsets.all(context.cLargeValue),
          child: Consumer<ThemeManager>(
            builder: (context, themeManager, child) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.palette_outlined,
                        color: Theme.of(context).colorScheme.outlineVariant,
                      ),
                      SizedBox(width: context.cLowValue),
                      Text(
                        StringConstants.theme,
                        style: Theme.of(
                          context,
                        ).textTheme.titleMedium?.copyWith(
                          color: Theme.of(context).colorScheme.outlineVariant,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Padding(
                          padding: context.paddingAllMedium,
                          child: GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                              themeManager.changeTheme(ThemeEnum.light);
                            },
                            child: _ThemeOptionWidget(
                              selectedThemeIcon: Icons.light_mode,
                              unSelectedThemeIcon: Icons.light_mode_outlined,
                              text: StringConstants.light_theme,
                              onChanged: (bool? value) {
                                Navigator.pop(context);
                                themeManager.changeTheme(ThemeEnum.light);
                              },
                              value:
                                  themeManager.currentThemeEnum ==
                                  ThemeEnum.light,
                              groupValue: true,
                              borderColor: AppColors.primaryColorSoft,
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: context.paddingAllMedium,
                          child: GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                              themeManager.changeTheme(ThemeEnum.dark);
                            },
                            child: _ThemeOptionWidget(
                              selectedThemeIcon: Icons.dark_mode,
                              unSelectedThemeIcon: Icons.dark_mode_outlined,
                              text: StringConstants.dark_theme,
                              onChanged: (bool? value) {
                                Navigator.pop(context);
                                themeManager.changeTheme(ThemeEnum.dark);
                              },
                              value:
                                  themeManager.currentThemeEnum ==
                                  ThemeEnum.dark,
                              groupValue: true,
                              borderColor: AppColors.primaryColorSoft,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

class _ThemeOptionWidget extends StatelessWidget {
  final IconData selectedThemeIcon;
  final IconData unSelectedThemeIcon;
  final String text;
  final bool value;
  final bool groupValue;
  final Color borderColor;
  final void Function(bool?)? onChanged;

  const _ThemeOptionWidget({
    required this.selectedThemeIcon,
    required this.unSelectedThemeIcon,
    required this.text,
    required this.value,
    required this.groupValue,
    required this.onChanged,
    required this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: value ? borderColor : Colors.transparent,
          width: 2,
        ),
        borderRadius: context.borderRadiusAllMedium,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(height: context.cMediumValue),
          if (value == false)
            Icon(unSelectedThemeIcon, size: context.cXLargeValue),
          if (value == true)
            Icon(
              selectedThemeIcon,
              size: context.cXLargeValue,
              color: borderColor,
            ),
          SizedBox(height: context.cLowValue),
          Text(
            text,
            maxLines: 1,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          Radio<bool>(
            //   activeColor: colorScheme(context).onSurface,
            value: value,
            groupValue: groupValue,
            onChanged: onChanged,
          ),
          SizedBox(height: context.cMediumValue),
        ],
      ),
    );
  }
}
