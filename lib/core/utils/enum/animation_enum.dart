enum AnimationEnum {
  verification,
}

extension AssetExtension on AnimationEnum {
  String get toPathJson => 'assets/animations/$name.json';
}
