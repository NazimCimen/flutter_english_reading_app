part of '../view/profile_view.dart';

class _ProfileAppBar extends StatelessWidget {
  const _ProfileAppBar();

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      centerTitle: true,
      expandedHeight: 250,
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
            CircleAvatar(radius: 45, backgroundImage: NetworkImage(imageUrl)),
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
    return FlexibleSpaceBar(
      centerTitle: true,
      title: Text(
        isCollapsed ? 'Profile' : '',
        style: Theme.of(
          context,
        ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
      ),
      background: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: context.cMediumValue,
          vertical: context.cLargeValue,
        ),
        child: Container(
          decoration: BoxDecoration(
            //   color: AppColors.primaryColorSoft,
            borderRadius: context.cBorderRadiusAllMedium,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                textAlign: TextAlign.center,
                'Lingzy ile verileriniz güvende kalırken tüm cihazlarınızda kaldığınız yerden devam edebilirsiniz. Sadece birkaç dakikanızı ayırarak hesap oluşturabilir veya mevcut hesabınızla giriş yapabilirsiniz.',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  //  color: AppColors.white,
                ),
              ),
              SizedBox(height: context.cLowValue),

              OutlinedButton(
                style: OutlinedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: context.cBorderRadiusAllMedium,
                  ),
                ),
                child: Text(
                  '+ Lingzy Hesabını Oluştur',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    //  color: AppColors.white,
                  ),
                ),
                onPressed: () {},
              ),
              SizedBox(height: context.cLowValue),

              Text(
                textAlign: TextAlign.center,
                'Zaten kayıtlı bir hesabın var ise Giriş Yap',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  //  color: AppColors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
