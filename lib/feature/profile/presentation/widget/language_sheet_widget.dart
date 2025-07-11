import 'package:easy_localization/easy_localization.dart';
import 'package:english_reading_app/core/size/constant_size.dart';
import 'package:english_reading_app/product/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:english_reading_app/config/localization/locale_constants.dart';
import 'package:english_reading_app/config/localization/string_constants.dart';
import 'package:english_reading_app/core/size/padding_extension.dart';

class LanguageSheetWidget extends StatefulWidget {
  const LanguageSheetWidget({super.key});

  @override
  State<LanguageSheetWidget> createState() => _LanguageSheetWidgetState();
}

class _LanguageSheetWidgetState extends State<LanguageSheetWidget> {
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
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.language_outlined,
                    color: Theme.of(context).colorScheme.outlineVariant,
                  ),
                  SizedBox(width: context.cLowValue),
                  Text(
                    StringConstants.language,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: Theme.of(context).colorScheme.outlineVariant,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              ...List.generate(LocaleConstants.languageList.length, (index) {
                final language = LocaleConstants.languageList[index];
                return ListTile(
                  title: Text(
                    language.name,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  trailing: Padding(
                    padding: context.paddingAllLow,
                    child: Image.asset(language.flagName),
                  ),
                  onTap: () {
                    context.setLocale(language.locale);
                    Navigator.pop(context);
                  },
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}
