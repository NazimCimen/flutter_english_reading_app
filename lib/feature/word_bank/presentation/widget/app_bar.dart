part of '../view/word_bank_view.dart';

class _WordBankAppBar extends StatelessWidget implements PreferredSizeWidget {
  const _WordBankAppBar();

  @override
  Widget build(BuildContext context) {
    final readViewModel = context.watch<WordBankViewModel>();

    if (context.watch<MainLayoutViewModel>().isMailVerified == true) {
      return AppBar(
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        elevation: 0,
        title: Text(
          'Kelime Bankası',
          style: Theme.of(
            context,
          ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w600),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: AppColors.black),
            onPressed: () {
              showSearch(
                context: context,
                delegate: WordBankSearchDelegate(readViewModel),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.add, color: AppColors.black),
            onPressed: () => NavigatorService.pushNamed(AppRoutes.addWordView),
          ),
        ],
      );
    } else {
      return const SizedBox.shrink();
    }
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
