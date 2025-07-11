part of '../view/article_detail_view.dart';

class _NewsDetailAppBar extends StatelessWidget implements PreferredSizeWidget {
  const _NewsDetailAppBar();

  @override
  Widget build(BuildContext context) {
    return AppBar(
      systemOverlayStyle: const SystemUiOverlayStyle(
        statusBarIconBrightness: Brightness.light,
      ),
      backgroundColor: AppColors.primaryColor,
      centerTitle: true,
      scrolledUnderElevation: 0,
      iconTheme: const IconThemeData(color: AppColors.white),
      title: Image.asset(
        height: context.dynamicHeight(0.04),
        ImageEnums.logo.toPathPng,
        fit: BoxFit.cover,
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.text_fields),
          onPressed: () {
            final viewModel = context.read<ArticleDetailViewModel>();
            CustomSheets.showFontSizeSheet(context, viewModel);
          },
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
