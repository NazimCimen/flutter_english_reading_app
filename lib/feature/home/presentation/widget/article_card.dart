import 'package:cached_network_image/cached_network_image.dart';
import 'package:english_reading_app/feature/home/presentation/widget/skeleton_home_body.dart';
import 'package:flutter/material.dart';
import 'package:english_reading_app/core/size/app_border_radius_extensions.dart';
import 'package:english_reading_app/core/size/constant_size.dart';
import 'package:english_reading_app/product/constants/app_colors.dart';

/// Article card widget displaying article information with save functionality.
/// Shows article image, title, category, timestamp and bookmark button.
class ArticleCard extends StatelessWidget {
  final String? imageUrl;
  final String? title;
  final String? category;
  final String? timeAgo;
  final VoidCallback? onSave;
  final bool isSaved;

  const ArticleCard({
    required this.imageUrl,
    required this.title,
    required this.category,
    required this.timeAgo,
    this.onSave,
    this.isSaved = false,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(
        horizontal: context.cMediumValue,
        vertical: context.cLowValue / 2,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: context.borderRadiusAllMedium,
      ),
      child: SizedBox(
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
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
                      imageUrl:
                          imageUrl ??
                          'https://c4.wallpaperflare.com/wallpaper/578/919/794/3-316-16-9-aspect-ratio-s-sfw-wallpaper-preview.jpg',
                      fit: BoxFit.cover,
                      placeholder:
                          (context, url) =>
                              const Center(child: const ImageShimmer()),
                      errorWidget:
                          (context, url, error) =>
                              const Icon(Icons.broken_image),
                    ),
                  ),
                ),

                Positioned(
                  top: context.cLowValue,
                  left: context.cLowValue,
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: context.cLowValue,
                      vertical: context.cLowValue / 2,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.primaryColor.withAlpha(128),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Text(
                      category ?? '',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).colorScheme.surface,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: context.cLowValue,
                  right: context.cLowValue,
                  child: GestureDetector(
                    onTap: onSave,
                    child: Container(
                      padding: EdgeInsets.all(context.cLowValue),
                      decoration: BoxDecoration(
                        color: AppColors.black.withAlpha(128),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Icon(
                        isSaved ? Icons.bookmark : Icons.bookmark_border,
                        color:
                            isSaved ? AppColors.primaryColor : AppColors.white,
                        size: context.cMediumValue,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: context.cLowValue),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: context.cLowValue*1.5),
              child: Text(
                title ?? '',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
            ),
            SizedBox(height: context.cLowValue / 2),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: context.cLowValue*1.5),
              child: Row(
                children: [
                  Icon(
                    Icons.access_time_outlined,
                    size: context.cMediumValue * 0.9,
                  ),
                  Text(
                    " ${timeAgo ?? ''}",
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
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
