part of '../view/saved_articles_view.dart';

class _SavedArticleCard extends StatelessWidget {
  final ArticleModel article;
  final VoidCallback onRemove;

  const _SavedArticleCard({
    required this.article,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(
        horizontal: context.cLowValue,
        vertical: context.cLowValue / 2,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: context.borderRadiusAllMedium,
      ),
      child: SizedBox(
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.vertical(
                    top: context.borderRadiusAllMedium.topLeft,
                  ),
                  child: AspectRatio(
                    aspectRatio: 16 / 9,
                    child: CachedNetworkImage(
                      imageUrl: article.imageUrl ??
                          'https://c4.wallpaperflare.com/wallpaper/578/919/794/3-316-16-9-aspect-ratio-s-sfw-wallpaper-preview.jpg',
                      fit: BoxFit.cover,
                      placeholder: (context, url) => const Center(
                        child: CircularProgressIndicator(),
                      ),
                      errorWidget: (context, url, error) => const Icon(Icons.broken_image),
                    ),
                  ),
                ),
                Positioned(
                  top: context.cLowValue,
                  right: context.cLowValue,
                  child: GestureDetector(
                    onTap: onRemove,
                    child: Container(
                      padding: EdgeInsets.all(context.cLowValue),
                      decoration: BoxDecoration(
                        color: AppColors.black.withAlpha(128),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Icon(
                        Icons.bookmark,
                        color: AppColors.white,
                        size: context.cMediumValue,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: context.cLowValue),
            Padding(
              padding: context.paddingHorizAllMedium,
              child: Column(
                children: [
                  Text(
                    article.title ?? '',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: context.cLowValue / 2),
                  Text(
                    AppContants.getDisplayNameWithEmoji(article.category),
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppColors.primaryColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: context.cLowValue / 2),
                  Text(
                    TimeUtils.timeAgoSinceDate(article.createdAt),
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.outline,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: context.cMediumValue),
          ],
        ),
      ),
    );
  }
} 