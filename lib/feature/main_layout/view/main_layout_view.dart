import 'package:english_reading_app/feature/main_layout/export.dart';
import 'package:english_reading_app/feature/home/presentation/view/home_view.dart';
import 'package:english_reading_app/feature/profile/view/profile_view.dart';
import 'package:english_reading_app/feature/word_bank/presentation/view/word_bank_view.dart';
import 'package:english_reading_app/feature/main_layout/mixin/main_layout_mixin.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

part '../widget/bottom_bar.dart';

class MainLayoutView extends StatefulWidget {
  const MainLayoutView({super.key});

  @override
  State<MainLayoutView> createState() => _MainLayoutViewState();
}

class _MainLayoutViewState extends State<MainLayoutView> with MainLayoutMixin{
  @override
  Widget build(BuildContext context) {
    final body = [
      const HomeView(),
      const WordBankView(),
      Container(),
      const ProfileView(),
    ];

    return Consumer<MainLayoutViewModel>(
      builder: (context, viewModel, child) {
        return DefaultTabController(
          length: 4,
          initialIndex: viewModel.currentIndex,
          child: Scaffold(
            extendBody: true,
            extendBodyBehindAppBar: true,
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerDocked,
            resizeToAvoidBottomInset: false,
            bottomNavigationBar: Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).padding.bottom + 10,
              ),
              child: const _BottomBar(),
            ),
            body: body[context.watch<MainLayoutViewModel>().currentIndex],
          ),
        );
      },
    );
  }
}
