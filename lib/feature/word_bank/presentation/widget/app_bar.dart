part of '../view/word_bank_view.dart';

class _AppBar extends StatelessWidget implements PreferredSizeWidget {
  const _AppBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<WordBankViewmodel>(context, listen: false);
    return AppBar(
      systemOverlayStyle: SystemUiOverlayStyle.light,
      foregroundColor: AppColors.white,
      backgroundColor: AppColors.primaryColor,
      iconTheme: const IconThemeData(color: AppColors.white),
      automaticallyImplyLeading: false,
      elevation: 0,
      title: Text(
        'Kelime Bankası',
        style: Theme.of(context).textTheme.titleLarge?.copyWith(
          color: AppColors.white,
          fontWeight: FontWeight.w600,
        ),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.refresh),
          onPressed: () {
            provider.refreshWords();
          },
        ),
        IconButton(
          icon: const Icon(Icons.search_outlined),
          onPressed: () {},
        ),
        IconButton(
          icon: const Icon(Icons.add_outlined),
          onPressed: () => NavigatorService.pushNamed(AppRoutes.addWordView),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
} 