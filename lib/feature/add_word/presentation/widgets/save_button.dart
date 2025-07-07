part of '../view/add_word_view.dart';

class _SaveButton extends StatelessWidget {
  const _SaveButton({
    required this.isLoading,
    required this.existingWord,
    required this.onSavePressed,
  });

  final bool isLoading;
  final DictionaryEntry? existingWord;
  final VoidCallback onSavePressed;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: isLoading ? null : onSavePressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primaryColor,
        foregroundColor: AppColors.white,
        minimumSize: Size.fromHeight(context.cXxLargeValue),
        shape: RoundedRectangleBorder(
          borderRadius: context.borderRadiusAllMedium,
        ),
        elevation: context.cLowValue / 4,
      ),
      child:
          isLoading
              ? Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: context.cMediumValue,
                    height: context.cMediumValue,
                    child: CircularProgressIndicator(
                      strokeWidth: context.cLowValue / 4,
                      valueColor: const AlwaysStoppedAnimation<Color>(
                        AppColors.white,
                      ),
                    ),
                  ),
                  SizedBox(width: context.cLowValue),
                  Text(
                    'Kaydediliyor...',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: AppColors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              )
              : Text(
                existingWord == null ? 'Kelime Ekle' : 'Güncelle',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: AppColors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
    );
  }
}
