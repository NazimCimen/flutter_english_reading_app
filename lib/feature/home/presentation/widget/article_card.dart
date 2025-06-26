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
  const ArticleCard({
    required this.imageUrl,
    required this.title,
    required this.category,
    required this.timeAgo,
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
        borderRadius: context.cBorderRadiusAllMedium,
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
                    top: context.cBorderRadiusAllMedium.topLeft,
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
                  top: 12, // Üstten boşluk
                  right: 12, // Sağdan boşluk
                  child: GestureDetector(
                    onTap: () {
                      // Kaydetme işlemi burada yapılabilir
                      print("Resim kaydedildi!");
                    },
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppColors.black.withAlpha(
                          128,
                        ), // Yarı saydam arkaplan
                        borderRadius: BorderRadius.circular(
                          30,
                        ), // Yuvarlak kenar
                      ),
                      child: const Icon(
                        Icons.bookmark_border, // Kaydetme ikonu (outline)
                        color: Colors.white, // Beyaz ikon
                        size: 24,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: context.cLowValue),
            Text(
              title ?? '',
              style: Theme.of(
                context,
              ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
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
