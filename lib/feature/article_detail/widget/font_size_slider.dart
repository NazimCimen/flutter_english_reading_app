import 'package:english_reading_app/core/size/constant_size.dart';
import 'package:english_reading_app/feature/article_detail/viewmodel/article_detail_view_model.dart';
import 'package:flutter/material.dart';
class FontSizeSlider extends StatelessWidget {
  final ArticleDetailViewModel viewModel;
  const FontSizeSlider(this.viewModel, {super.key});

  @override
  Widget build(BuildContext context) {
    var currentFontSize = viewModel.fontSize;

    return StatefulBuilder(
      builder: (context, setState) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).padding.bottom,
            top: context.cMediumValue,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Yazı Boyutunu Ayarla',
                style: Theme.of(
                  context,
                ).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold),
              ),
              Slider(
                min: 14,
                max: 24,
                divisions: 10,
                label: currentFontSize.toInt().toString(),
                value: currentFontSize,
                onChanged: (value) {
                  setState(() {
                    currentFontSize = value;
                  });
                  viewModel.setFontSize(value);
                },
              ),

              Text(
                'Boyut: ${currentFontSize.toInt()}',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ),
        );
      },
    );
  }
}