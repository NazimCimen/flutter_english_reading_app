import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';

@immutable
final class CropUiSettings {
  const CropUiSettings._();

  static AndroidUiSettings getAndroidUiSettings(BuildContext context) {
    final primaryColor = Theme.of(context).colorScheme.primary;
    final onPrimaryColor = Theme.of(context).colorScheme.onPrimary;
    final surfaceColor = Theme.of(context).colorScheme.surface;

    return AndroidUiSettings(
      toolbarTitle: 'Kırp',
      toolbarColor: primaryColor,
      toolbarWidgetColor: onPrimaryColor,
      backgroundColor: surfaceColor,
      statusBarColor: primaryColor,
      initAspectRatio: CropAspectRatioPreset.square,
      lockAspectRatio: true,
      cropFrameColor: primaryColor,
      cropGridColor: primaryColor.withValues(alpha: 0.5),
      cropGridColumnCount: 3,
      cropGridRowCount: 3,
      hideBottomControls: false,
      cropFrameStrokeWidth: 2,
      activeControlsWidgetColor: primaryColor,
      dimmedLayerColor: surfaceColor.withValues(alpha: 0.7),
    );
  }

  // iOS UI ayarları
  static IOSUiSettings getIosUiSettings() {
    return IOSUiSettings(
      title: 'Kırp',
      aspectRatioLockEnabled: true,
      aspectRatioPickerButtonHidden: true,
      rotateButtonsHidden: false,
      rotateClockwiseButtonHidden: false,
      doneButtonTitle: 'Tamam',
      cancelButtonTitle: 'İptal',
      resetButtonHidden: false,
    );
  }
}
