import 'package:english_reading_app/feature/add_word/presentation/view/add_word_view.dart';
import 'package:english_reading_app/feature/auth/presentation/forget_password/forget_password_view.dart';
import 'package:english_reading_app/feature/auth/presentation/login/login_view.dart';
import 'package:english_reading_app/feature/auth/presentation/sign_up/sign_up_view.dart';
import 'package:english_reading_app/feature/main_layout/view/main_layout_view.dart';
import 'package:english_reading_app/feature/article_detail/presentation/view/article_detail_view.dart';
import 'package:english_reading_app/feature/onboard/onboard_view.dart';
import 'package:english_reading_app/feature/splash/splash_view.dart';
import 'package:english_reading_app/feature/word_bank/presentation/view/word_bank_view.dart';
import 'package:english_reading_app/product/model/dictionary_entry.dart';
import 'package:english_reading_app/product/model/article_model.dart';
import 'package:flutter/material.dart';

final class AppRoutes {
  const AppRoutes._();
  static const String initialRoute = '/splashView';
  static const String onboardView = '/onboardView';
  static const String loginView = '/loginView';
  static const String forgetPasswordView = '/forgetPasswordView';
  static const String signupView = '/signupView';
  static const String mainLayoutView = '/mainLayoutView';
  static const String editProfileView = '/editProfileView';
  static const String homeView = '/homeView';
  static const String articleDetailView = '/articleDetailView';
  static const String wordBankView = '/wordBankView';
  static const String addWordView = '/addWordView';

  static Map<String, WidgetBuilder> get routes => {
    initialRoute: (context) => const SplashView(),
    onboardView: (context) => const OnboardView(),
    loginView: (context) => const LoginView(),
    forgetPasswordView: (context) => const ForgetPasswordView(),
    signupView: (context) => const SignUpView(),
    mainLayoutView: (context) => const MainLayoutView(),
    articleDetailView: (context) {
      return ArticleDetailView(
        article: ModalRoute.of(context)?.settings.arguments as ArticleModel?,
      );
    },
    wordBankView: (context) => const WordBankView(),
    addWordView: (context) {
      return AddWordView(
        existingWord:
            ModalRoute.of(context)?.settings.arguments as DictionaryEntry?,
      );
    },
  };
}
