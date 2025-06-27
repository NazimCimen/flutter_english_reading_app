part of '../view/main_layout_view.dart';

class _BottomBar extends StatelessWidget {
  const _BottomBar();

  @override
  Widget build(BuildContext context) {
    final viewModel = context.read<MainLayoutViewModel>();
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: context.cLowValue),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: context.borderRadiusAllMedium,
          color: AppColors.primaryColor,
        ),
        child: GNav(
          color: Colors.white,
          activeColor: AppColors.white,
          tabBackgroundColor: AppColors.primaryColorSoft,
          tabBorderRadius: 16,
          tabMargin: context.cPaddingSmall * 0.75,
          onTabChange: (index) {
            viewModel.setTabIndex(index);
          },
          gap: context.cLowValue / 2,
          padding: context.cPaddingMedium,
          tabs: [
            GButton(icon: Icons.home_outlined, text: StringConstants.home),
            GButton(
              icon: Icons.edit_note_outlined,
              text: StringConstants.wordBank,
            ),
            const GButton(icon: Icons.bookmark_border, text: 'Saved'),
            GButton(icon: Icons.person_outline, text: StringConstants.profile),
          ],
        ),
      ),
    );
  }
}
