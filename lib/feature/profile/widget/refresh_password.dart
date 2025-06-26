part of '../view/profile_view.dart';

class _RefreshPasswordSheet extends StatefulWidget {
  const _RefreshPasswordSheet({
    required this.bottomPadding,
    required this.bottomInsets,
  });

  final double bottomPadding;
  final double bottomInsets;

  @override
  State<_RefreshPasswordSheet> createState() => _RefreshPasswordSheetState();
}

class _RefreshPasswordSheetState extends State<_RefreshPasswordSheet> {
  late final TextEditingController _currentPasswordController;
  late final TextEditingController _newPasswordController;
  late final GlobalKey<FormState> _formKey;
  late final UserService _userService;
  bool isLoading = false;

  @override
  void initState() {
    _currentPasswordController = TextEditingController();
    _newPasswordController = TextEditingController();
    _formKey = GlobalKey<FormState>();
    _userService = UserService();
    super.initState();
  }

  @override
  void dispose() {
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    super.dispose();
  }

  void setLoading(bool value) => setState(() {
    isLoading = value;
  });

  Future<void> _confirm() async {
    setLoading(true);
    final isOldCorrect = await _userService.reAuthenticateUser(
      currentPassword: _currentPasswordController.text.trim(),
    );
    if (!isOldCorrect && mounted) {
      CustomSnackBars.showCustomTopScaffoldSnackBar(
        context: context,
        text: 'The old password is incorrect',
      );
      return;
    }
    if (!validateFields()) return;
    await _userService.updatePassword(
      newPassword: _newPasswordController.text.trim(),
    );
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
          height: 300,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(context.cLargeValue),
            ),
          ),
          padding: EdgeInsets.all(context.cLargeValue),
          child: Column(
            children: [
              Text(
                'ŞİFRE DEĞİŞTİR',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: AppColors.grey600,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: context.cMediumValue),

              Form(
                key: _formKey,

                child: Column(
                  children: [
                    _AppTextField(
                      controller: _currentPasswordController,
                      hintText: 'Yeni şifrenizi girin',
                      isPassword: true,
                    ),
                    SizedBox(height: context.cMediumValue),
                    _AppTextField(
                      controller: _newPasswordController,
                      hintText: 'Yeni şifrenizi tekrar girin',
                      isPassword: true,
                    ),
                  ],
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
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  TextButton(
                    onPressed: () async {
                      await _confirm();
                    },
                    child: Text(
                      'Onayla',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppColors.primaryColor,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: context.cLowValue),
            ],
          ),
        ),
      ),
    );
  }
}
