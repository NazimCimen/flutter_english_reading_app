part of '../view/add_word_view.dart';

class _AddWordAppBar extends StatelessWidget implements PreferredSizeWidget {
  const _AddWordAppBar({
    required this.isLoading,
    required this.existingWord,
    required this.onSavePressed,
  });

  final bool isLoading;
  final DictionaryEntry? existingWord;
  final VoidCallback onSavePressed;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      systemOverlayStyle: SystemUiOverlayStyle.light,
      backgroundColor: AppColors.primaryColor,
      foregroundColor: AppColors.white,
      elevation: 0,
      title: Text(
        existingWord == null ? 'Kelime Ekle' : 'Kelime Düzenle',
        style: Theme.of(context).textTheme.titleLarge?.copyWith(
          color: AppColors.white,
          fontWeight: FontWeight.w600,
        ),
      ),
      actions: [
        if (isLoading)
          Padding(
            padding: context.paddingAllMedium,
            child: SizedBox(
              width: context.cMediumValue,
              height: context.cMediumValue,
              child: CircularProgressIndicator(
                strokeWidth: context.cLowValue / 4,
                valueColor: const AlwaysStoppedAnimation<Color>(
                  AppColors.white,
                ),
              ),
            ),
          )
        else
          IconButton(icon: const Icon(Icons.check), onPressed: onSavePressed),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
