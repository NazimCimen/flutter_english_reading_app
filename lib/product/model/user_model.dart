import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:english_reading_app/product/firebase/model/base_firebase_model.dart';

part 'user_model.g.dart';

@JsonSerializable()
class UserModel extends Equatable implements BaseFirebaseModel<UserModel> {
  final String? userId;
  final String? nameSurname;
  final String? email;
  final String? profileImageUrl;
  final DateTime? createdAt;

  const UserModel({
    this.userId,
    this.nameSurname,
    this.email,
    this.profileImageUrl,
    this.createdAt,
  });

  @override
  List<Object?> get props => [
        userId,
        nameSurname,
        email,
        profileImageUrl,
        createdAt,
      ];

  UserModel copyWith({
    String? userId,
    String? nameSurname,
    String? email,
    String? profileImageUrl,
    DateTime? createdAt,
  }) =>
      UserModel(
        userId: userId ?? this.userId,
        nameSurname: nameSurname ?? this.nameSurname,
        email: email ?? this.email,
        profileImageUrl: profileImageUrl ?? this.profileImageUrl,
        createdAt: createdAt ?? this.createdAt,
      );

  @override
  UserModel fromJson(Map<String, dynamic> json) => _$UserModelFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$UserModelToJson(this);

  @override
  String? get id => userId;
}
