import 'package:english_reading_app/feature/add_word/presentation/widgets/meaning_card.dart';
import 'package:flutter/material.dart';
import 'package:english_reading_app/core/size/constant_size.dart';
import 'package:english_reading_app/product/constants/app_colors.dart';
import 'package:english_reading_app/feature/add_word/presentation/viewmodel/add_word_viewmodel.dart';
import 'package:provider/provider.dart';

class AddWordMeaningsSection extends StatelessWidget {
  const AddWordMeaningsSection({super.key});
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Anlamlar',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
            TextButton.icon(
              onPressed: () {
                context.read<AddWordViewModel>().addNewMeaning();
              },
              icon: Icon(Icons.add, size: context.cMediumValue),
              label: Text('Anlam Ekle'),
              style: TextButton.styleFrom(
                foregroundColor: AppColors.primaryColor,
              ),
            ),
          ],
        ),
        SizedBox(height: context.cMediumValue),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: context.watch<AddWordViewModel>().meanings.length,
          itemBuilder: (context, index) {
            return MeaningCard(
              meaning: context.watch<AddWordViewModel>().meanings[index],
            );
          },
        ),
    /*    ...List.generate(context.watch<AddWordViewModel>().meanings.length, (
          index,
        ) {
          return MeaningCard(
            meaning: context.watch<AddWordViewModel>().meanings[index],
          );
        }),*/
      ],
    );
  }
}
