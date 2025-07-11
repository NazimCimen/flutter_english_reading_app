part of '../view/profile_view.dart';

class _ProfileAppBar extends StatelessWidget {
  const _ProfileAppBar();

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      centerTitle: true,
      expandedHeight: 300,
      pinned: true,
      title: const Text(''),
      flexibleSpace: LayoutBuilder(
        builder: (context, constraints) {
          final isCollapsed =
              constraints.maxHeight <=
              kToolbarHeight + MediaQuery.of(context).padding.top;
          if (context.watch<MainLayoutViewModel>().user == null) {
            return _NoAccount(isCollapsed: isCollapsed);
          } else {
            final username =
                context.read<MainLayoutViewModel>().user?.nameSurname ?? '';
            final imageUrl =
                context.read<MainLayoutViewModel>().user?.profileImageUrl ?? '';
            return _User(
              isCollapsed: isCollapsed,
              username: username,
              imageUrl: imageUrl,
            );
          }
        },
      ),
    );
  }
}

class _User extends StatelessWidget {
  const _User({
    required this.isCollapsed,
    required this.username,
    required this.imageUrl,
  });

  final bool isCollapsed;
  final String username;
  final String imageUrl;

  @override
  Widget build(BuildContext context) {
    return FlexibleSpaceBar(
      centerTitle: true,
      title:
          isCollapsed
              ? Text(username, style: Theme.of(context).textTheme.bodyLarge)
              : null,
      background: Padding(
        padding: const EdgeInsets.only(top: 60),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 45,
              backgroundColor: Theme.of(context).colorScheme.primary,
              backgroundImage:
                  imageUrl.isNotEmpty ? NetworkImage(imageUrl) : null,
              child:
                  imageUrl.isEmpty
                      ? Icon(
                        Icons.person,
                        size: 45,
                        color: Theme.of(context).colorScheme.onPrimary,
                      )
                      : null,
            ),
            SizedBox(height: context.cLowValue),
            Text(username, style: Theme.of(context).textTheme.titleLarge),
          ],
        ),
      ),
    );
  }
}

class _NoAccount extends StatelessWidget {
  const _NoAccount({required this.isCollapsed});
  final bool isCollapsed;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    final avatarRadius = width * 0.13; // örn: 390px ekranda 50px
    final buttonWidth = width * 0.7 > 320 ? 320.0 : width * 0.7;

    return FlexibleSpaceBar(
      centerTitle: true,
      title: Text(
        isCollapsed ? 'Profil' : '',
        style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
      ),
      background: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: height * 0.04),
              CircleAvatar(
                radius: avatarRadius,
                backgroundColor: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                child: Icon(
                  Icons.person_outline,
                  size: avatarRadius,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              SizedBox(height: height * 0.02),
              Text(
                'Hesap Oluşturun',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
              ),
              SizedBox(height: height * 0.01),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: width * 0.08),
                child: Text(
                  'Tüm cihazlarınızda ilerlemenizi kaydedin ve verilerinizi güvende tutun.',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.grey[700],
                      ),
                ),
              ),
              SizedBox(height: height * 0.02),
              SizedBox(
                width: buttonWidth,
                child: ElevatedButton.icon(
                  icon: Icon(Icons.person_add_alt_1, color: Colors.white),
                  label: Text('Lingzy Hesabı Oluştur'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: context.cBorderRadiusAllMedium,
                    ),
                    padding: EdgeInsets.symmetric(vertical: height * 0.018),
                    elevation: 0,
                  ),
                  onPressed: () {},
                ),
              ),
              TextButton(
                onPressed: () {},
                child: Text(
                  'Zaten hesabın var mı? Giriş Yap',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context).colorScheme.primary,
                        fontWeight: FontWeight.w600,
                      ),
                ),
              ),
              SizedBox(height: height * 0.04),
            ],
          ),
        ),
      ),
    );
  }
}
