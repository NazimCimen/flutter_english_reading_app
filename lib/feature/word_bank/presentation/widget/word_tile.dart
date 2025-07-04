import 'package:english_reading_app/config/routes/app_routes.dart';
import 'package:english_reading_app/config/routes/navigator_service.dart';
import 'package:english_reading_app/core/utils/time_utils.dart';
import 'package:english_reading_app/product/componets/custom_dialogs.dart';
import 'package:english_reading_app/product/componets/custom_sheets.dart';
import 'package:english_reading_app/product/decorations/box_decorations/custom_box_decoration.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:english_reading_app/core/size/constant_size.dart';
import 'package:english_reading_app/core/size/padding_extension.dart';
import 'package:english_reading_app/core/size/app_border_radius_extensions.dart';
import 'package:english_reading_app/product/model/dictionary_entry.dart';
import 'package:english_reading_app/feature/word_bank/presentation/viewmodel/word_bank_viewmodel.dart';
import 'package:english_reading_app/feature/word_detail/presentation/viewmodel/word_detail_view_model.dart';
import 'package:english_reading_app/product/constants/app_colors.dart';
part 'word_tile_popup.dart';

class WordTile extends StatelessWidget {
  final DictionaryEntry word;

  const WordTile({required this.word, super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.read<WordBankViewModel>();
    final meanings =
        word.meanings ??
        [
          Meaning(partOfSpeech: '', definitions: [Definition(definition: '')]),
        ];
    return Container(
      margin: context.paddingVertBottomLow,
      decoration: CustomBoxDecoration.customWordCardDecoration(context),
      child: InkWell(
        borderRadius: context.borderRadiusAllMedium,
        onTap: () {
          CustomSheets.showWordDetail(
            context: context,
            word: word.word ?? '',
            source: WordDetailSource.local,
          );
        },
        child: Padding(
          padding: context.paddingAllMedium,
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      word.word ?? '',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                    SizedBox(height: context.cLowValue / 2),
                    if (meanings.first.definitions.isNotEmpty) ...[
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              word.meanings!.first.definitions.first.definition,
                              style: Theme.of(
                                context,
                              ).textTheme.bodySmall?.copyWith(
                                color: Theme.of(
                                  context,
                                ).colorScheme.onSurface.withOpacity(0.7),
                                height: 1.3,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Text(
                            'see more',
                            style: Theme.of(context).textTheme.bodySmall
                                ?.copyWith(color: AppColors.red, height: 1.3),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ],
                    if (word.createdAt != null) ...[
                      SizedBox(height: context.cLowValue / 2),
                      Text(
                        TimeUtils.timeAgoSinceDate(word.createdAt),
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(
                            context,
                          ).colorScheme.onSurface.withOpacity(0.5),
                          fontSize: context.cLowValue + 3,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              _WordCardPopup(word: word, provider: provider),
            ],
          ),
        ),
      ),
    );
  }
}
