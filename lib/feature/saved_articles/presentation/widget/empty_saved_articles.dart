part of '../view/saved_articles_view.dart';

class _EmptySavedArticles extends StatelessWidget {
  const _EmptySavedArticles();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: context.paddingAllLarge,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.bookmark_border,
              size: context.dXxLargeValue * 2,
              color: Theme.of(context).colorScheme.outline,
            ),
            SizedBox(height: context.cMediumValue),
            Text(
              'No Saved Articles',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
            SizedBox(height: context.cLowValue),
            Text(
              'Articles you save will appear here',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.outline,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
} 