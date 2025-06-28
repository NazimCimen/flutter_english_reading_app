import 'package:english_reading_app/product/firebase/model/base_firebase_model.dart';

class VersionModel extends BaseFirebaseModel<VersionModel> {
  final String? id;
  final String androidVersion;
  final String iosVersion;
  final bool forceUpdate;
  final String updateMessage;
  final String? updateUrl;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  VersionModel({
    this.id,
    required this.androidVersion,
    required this.iosVersion,
    required this.forceUpdate,
    required this.updateMessage,
    this.updateUrl,
    this.createdAt,
    this.updatedAt,
  });

  @override
  Map<String, dynamic> toJson() {
    return {
      'androidVersion': androidVersion,
      'iosVersion': iosVersion,
      'forceUpdate': forceUpdate,
      'updateMessage': updateMessage,
      'updateUrl': updateUrl,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }

  @override
  VersionModel fromJson(Map<String, dynamic> json) {
    return VersionModel(
      androidVersion: json['androidVersion'] as String? ?? '',
      iosVersion: json['iosVersion'] as String? ?? '',
      forceUpdate: json['forceUpdate'] as bool? ?? false,
      updateMessage: json['updateMessage'] as String? ?? '',
      updateUrl: json['updateUrl'] as String?,
      createdAt: json['createdAt'] != null 
          ? DateTime.parse(json['createdAt'] as String)
          : null,
      updatedAt: json['updatedAt'] != null 
          ? DateTime.parse(json['updatedAt'] as String)
          : null,
    );
  }

  @override
  String toString() {
    return 'VersionModel(androidVersion: $androidVersion, iosVersion: $iosVersion, forceUpdate: $forceUpdate, updateMessage: $updateMessage, updateUrl: $updateUrl)';
  }
} 