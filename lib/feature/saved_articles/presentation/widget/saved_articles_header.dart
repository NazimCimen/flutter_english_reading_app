part of '../view/saved_articles_view.dart';

class _SavedArticlesHeader extends StatelessWidget {
  const _SavedArticlesHeader();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          Icons.bookmark,
          color: Theme.of(context).colorScheme.primary,
          size: context.cLargeValue,
        ),
        SizedBox(width: context.cLowValue),
        Text(
          'Saved Articles',
          style: Theme.of(
            context,
          ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w600),
        ),
        Spacer(),
        IconButton(
          icon: const Icon(Icons.search, color: AppColors.black),
          onPressed: () {
            showSearch(
              context: context,
              delegate: SavedArticlesSearchDelegate(
                context.read<SavedArticlesViewModel>(),
              ),
            );
          },
        ),
      ],
    );
  }
}
