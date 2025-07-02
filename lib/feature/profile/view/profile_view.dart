import 'dart:io';
import 'package:english_reading_app/config/routes/app_routes.dart';
import 'package:english_reading_app/config/routes/navigator_service.dart';
import 'package:english_reading_app/core/init/viewmodel_manager.dart';
import 'package:english_reading_app/core/size/app_border_radius_extensions.dart';
import 'package:english_reading_app/core/size/constant_size.dart';
import 'package:english_reading_app/core/size/padding_extension.dart';
import 'package:english_reading_app/core/utils/app_validators.dart';
import 'package:english_reading_app/feature/main_layout/viewmodel/main_layout_view_model.dart';
import 'package:english_reading_app/feature/profile/viewmodel/profile_view_model.dart';
import 'package:english_reading_app/feature/profile/widget/language_sheet_widget.dart';
import 'package:english_reading_app/feature/profile/widget/theme_card_widget.dart';
import 'package:english_reading_app/feature/profile/widget/email_verification_tile.dart';
import 'package:english_reading_app/product/componets/custom_snack_bars.dart';
import 'package:english_reading_app/product/constants/app_colors.dart';
import 'package:english_reading_app/product/widgets/custom_progress_indicator.dart';
import 'package:english_reading_app/services/url_service.dart';
import 'package:english_reading_app/services/user_service.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
part '../widget/action_tile.dart';
part '../widget/profile_appbar.dart';
part '../widget/refresh_password.dart';
part '../widget/custom_text_field.dart';
part '../widget/refresh_username.dart';
part '../widget/refresh_profile_image.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  final urlService = UrlServiceImpl();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        
        slivers: [
          SliverToBoxAdapter(child: SizedBox(height: context.cLowValue)),
          const _ProfileAppBar(),
          SliverList(
            delegate: SliverChildListDelegate([
              Consumer<MainLayoutViewModel>(
                builder: (context, mainLayoutViewModel, child) {
                  if (!mainLayoutViewModel.isMailVerified &&
                      mainLayoutViewModel.user != null) {
                    return EmailVerificationTile(
                      mainLayoutViewModel: mainLayoutViewModel,
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),
              if (context.watch<MainLayoutViewModel>().user != null)
                _ActionTile(
                  icon: Icons.person_outline,
                  title: 'Kullanıcı Adını Değiştir',
                  onTap: () {
                    showModalBottomSheet<void>(
                      context: context,
                      isScrollControlled: true,
                      backgroundColor: Colors.transparent,
                      builder: (context) {
                        final bottomInsets =
                            MediaQuery.of(context).viewInsets.bottom;
                        final bottomPadding =
                            MediaQuery.of(context).padding.bottom;

                        return _RefreshUsernameSheet(
                          bottomPadding: bottomPadding,
                          bottomInsets: bottomInsets,
                        );
                      },
                    );
                  },
                ),
              if (context.watch<MainLayoutViewModel>().user != null)
                _ActionTile(
                  icon: Icons.password_outlined,
                  title: 'Şifreni Değiştir',
                  onTap: () {
                    showModalBottomSheet<void>(
                      context: context,
                      isScrollControlled: true,
                      backgroundColor: Colors.transparent,
                      builder: (context) {
                        final bottomInsets =
                            MediaQuery.of(context).viewInsets.bottom;
                        final bottomPadding =
                            MediaQuery.of(context).padding.bottom;

                        return _RefreshPasswordSheet(
                          bottomPadding: bottomPadding,
                          bottomInsets: bottomInsets,
                        );
                      },
                    );
                  },
                ),
              if (context.watch<MainLayoutViewModel>().user != null)
                _ActionTile(
                  icon: Icons.image_outlined,
                  title: 'Profil Resimini Değiştir',
                  onTap: () {
                    showModalBottomSheet<void>(
                      context: context,
                      isScrollControlled: true,
                      backgroundColor: Colors.transparent,
                      builder: (context) {
                        final bottomInsets =
                            MediaQuery.of(context).viewInsets.bottom;
                        final bottomPadding =
                            MediaQuery.of(context).padding.bottom;

                        return _RefreshProfileImageSheet(
                          bottomPadding: bottomPadding,
                          bottomInsets: bottomInsets,
                        );
                      },
                    );
                  },
                ),
              _ActionTile(
                icon: Icons.support_agent_outlined,
                title: 'Bize Ulaşın',
                onTap: () async {
                  final result = await urlService.launchEmail(
                    'cimennazim.dev@gmail.com',
                    'subject=Destek Talebi&body=Merhaba Lingzy,',
                  );
                  if (!result && mounted) {
                    CustomSnackBars.showCustomBottomScaffoldSnackBar(
                      context: context,
                      text: 'E-posta uygulaması açılamadı.',
                    );
                  }
                },
              ),
              _ActionTile(
                icon: Icons.privacy_tip_outlined,
                title: 'Gizlilik Politikası',
                onTap: () => (),
              ),
              _ActionTile(
                icon: Icons.description_outlined,
                title: 'Kullanım Şartları',
                onTap: () => (),
              ),
              _ActionTile(
                icon: Icons.palette_outlined,
                title: 'Theme',
                onTap: () {
                  showModalBottomSheet<void>(
                    context: context,
                    showDragHandle: true,
                    isScrollControlled: true,
                    backgroundColor: Theme.of(context).colorScheme.surface,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(20),
                      ),
                    ),
                    builder: (context) {
                      return const ThemeCardWidget();
                    },
                  );
                },
              ),
              _ActionTile(
                icon: Icons.palette_outlined,
                title: 'Dil',
                onTap: () {
                  showModalBottomSheet<void>(
                    context: context,
                    showDragHandle: true,
                    isScrollControlled: true,
                    backgroundColor: Theme.of(context).colorScheme.surface,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(20),
                      ),
                    ),
                    builder: (context) {
                      return const LanguageSheetWidget();
                    },
                  );
                },
              ),
              _ActionTile(
                icon: Icons.share_outlined,
                title: 'Share App',
                onTap: () => (),
              ),
              // Show different button based on authentication status
              Consumer<MainLayoutViewModel>(
                builder: (context, mainLayoutViewModel, child) {
                  final currentUser = mainLayoutViewModel.user;

                  if (currentUser == null) {
                    // User is not logged in - show sign up button
                    return _ActionTile(
                      icon: Icons.person_add_outlined,
                      title: 'Kayıt Ol',
                      onTap: () async {
                        await NavigatorService.pushNamedAndRemoveUntil(
                          AppRoutes.signupView,
                        );
                      },
                    );
                  } else {
                    // User is logged in - show logout button
                    return _ActionTile(
                      icon: Icons.logout_outlined,
                      title: 'Çıkış Yap',
                      onTap: () async {
                        // Reset all viewmodels
                        ViewModelManager().resetAllViewModels(context);
                        
                        // Logout from Firebase
                        await context.read<ProfileViewModel>().logout();

                        // Navigate to login
                        await NavigatorService.pushNamedAndRemoveUntil(
                          AppRoutes.loginView,
                        );
                      },
                    );
                  }
                },
              ),
              SizedBox(height: context.cXxLargeValue * 7),
            ]),
          ),
        ],
      ),
    );
  }
}
