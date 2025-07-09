import 'package:english_reading_app/feature/add_word/presentation/mixin/add_word_mixin.dart';
import 'package:english_reading_app/feature/add_word/presentation/viewmodel/add_word_viewmodel.dart';
import 'package:english_reading_app/feature/add_word/presentation/widgets/add_word_meanings_section.dart';
import 'package:english_reading_app/feature/word_bank/presentation/viewmodel/word_bank_viewmodel.dart';
import 'package:english_reading_app/product/model/dictionary_entry.dart';
import 'package:english_reading_app/product/componets/custom_snack_bars.dart';
import 'package:flutter/material.dart';
import 'package:english_reading_app/core/size/constant_size.dart';
import 'package:english_reading_app/core/size/padding_extension.dart';
import 'package:english_reading_app/core/size/app_border_radius_extensions.dart';
import 'package:english_reading_app/product/constants/app_colors.dart';
import 'package:english_reading_app/product/decorations/input_decorations/custom_input_decoration.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:english_reading_app/core/utils/app_validators.dart';
part '../widgets/add_bar.dart';
part '../widgets/word_input_field.dart';
part '../widgets/save_button.dart';
part '../widgets/info_card.dart';

class AddWordView extends StatefulWidget {
  final DictionaryEntry? existingWord;
  const AddWordView({super.key, this.existingWord});

  @override
  State<AddWordView> createState() => _AddWordViewState();
}

class _AddWordViewState extends State<AddWordView> with AddWordMixin {
  @override
  Widget build(BuildContext context) {
    final provider = context.read<WordBankViewModel>();

    return Consumer<AddWordViewModel>(
      builder: (context, viewModel, child) {
        return PopScope(
          onPopInvokedWithResult: (didPop, result) {
            if (didPop) {
              viewModel.cleanMeanings();
            }
          },

          child: Scaffold(
            appBar: _AddWordAppBar(
              isLoading: isLoading,
              existingWord: widget.existingWord,
              onSavePressed:
                  () =>
                      (), //onSavePressed(context, provider, widget.existingWord),
            ),
            body: Padding(
              padding: EdgeInsets.symmetric(horizontal: context.cMediumValue),
              child: Form(
                key: formKeyInstance,
                child: ListView(
                  children: [
                    SizedBox(height: context.cMediumValue),
                    _WordInputField(wordController: wordControllerInstance),
                    SizedBox(height: context.cMediumValue),
                    const AddWordMeaningsSection(),
                    SizedBox(height: context.cXLargeValue),
                    _SaveButton(
                      isLoading: viewModel.isLoading,
                      existingWord: widget.existingWord,
                      onSavePressed: () async {
                        final result = await viewModel.saveWord();
                        result.fold(
                          (failure) {
                            // Hata durumunda bildirim göster
                            CustomSnackBars.showCustomTopScaffoldSnackBar(
                              context: context,
                              text: failure.errorMessage,
                              icon: Icons.error_outline,
                            );
                          },
                          (savedWord) {
                            // Başarı durumunda bildirim göster
                            CustomSnackBars.showCustomTopScaffoldSnackBar(
                              context: context,
                              text: 'Kelime başarıyla kaydedildi!',
                              icon: Icons.check_circle,
                            );
                          },
                        );
                      },
                    ),

                    SizedBox(height: context.cMediumValue),

                    const _InfoCard(),
                    SizedBox(height: context.cMediumValue),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
