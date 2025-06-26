part of '../view/profile_view.dart';

class _RefreshProfileImageSheet extends StatefulWidget {
  const _RefreshProfileImageSheet({
    required this.bottomPadding,
    required this.bottomInsets,
  });

  final double bottomPadding;
  final double bottomInsets;

  @override
  State<_RefreshProfileImageSheet> createState() =>
      _RefreshProfileImageSheetState();
}

class _RefreshProfileImageSheetState extends State<_RefreshProfileImageSheet> {
  File? _image;
  late final UserService _userService;

  @override
  void initState() {
    _userService = UserService();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> _pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: source);

    if (pickedFile != null) {
      final croppedFile = await ImageCropper().cropImage(
        sourcePath: pickedFile.path,
        aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1),
        uiSettings: [
          AndroidUiSettings(
            toolbarTitle: 'Kırp',
            toolbarColor: AppColors.primaryColor,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.square,
            lockAspectRatio: true,
          ),
          IOSUiSettings(title: 'Kırp', aspectRatioLockEnabled: true),
        ],
      );

      if (croppedFile != null) {
        _image = File(croppedFile.path);
        setState(() {});
      }
    }
  }

  Future<void> _confirm() async {}

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: widget.bottomPadding),
      child: Padding(
        padding: EdgeInsets.only(bottom: widget.bottomInsets),
        child: Container(
          height: 250,
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
                'PROFİL RESMİNİ DEĞİŞTİR',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: AppColors.grey600,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              if (_image == null)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _ImageOptionButton(
                      icon: Icons.photo_library_outlined,
                      label: 'Galeri',
                      onTap: () => _pickImage(ImageSource.gallery),
                    ),
                    _ImageOptionButton(
                      icon: Icons.camera_alt_outlined,
                      label: 'Kamera',
                      onTap: () => _pickImage(ImageSource.camera),
                    ),
                  ],
                )
              else
                CircleAvatar(radius: 65, backgroundImage: FileImage(_image!)),

              const Spacer(),
              if (_image != null)
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
                      onPressed: () {
                        // Onaylama işlemi
                        Navigator.pop(context);
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

class _ImageOptionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _ImageOptionButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.38,
        padding: const EdgeInsets.symmetric(vertical: 18),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: AppColors.primaryColor.withOpacity(0.05),
          border: Border.all(color: AppColors.primaryColor, width: 1.2),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: AppColors.primaryColor, size: 28),
            const SizedBox(height: 8),
            Text(
              label,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppColors.primaryColor,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
