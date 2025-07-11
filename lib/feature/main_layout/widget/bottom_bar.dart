part of '../view/main_layout_view.dart';

class _BottomBar extends StatelessWidget {
  const _BottomBar();

  @override
  Widget build(BuildContext context) {
    final viewModel = context.read<MainLayoutViewModel>();
    return Container(
      margin: EdgeInsets.fromLTRB(context.cLowValue, 0, context.cLowValue, 0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(context.cLargeValue),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.primaryColor,
            AppColors.primaryColor.withValues(alpha: 0.95),
            AppColors.primaryColor,
          ],
          stops: const [0.0, 0.5, 1.0],
        ),
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(context.cLargeValue),
          border: Border.all(color: AppColors.white.withValues(alpha: 0.3)),
        ),
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: context.cLowValue / 4,
            vertical: context.cLowValue / 4,
          ),
          child: GNav(
            color: AppColors.white.withValues(alpha: 0.6),
            activeColor: AppColors.white,
            tabBackgroundGradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                AppColors.white.withValues(alpha: 0.25),
                AppColors.white.withValues(alpha: 0.1),
              ],
            ),
            tabBorderRadius: context.cMediumValue,
            tabMargin: EdgeInsets.symmetric(
              horizontal: context.cLowValue / 3,
              vertical: context.cLowValue / 3,
            ),
            onTabChange: (index) {
              viewModel.setTabIndex(index);
              HapticFeedback.mediumImpact();
            },
            gap: context.cLowValue / 2,
            padding: EdgeInsets.symmetric(
              horizontal: context.cMediumValue,
              vertical: context.cMediumValue,
            ),
            curve: Curves.easeInOutQuart,
            tabs: [
              _buildGButton(
                context,
                icon: Icons.home_rounded,
                text: 'Home',
                gradient: LinearGradient(
                  colors: [
                    AppColors.primaryColor.withValues(alpha: 0.8),
                    AppColors.primaryColor,
                  ],
                ),
              ),
              _buildGButton(
                context,
                icon: Icons.auto_stories_rounded,
                text: 'Words',
                gradient: LinearGradient(
                  colors: [
                    AppColors.primaryColor.withValues(alpha: 0.8),
                    AppColors.primaryColor,
                  ],
                ),
              ),
              _buildGButton(
                context,
                icon: Icons.bookmark_rounded,
                text: 'Saved',
                gradient: LinearGradient(
                  colors: [
                    AppColors.primaryColor.withValues(alpha: 0.8),
                    AppColors.primaryColor,
                  ],
                ),
              ),
              _buildGButton(
                context,
                icon: Icons.person_rounded,
                text: 'Profile',
                gradient: LinearGradient(
                  colors: [
                    AppColors.primaryColor.withValues(alpha: 0.8),
                    AppColors.primaryColor,
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  GButton _buildGButton(
    BuildContext context, {
    required IconData icon,
    required String text,
    required Gradient gradient,
  }) {
    return GButton(
      icon: icon,
      text: text,
      iconSize: 24,
      leading: Container(
        padding: EdgeInsets.all(context.cLowValue / 3),
        decoration: BoxDecoration(
          gradient: gradient,
          borderRadius: BorderRadius.circular(context.cLowValue.toDouble()),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: context.cLowValue / 2,
              offset: Offset(0, context.cLowValue / 4),
            ),
          ],
          border: Border.all(color: AppColors.grey.withOpacity(0.4)),
        ),
        child: Icon(icon, size: 20, color: AppColors.white),
      ),
      textStyle: Theme.of(context).textTheme.labelLarge?.copyWith(
        color: AppColors.white,
        fontWeight: FontWeight.w700,
        letterSpacing: 0.6,
        shadows: [
          Shadow(
            color: Colors.black.withValues(alpha: 0.3),
            offset: const Offset(0, 1),
            blurRadius: 2,
          ),
        ],
      ),
    );
  }
}
