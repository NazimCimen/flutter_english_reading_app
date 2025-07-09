import 'package:cached_network_image/cached_network_image.dart';
import 'package:english_reading_app/config/routes/app_routes.dart';
import 'package:english_reading_app/config/routes/navigator_service.dart';
import 'package:english_reading_app/core/size/constant_size.dart';
import 'package:english_reading_app/core/size/dynamic_size.dart';
import 'package:english_reading_app/core/size/padding_extension.dart';
import 'package:english_reading_app/core/size/app_border_radius_extensions.dart';
import 'package:english_reading_app/core/utils/time_utils.dart';
import 'package:english_reading_app/feature/saved_articles/presentation/viewmodel/saved_articles_view_model.dart';
import 'package:english_reading_app/feature/main_layout/viewmodel/main_layout_view_model.dart';
import 'package:english_reading_app/product/constants/app_colors.dart';
import 'package:english_reading_app/product/constants/app_contants.dart';
import 'package:english_reading_app/product/model/article_model.dart';
import 'package:english_reading_app/product/widgets/email_verification_widget.dart';
import 'package:english_reading_app/feature/home/presentation/widget/article_card.dart';
import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:provider/provider.dart';
part '../widget/emphty_view.dart';
part '../widget/saved_articles_header.dart';
part '../widget/saved_article_card.dart';

class SavedArticlesView extends StatefulWidget {
  const SavedArticlesView({super.key});

  @override
  State<SavedArticlesView> createState() => _SavedArticlesViewState();
}

class _SavedArticlesViewState extends State<SavedArticlesView> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<MainLayoutViewModel>(
        builder: (context, mainLayoutViewModel, child) {
          if (!mainLayoutViewModel.hasAccount) {
            return EmailVerificationWidget(
              title: 'Hesap Açmanız Gerekli',
              description:
                  'Kaydedilen makalelere erişmek için lütfen hesap açın.',
              mainLayoutViewModel: mainLayoutViewModel,
            );
          }

          if (!mainLayoutViewModel.isMailVerified) {
            return EmailVerificationWidget(
              title: 'E-posta Doğrulaması Gerekli',
              description:
                  'Kaydedilen makalelere erişmek için lütfen e-posta adresinizi doğrulayın.',
              mainLayoutViewModel: mainLayoutViewModel,
            );
          }

          return Consumer<SavedArticlesViewModel>(
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
                    SliverToBoxAdapter(
                      child: SizedBox(height: context.cLowValue),
                    ),
                    PagedSliverList<int, ArticleModel>(
                      pagingController: viewModel.pagingController,
                      builderDelegate: PagedChildBuilderDelegate(
                        firstPageProgressIndicatorBuilder:
                            (context) => const _LoadingIndicator(),
                        animateTransitions: true,
                        noItemsFoundIndicatorBuilder:
                            (context) => const _SavedArticlesEmptyView(),
                        itemBuilder: (context, article, index) {
                          return GestureDetector(
                            onTap:
                                () => NavigatorService.pushNamed(
                                  AppRoutes.articleDetailView,
                                  arguments: article,
                                ),
                            child: Padding(
                              padding: EdgeInsets.only(
                                bottom: context.cMediumValue,
                              ),
                              child: ArticleCard(
                                imageUrl: article.imageUrl,
                                title: article.title,
                                category: AppContants.getDisplayNameWithEmoji(
                                  article.category,
                                ),
                                timeAgo: TimeUtils.timeAgoSinceDate(
                                  article.createdAt,
                                ),
                                onSave:
                                    () => viewModel.removeArticle(
                                      article.articleId!,
                                    ),
                                isSaved: true,
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
        child: CircularProgressIndicator(color: AppColors.primaryColor),
      ),
    );
  }
}
