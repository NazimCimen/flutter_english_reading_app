import 'package:flutter/material.dart';
import 'package:english_reading_app/core/size/app_border_radius_extensions.dart';
import 'package:english_reading_app/core/size/constant_size.dart';
import 'package:english_reading_app/core/size/dynamic_size.dart';
import 'package:english_reading_app/product/decorations/input_decorations/custom_input_decoration.dart';

class CustomAutocompleteField extends StatelessWidget {
  final TextEditingController controller;
  final List<String> options;
  final String labelText;
  final String hintText;
  final IconData prefixIcon;
  final FormFieldValidator<String>? validator;
  final ValueChanged<String>? onChanged;

  const CustomAutocompleteField({
    required this.controller,
    required this.options,
    required this.labelText,
    required this.hintText,
    required this.prefixIcon,
    this.validator,
    this.onChanged,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Autocomplete<String>(
      initialValue: TextEditingValue(text: controller.text),
      optionsBuilder: (TextEditingValue textEditingValue) {
        if (textEditingValue.text.isEmpty) {
          return options;
        }
        return options.where((String option) {
          return option.toLowerCase().contains(
            textEditingValue.text.toLowerCase(),
          );
        });
      },
      fieldViewBuilder: (
        context,
        fieldController,
        focusNode,
        onFieldSubmitted,
      ) {
        // Controller'ları senkronize et
        if (fieldController.text != controller.text) {
          fieldController.text = controller.text;
        }

        return TextFormField(
          controller: fieldController,
          focusNode: focusNode,
          onFieldSubmitted: (value) => onFieldSubmitted(),
          onChanged: (value) {
            controller.text = value;
            if (onChanged != null) {
              onChanged!(value);
            }
          },
          decoration: CustomInputDecoration.inputDecoration(
            context: context,
            hintText: hintText,
          ).copyWith(
            labelText: labelText,
            prefixIcon: Icon(prefixIcon),
            suffixIcon: Icon(Icons.arrow_drop_down),
          ),
          validator: validator,
        );
      },
      optionsViewBuilder: (context, onSelected, options) {
        return Align(
          alignment: Alignment.topLeft,
          child: Material(
            elevation: 4.0,
            borderRadius: context.borderRadiusAllLow,
            child: Container(
              constraints: BoxConstraints(
                maxHeight: context.dynamicHeight(0.3),
                maxWidth: context.dynamicWidht(0.7),
              ),
              child: ListView.builder(
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                itemCount: options.length,
                itemBuilder: (context, index) {
                  final option = options.elementAt(index);
                  return ListTile(
                    dense: true,
                    title: Text(option),
                    onTap: () {
                      onSelected(option);
                      // Seçim yapıldığında focus'u kaldır (autocomplete kapanır)
                      FocusScope.of(context).unfocus();
                    },
                    leading: Icon(
                      prefixIcon,
                      size: context.cLowValue,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  );
                },
              ),
            ),
          ),
        );
      },
      onSelected: (String selection) {
        // Seçim yapıldığında controller'ı güncelle
        controller.text = selection;
        if (onChanged != null) {
          onChanged!(selection);
        }
      },
    );
  }
}
