import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:english_reading_app/core/error/exception.dart';
import 'package:english_reading_app/product/firebase/firebase_paths.dart';
import 'package:english_reading_app/product/model/version_model.dart';

abstract class VersionRemoteDataSource {
  Future<VersionModel> getVersionInfo();
}

class VersionRemoteDataSourceImpl implements VersionRemoteDataSource {
  final FirebaseFirestore firestore;

  VersionRemoteDataSourceImpl({required this.firestore});

  @override
  Future<VersionModel> getVersionInfo() async {
    try {
      final docSnapshot = await firestore
          .collection(FirebaseCollectionEnum.version.name)
          .doc('current')
          .get();

      if (!docSnapshot.exists) {
        throw ServerException('Version bilgisi bulunamadı');
      }

      final data = docSnapshot.data()!;
      final versionModel = VersionModel(
        androidVersion: data['androidVersion'] as String? ?? '',
        iosVersion: data['iosVersion'] as String? ?? '',
        forceUpdate: data['forceUpdate'] as bool? ?? false,
        updateMessage: data['updateMessage'] as String? ?? '',
        updateUrl: data['updateUrl'] as String?,
        createdAt: data['createdAt'] != null 
            ? DateTime.parse(data['createdAt'] as String)
            : null,
        updatedAt: data['updatedAt'] != null 
            ? DateTime.parse(data['updatedAt'] as String)
            : null,
      );
      
      return versionModel;
    } on ServerException {
      rethrow;
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
} 