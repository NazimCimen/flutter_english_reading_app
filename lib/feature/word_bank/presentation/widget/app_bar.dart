part of '../view/word_bank_view.dart';

class _WordBankAppBar extends StatelessWidget implements PreferredSizeWidget {
  final TextEditingController searchController;
  final VoidCallback onSearchChanged;

  const _WordBankAppBar({
    required this.searchController,
    required this.onSearchChanged,
  });

  @override
  Widget build(BuildContext context) {
    final readViewModel = context.watch<WordBankViewModel>();
    final watchViewModel = context.read<WordBankViewModel>();

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
              readViewModel.setIsSearch(true);
              showSearch(context: context, delegate: WordBankSearchDelegate());
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
