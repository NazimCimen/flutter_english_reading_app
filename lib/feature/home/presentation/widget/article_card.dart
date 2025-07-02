import 'package:cached_network_image/cached_network_image.dart';
import 'package:english_reading_app/feature/home/presentation/widget/skeleton_home_body.dart';
import 'package:flutter/material.dart';
import 'package:english_reading_app/core/size/app_border_radius_extensions.dart';
import 'package:english_reading_app/core/size/constant_size.dart';
import 'package:english_reading_app/product/constants/app_colors.dart';

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
                        color: AppColors.white,
                        size: context.cMediumValue,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: context.cLowValue),
            Text(
              title ?? '',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
            SizedBox(height: context.cLowValue / 2),
            Text(
              category ?? '',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: AppColors.primaryColor,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: context.cMediumValue),
          ],
        ),
      ),
    );
  }
}
