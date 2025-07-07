part of '../view/profile_view.dart';

class _RefreshUsernameSheet extends StatefulWidget {
  final String? username;
  const _RefreshUsernameSheet({required this.username});

  @override
  State<_RefreshUsernameSheet> createState() => _RefreshUsernameSheetState();
}

class _RefreshUsernameSheetState extends State<_RefreshUsernameSheet> {
  late final TextEditingController _usernameController;
  late final GlobalKey<FormState> _formKey;

  @override
  void initState() {
    _usernameController = TextEditingController(text: widget.username ?? '');
    _formKey = GlobalKey<FormState>();
    super.initState();
  }

  @override
  void dispose() {
    _usernameController.dispose();
    super.dispose();
  }

  Future<void> _confirm() async {
    if (!validateFields()) return;
    
    final success = await context.read<ProfileViewModel>().updateUsername(
      newUsername: _usernameController.text.trim(),
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
          height: 200,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(context.cLargeValue),
            ),
          ),
          padding: EdgeInsets.all(context.cLargeValue),
          child: Consumer<ProfileViewModel>(
            builder: (context, profileViewModel, child) {
              return profileViewModel.isLoading
                  ? const CustomProgressIndicator()
                  : Column(
                      children: [
                        Text(
                          'CHANGE USERNAME',
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: Theme.of(context).colorScheme.outlineVariant,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Spacer(),

                        Form(
                          key: _formKey,
                          child: _AppTextField(
                            controller: _usernameController,
                            hintText: 'Enter Username',
                          ),
                        ),

                        const Spacer(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: Text(
                                'Cancel',
                                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Theme.of(context).colorScheme.primary,
                              ),
                              onPressed: () async {
                                await _confirm();
                              },
                              child: Text(
                                'Confirm',
                                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(context).colorScheme.surface,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: context.cLowValue),
                      ],
                    );
            },
          ),
        ),
      ),
    );
  }
}
