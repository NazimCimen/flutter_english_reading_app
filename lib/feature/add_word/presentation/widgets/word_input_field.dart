part of '../view/add_word_view.dart';

class _WordInputField extends StatelessWidget {
  const _WordInputField({
    required this.wordController,
    this.onChanged,
  });

  final TextEditingController wordController;
  final ValueChanged<String>? onChanged;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: wordController,
      onChanged: onChanged,
      decoration: CustomInputDecoration.inputDecoration(
        context: context,
        hintText: 'Örnek: apple, beautiful, happiness',
      ).copyWith(
        labelText: 'Kelime',
        prefixIcon: const Icon(Icons.text_fields),
      ),
      validator: AppValidators.wordValidator,
    );
  }
}
