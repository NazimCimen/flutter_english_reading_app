import 'package:animate_do/animate_do.dart';
import 'package:english_reading_app/core/cache/cache_enum.dart';
import 'package:english_reading_app/core/cache/cache_manager/standart_cache_manager.dart';
import 'package:english_reading_app/feature/main_layout/export.dart';
import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';

class OnboardView extends StatelessWidget {
  const OnboardView({super.key});

  Future<void> _markOnboardAsShown() async {
    final cacheService = StandartCacheManager<bool>(
      boxName: CacheHiveBoxEnum.appSettings.name,
    );
    await cacheService.saveData(
      data: true,
      keyName: CacheKeyEnum.onboardVisibility.name,
    );
    await NavigatorService.pushNamedAndRemoveUntil(AppRoutes.loginView);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'L I N G Z Y',
          style: Theme.of(context).textTheme.titleLarge,
        ),
      ),
      body: SafeArea(
        child: IntroductionScreen(
          pages: [
            PageViewModel(
              titleWidget: FadeInUp(
                child: const _TitleText(
                  text: 'Start Your English Journey with Lingzy 👋',
                ),
              ),
              bodyWidget: FadeInDown(
                child: const _BodyWidget(
                  text:
                      'Explore short texts on topics you love — sports, tech, science and more!',
                ),
              ),
              image: FadeInUp(
                child: Image.asset(
                  ImageEnums.onboard1.toPathPng,
                  height: context.cXxLargeValue * 3,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            PageViewModel(
              titleWidget: FadeInUp(
                child: const _TitleText(text: 'Tap to Learn Instantly 🔍'),
              ),
              bodyWidget: FadeInDown(
                child: const _BodyWidget(
                  text:
                      "Just tap on any word you don't know — get instant meaning and pronunciation.",
                ),
              ),
              image: FadeInUp(
                child: Image.asset(
                  ImageEnums.onboard2.toPathPng,
                  height: context.cXxLargeValue * 3,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            PageViewModel(
              titleWidget: FadeInUp(
                child: const _TitleText(
                  text: 'Build Your Personal Dictionary 📚',
                ),
              ),
              bodyWidget: FadeInDown(
                child: const _BodyWidget(
                  text:
                      'Save new words or add your own manually. Access them anytime on any device!',
                ),
              ),
              image: FadeInUp(
                child: Image.asset(
                  ImageEnums.onboard3.toPathPng,
                  height: context.cXxLargeValue * 3,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ],
          onDone: _markOnboardAsShown,
          showSkipButton: true,
          skip: TextButton(
            onPressed: _markOnboardAsShown,
            child: Text(
              'Skip',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.outlineVariant,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          next: Container(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
              shape: BoxShape.circle,
            ),
            padding: context.cPaddingSmall,
            child: const Icon(
              Icons.arrow_forward,
              color: Colors.white,
              size: 20,
            ),
          ),
          done: Container(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
              borderRadius: context.cBorderRadiusAllLow,
            ),
            padding: context.cPaddingSmall,
            child: Text(
              'Get Started',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: AppColors.background,
              ),
            ),
          ),
          dotsDecorator: DotsDecorator(
            size: const Size.square(8),
            activeSize: const Size(24, 8),
            activeColor: AppColors.primaryColor,
            color: Theme.of(context).colorScheme.outlineVariant,
            spacing: const EdgeInsets.symmetric(horizontal: 4),
            activeShape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24),
            ),
          ),
        ),
      ),
    );
  }
}

class _TitleText extends StatelessWidget {
  const _TitleText({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Text(
      text,
      style: textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
      textAlign: TextAlign.center,
    );
  }
}

class _BodyWidget extends StatelessWidget {
  const _BodyWidget({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Text(
      text,
      style: textTheme.bodyMedium?.copyWith(
        color: Theme.of(context).colorScheme.outlineVariant,
        height: 1.5,
      ),
      textAlign: TextAlign.center,
    );
  }
}
