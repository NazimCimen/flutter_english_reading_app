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
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
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
      body: RefreshIndicator(
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
                      child: Text(
                        'No articles found',
                        style:
                            Theme.of(context).textTheme.titleLarge?.copyWith(),
                      ),
                    ),

                itemBuilder: (context, article, index) {
                  return GestureDetector(
                    onTap:
                        () => NavigatorService.pushNamed(
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
                      ),
                    ),
                  );
                },
              ),
            ),
            SliverToBoxAdapter(
              child: SizedBox(height: context.cXxLargeValue * 4),
            ),
          ],
        ),
      ),
    );
  }
}
