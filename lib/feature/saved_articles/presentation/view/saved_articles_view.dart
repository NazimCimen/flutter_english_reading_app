import 'package:cached_network_image/cached_network_image.dart';
import 'package:english_reading_app/config/routes/app_routes.dart';
import 'package:english_reading_app/config/routes/navigator_service.dart';
import 'package:english_reading_app/core/size/constant_size.dart';
import 'package:english_reading_app/core/size/dynamic_size.dart';
import 'package:english_reading_app/core/size/padding_extension.dart';
import 'package:english_reading_app/core/size/app_border_radius_extensions.dart';
import 'package:english_reading_app/core/utils/time_utils.dart';
import 'package:english_reading_app/feature/saved_articles/presentation/viewmodel/saved_articles_view_model.dart';
import 'package:english_reading_app/product/constants/app_colors.dart';
import 'package:english_reading_app/product/constants/app_contants.dart';
import 'package:english_reading_app/product/model/article_model.dart';
import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:provider/provider.dart';

part '../widget/saved_articles_header.dart';
part '../widget/saved_article_card.dart';
part '../widget/empty_saved_articles.dart';

class SavedArticlesView extends StatefulWidget {
  const SavedArticlesView({super.key});

  @override
  State<SavedArticlesView> createState() => _SavedArticlesViewState();
}

class _SavedArticlesViewState extends State<SavedArticlesView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<SavedArticlesViewModel>(
        builder: (context, viewModel, child) {
          return RefreshIndicator(
            onRefresh: () async => viewModel.pagingController.refresh(),
            color: AppColors.primaryColor,
            child: CustomScrollView(
              slivers: [
                SliverAppBar(
                  pinned: true,
                  title: const _SavedArticlesHeader(),
                ),
                SliverToBoxAdapter(child: SizedBox(height: context.cLowValue)),
                PagedSliverList<int, ArticleModel>(
                  pagingController: viewModel.pagingController,
                  builderDelegate: PagedChildBuilderDelegate(
                    firstPageProgressIndicatorBuilder: (context) => const _LoadingIndicator(),
                    animateTransitions: true,
                    noItemsFoundIndicatorBuilder: (context) => const _EmptySavedArticles(),
                    itemBuilder: (context, article, index) {
                      return GestureDetector(
                        onTap: () => NavigatorService.pushNamed(
                          AppRoutes.articleDetailView,
                          arguments: article,
                        ),
                        child: Padding(
                          padding: EdgeInsets.only(bottom: context.cMediumValue),
                          child: _SavedArticleCard(
                            article: article,
                            onRemove: () => viewModel.removeArticle(article.articleId!),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                SliverToBoxAdapter(
                  child: SizedBox(height: context.dXxLargeValue * 4),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _LoadingIndicator extends StatelessWidget {
  const _LoadingIndicator();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: context.paddingAllLarge,
        child: CircularProgressIndicator(
          color: AppColors.primaryColor,
        ),
      ),
    );
  }
} 