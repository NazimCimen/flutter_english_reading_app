import 'package:cached_network_image/cached_network_image.dart';
import 'package:english_reading_app/core/utils/type_parser.dart';
import 'package:english_reading_app/feature/article_detail/presentation/viewmodel/article_detail_view_model.dart';
import 'package:english_reading_app/feature/main_layout/export.dart';
import 'package:english_reading_app/product/constants/app_contants.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ArticleDetailHeader extends StatelessWidget {
  const ArticleDetailHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ArticleDetailViewModel>(
      builder: (context, viewmodel, child) {
        final article = viewmodel.article;
        if (article == null) {
          return const SizedBox.shrink();
        }
        const defaultImg =
            'https://firebasestorage.googleapis.com/v0/b/english-reading-app-prod.firebasestorage.app/o/default_image.jpg?alt=media&token=a5e24d67-f5bf-4a80-8310-6999cdd1fadd';
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Text(
                article.title ?? '',
                style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  fontFamily: GoogleFonts.merriweather().fontFamily,
                  fontSize: viewmodel.fontSize + 10,
                ),
              ),
            ),
            SizedBox(height: context.cLowValue),
            ClipRRect(
              borderRadius: BorderRadius.vertical(
                top: context.cBorderRadiusAllMedium.topLeft,
              ),
              child: AspectRatio(
                aspectRatio: 16 / 9,
                child: CachedNetworkImage(
                  imageUrl: article.imageUrl ?? defaultImg,
                  fit: BoxFit.cover,
                  placeholder:
                      (context, url) =>
                          const Center(child: CircularProgressIndicator()),
                  errorWidget:
                      (context, url, error) => const Icon(Icons.broken_image),
                ),
              ),
            ),
            const Divider(color: AppColors.grey, thickness: 1),
            Row(
              children: [
                Text(
                  TypeParser.formatDateTime(
                    article.createdAt ?? DateTime.now(),
                  ).toLocal().toString().split(' ')[0],
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const Spacer(),
                Text(
                  AppContants.getDisplayNameWithEmoji(article.category),
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}
