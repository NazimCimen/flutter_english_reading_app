import 'package:english_reading_app/config/localization/string_constants.dart';
import 'package:english_reading_app/core/utils/time_utils.dart';
import 'package:english_reading_app/feature/home/presentation/widget/skeleton_home_body.dart';
import 'package:english_reading_app/product/constants/app_colors.dart';
import 'package:english_reading_app/product/constants/app_contants.dart';
import 'package:english_reading_app/product/model/article_model.dart';
import 'package:flutter/material.dart';
import 'package:english_reading_app/config/routes/app_routes.dart';
import 'package:english_reading_app/config/routes/navigator_service.dart';
import 'package:english_reading_app/core/size/constant_size.dart';
import 'package:english_reading_app/feature/home/presentation/mixin/home_mixin.dart';
import 'package:english_reading_app/feature/home/presentation/widget/categories.dart';
import 'package:english_reading_app/feature/home/presentation/widget/article_card.dart';
import 'package:english_reading_app/feature/home/presentation/viewmodel/home_view_model.dart';
import 'package:english_reading_app/feature/main_layout/viewmodel/main_layout_view_model.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:provider/provider.dart';
part '../widget/home_header.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  HomeViewState createState() => HomeViewState();
}

class HomeViewState extends State<HomeView> with HomeMixin {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<MainLayoutViewModel>(
        builder: (context, mainLayoutViewModel, child) {
          return RefreshIndicator(
            onRefresh: () async => pagingController.refresh(),
            color: AppColors.primaryColor,
            child: CustomScrollView(
              slivers: [
                SliverAppBar(
                  pinned: true,
                  title: _HomeHeader(),
                ),
                SliverToBoxAdapter(child: SizedBox(height: context.cLowValue)),

                SliverToBoxAdapter(
                  child: Categories(onCategoryChanged: updateSelectedCategory),
                ),
                SliverToBoxAdapter(child: SizedBox(height: context.cLowValue)),
                PagedSliverList<int, ArticleModel>(
                  pagingController: pagingController,

                  builderDelegate: PagedChildBuilderDelegate(
                    firstPageProgressIndicatorBuilder:
                        (context) => const SkeletonHomeBody(),
                    animateTransitions: true,
                    noItemsFoundIndicatorBuilder:
                        (context) => Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                StringConstants.noArticlesFound,
                                style: Theme.of(context).textTheme.titleLarge?.copyWith(),
                              ),
                              SizedBox(height: context.cLowValue),
                              Text(
                                StringConstants.loadMoreContent,
                                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),

                    itemBuilder: (context, article, index) {
                      return Consumer<HomeViewModel>(
                        builder: (context, homeViewModel, child) {
                          final isSaved = isArticleSaved(article.articleId!);
                          return GestureDetector(
                            onTap: () => NavigatorService.pushNamed(
                              AppRoutes.articleDetailView,
                              arguments: article,
                            ),
                            child: Padding(
                              padding: EdgeInsets.only(bottom: context.cMediumValue),
                              child: ArticleCard(
                                category: AppContants.getDisplayNameWithEmoji(
                                  article.category,
                                ),
                                imageUrl: article.imageUrl,
                                title: article.title,
                                timeAgo: TimeUtils.timeAgoSinceDate(article.createdAt),
                                isSaved: isSaved,
                                onSave: () => toggleArticleSave(article),
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
                SliverToBoxAdapter(
                  child: SizedBox(height: context.cXxLargeValue * 4),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
