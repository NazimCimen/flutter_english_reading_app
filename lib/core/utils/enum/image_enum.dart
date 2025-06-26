enum ImageEnums {
  logo,
  logo_dark,
  logo_orj,
  google_logo,
  auth_back,
  forget_password,
  refresh_password,
  flag_turkey,
  flag_usa,
  ic_contact,
  ic_instagram,
  ic_facebook,
  ic_x,
  ic_x_light,
  ic_youtube,
  eras_banner,
}

extension AssetExtension on ImageEnums {
  String get toPathPng => 'assets/images/$name.png';
}
