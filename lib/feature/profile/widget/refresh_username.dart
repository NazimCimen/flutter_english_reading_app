part of '../view/profile_view.dart';

class _RefreshUsernameSheet extends StatefulWidget {
  const _RefreshUsernameSheet({this.bottomPadding = 0, this.bottomInsets = 0});

  final double bottomPadding;
  final double bottomInsets;

  @override
  State<_RefreshUsernameSheet> createState() => _RefreshUsernameSheetState();
}

class _RefreshUsernameSheetState extends State<_RefreshUsernameSheet> {
  late final TextEditingController _usernameController;
  late final GlobalKey<FormState> _formKey;
  late final UserService _userService;
  bool isLoading = false;

  @override
  void initState() {
    _usernameController = TextEditingController();
    _formKey = GlobalKey<FormState>();
    _userService = UserService();
    super.initState();
  }

  @override
  void dispose() {
    _usernameController.dispose();
    super.dispose();
  }

  void setLoading(bool value) => setState(() {
    isLoading = value;
  });

  Future<void> _confirm() async {
    if (!validateFields()) return;
    setLoading(true);
    final updatedUser = context.read<MainLayoutViewModel>().user?.copyWith(
      nameSurname: _usernameController.text.trim(),
    );
    if (updatedUser == null) return;
    await _userService.updateUser(updatedUser);
    if (mounted) {
      await context.read<MainLayoutViewModel>().loadUser();
    }
    setLoading(false);
    if (mounted) {
      Navigator.pop(context);
    }
  }

  ///it used to validate fields
  bool validateFields() {
    if (_formKey.currentState!.validate()) {
      return true;
    } else {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: widget.bottomPadding),
      child: Padding(
        padding: EdgeInsets.only(bottom: widget.bottomInsets),
        child: Container(
          height: 200,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(context.cLargeValue),
            ),
          ),
          padding: EdgeInsets.all(context.cLargeValue),
          child:
              !isLoading
                  ? Column(
                    children: [
                      Text(
                        'KULLANICI ADINI DEĞİŞTİR',
                        style: Theme.of(
                          context,
                        ).textTheme.titleMedium?.copyWith(
                          color: AppColors.grey600,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Spacer(),

                      Form(
                        key: _formKey,
                        child: _AppTextField(
                          controller: _usernameController,
                          hintText: 'Kullanıcı Adını Giriniz',
                        ),
                      ),

                      const Spacer(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: Text(
                              'İptal Et',
                              style: Theme.of(context).textTheme.bodyMedium
                                  ?.copyWith(fontWeight: FontWeight.bold),
                            ),
                          ),
                          const SizedBox(width: 8),
                          TextButton(
                            onPressed: () async {
                              await _confirm();
                            },
                            child: Text(
                              'Onayla',
                              style: Theme.of(
                                context,
                              ).textTheme.bodyMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: AppColors.primaryColor,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: context.cLowValue),
                    ],
                  )
                  : const CustomProgressIndicator(),
        ),
      ),
    );
  }
}
