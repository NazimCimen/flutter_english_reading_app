part of '../view/profile_view.dart';

class _RefreshProfileImageSheet extends StatefulWidget {
  const _RefreshProfileImageSheet();

  @override
  State<_RefreshProfileImageSheet> createState() =>
      _RefreshProfileImageSheetState();
}

class _RefreshProfileImageSheetState extends State<_RefreshProfileImageSheet> {
  File? _image;

  Future<void> _pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: source);

    if (pickedFile != null && mounted) {
      final croppedFile = await ImageCropper().cropImage(
        sourcePath: pickedFile.path,
        aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1),
        uiSettings: [
          CropUiSettings.getAndroidUiSettings(context),
          CropUiSettings.getIosUiSettings(),
        ],
      );

      if (croppedFile != null && mounted) {
        _image = File(croppedFile.path);
        setState(() {});
      }
    }
  }

  Future<void> _confirm() async {
    if (_image == null) return;
    
    // Show loading dialog
    CustomDialogs.showProfileImageLoadingDialog(context);
    
    // Use ViewModel to handle business logic
    final profileViewModel = context.read<ProfileViewModel>();
    await profileViewModel.uploadAndUpdateProfileImage(imageFile: _image!);
    
    if (mounted) {
      Navigator.pop(context); // Close loading dialog
      
      // Check if update was successful
      if (profileViewModel.successMessage != null) {
        Navigator.pop(context, true); // true = update successful
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: context.cMediumValue),
      child: Padding(
        padding: EdgeInsets.only(bottom: context.cMediumValue),
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
                  color: Theme.of(context).colorScheme.outlineVariant,
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
                CircleAvatar(
                  radius: context.cLargeValue * 2,
                  backgroundImage: FileImage(_image!),
                ),

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
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).colorScheme.primary,
                      ),
                      onPressed: _confirm,
                      child: Text(
                        'Onayla',
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
          color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.05),
          border: Border.all(color: Theme.of(context).colorScheme.primary, width: 1.2),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: Theme.of(context).colorScheme.primary, size: 28),
            const SizedBox(height: 8),
            Text(
              label,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
