import 'package:english_reading_app/core/size/constant_size.dart';
import 'package:english_reading_app/core/size/dynamic_size.dart';
import 'package:english_reading_app/core/size/padding_extension.dart';
import 'package:english_reading_app/core/size/app_border_radius_extensions.dart';
import 'package:english_reading_app/core/utils/time_utils.dart';
import 'package:english_reading_app/feature/saved_articles/presentation/viewmodel/saved_articles_view_model.dart';
import 'package:english_reading_app/feature/home/presentation/widget/article_card.dart';
import 'package:english_reading_app/config/routes/app_routes.dart';
import 'package:english_reading_app/config/routes/navigator_service.dart';
import 'package:english_reading_app/product/constants/app_colors.dart';
import 'package:english_reading_app/product/constants/app_contants.dart';
import 'package:english_reading_app/product/model/article_model.dart';
import 'package:english_reading_app/product/widgets/custom_progress_indicator.dart';
import 'package:flutter/material.dart';
import 'package:english_reading_app/product/widgets/custom_error_widget.dart';

class SavedArticlesSearchDelegate extends SearchDelegate<void> {
  final SavedArticlesViewModel viewModel;
  SavedArticlesSearchDelegate(this.viewModel);

  @override
  Widget? buildLeading(BuildContext context) {
    return Container(
      margin: context.paddingAllLow,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: context.borderRadiusAllMedium,
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withOpacity(0.1),
        ),
      ),
      child: IconButton(
        onPressed: () => close(context, null),
        icon: Icon(
          Icons.arrow_back_ios_outlined,
          color: Theme.of(context).colorScheme.onSurface,
        ),
      ),
    );
  }

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      Container(
        margin: context.paddingAllLow,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: context.borderRadiusAllMedium,
          border: Border.all(
            color: Theme.of(context).colorScheme.outline.withOpacity(0.1),
          ),
        ),
        child: IconButton(
          icon: Icon(
            Icons.clear_outlined,
            color: Theme.of(context).colorScheme.onSurface,
          ),
          onPressed: () => close(context, null),
        ),
      ),
    ];
  }

  @override
  Widget buildResults(BuildContext context) {
    return FutureBuilder<List<ArticleModel>>(
      future: viewModel.searchSavedArticles(query),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CustomProgressIndicator();
        }

        if (snapshot.hasError) {
          return CustomErrorWidget(
            title: 'Ouups',
            iconData: Icons.error_outline,
          );
        }

        final articles = snapshot.data ?? [];

        if (articles.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.search_off, size: 64, color: Colors.grey[400]),
                SizedBox(height: context.cMediumValue),
                Text(
                  'No articles found for "$query"',
                  style: Theme.of(
                    context,
                  ).textTheme.titleMedium?.copyWith(color: Colors.grey[600]),
                ),
              ],
            ),
          );
        }

        return Padding(
          padding: context.cPaddingSmall,
          child: ListView.builder(
            itemCount: articles.length,
            itemBuilder: (context, index) {
              final article = articles[index];
              return GestureDetector(
                onTap:
                    () => NavigatorService.pushNamed(
                      AppRoutes.articleDetailView,
                      arguments: article,
                    ),
                child: Padding(
                  padding: EdgeInsets.only(bottom: context.cMediumValue),
                  child: ArticleCard(
                    imageUrl: article.imageUrl,
                    title: article.title,
                    category: AppContants.getDisplayNameWithEmoji(
                      article.category,
                    ),
                    timeAgo: TimeUtils.timeAgoSinceDate(article.createdAt),
                    onSave: () => viewModel.removeArticle(article.articleId!),
                    isSaved: true,
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return FutureBuilder<List<ArticleModel>>(
      future: viewModel.searchSavedArticles(query),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        final articles = snapshot.data ?? [];

        if (articles.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.search_off, size: 64, color: Colors.grey[400]),
                SizedBox(height: context.cMediumValue),
                Text(
                  'No articles found for "$query"',
                  style: Theme.of(
                    context,
                  ).textTheme.titleMedium?.copyWith(color: Colors.grey[600]),
                ),
              ],
            ),
          );
        }

        return Padding(
          padding: context.cPaddingSmall,
          child: ListView.builder(
            itemCount: articles.length,
            itemBuilder: (context, index) {
              final article = articles[index];
              return GestureDetector(
                onTap:
                    () => NavigatorService.pushNamed(
                      AppRoutes.articleDetailView,
                      arguments: article,
                    ),
                child: Padding(
                  padding: EdgeInsets.only(bottom: context.cMediumValue),
                  child: ArticleCard(
                    imageUrl: article.imageUrl,
                    title: article.title,
                    category: AppContants.getDisplayNameWithEmoji(
                      article.category,
                    ),
                    timeAgo: TimeUtils.timeAgoSinceDate(article.createdAt),
                    onSave: () => viewModel.removeArticle(article.articleId!),
                    isSaved: true,
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
