part of '../view/profile_view.dart';

class _RefreshPasswordSheet extends StatefulWidget {
  const _RefreshPasswordSheet();

  @override
  State<_RefreshPasswordSheet> createState() => _RefreshPasswordSheetState();
}

class _RefreshPasswordSheetState extends State<_RefreshPasswordSheet> {
  late final TextEditingController _currentPasswordController;
  late final TextEditingController _newPasswordController;
  late final GlobalKey<FormState> _formKey;

  @override
  void initState() {
    _currentPasswordController = TextEditingController();
    _newPasswordController = TextEditingController();
    _formKey = GlobalKey<FormState>();
    super.initState();
  }

  @override
  void dispose() {
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    super.dispose();
  }

  Future<void> _confirm() async {
    if (!validateFields()) return;
    
    final success = await context.read<ProfileViewModel>().updatePassword(
      currentPassword: _currentPasswordController.text.trim(),
      newPassword: _newPasswordController.text.trim(),
      context: context,
    );
    
    if (success && mounted) {
      Navigator.pop(context);
    }
  }

  /// Validate form fields
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
      margin: EdgeInsets.only(bottom: context.cMediumValue),
      child: Padding(
        padding: EdgeInsets.only(bottom: context.cMediumValue),
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
                'ŞİFRENİ DEĞİŞTİR',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Theme.of(context).colorScheme.outlineVariant,
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
                  SizedBox(width: context.cLowValue),
                  Consumer<ProfileViewModel>(
                    builder: (context, profileViewModel, child) {
                      return ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Theme.of(context).colorScheme.primary,
                        ),
                        onPressed: profileViewModel.isLoading 
                          ? null 
                          : () async {
                              await _confirm();
                            },
                        child: profileViewModel.isLoading
                          ? SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  Theme.of(context).colorScheme.surface,
                                ),
                              ),
                            )
                          : Text(
                              'Onayla',
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).colorScheme.surface,
                              ),
                            ),
                      );
                    },
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
