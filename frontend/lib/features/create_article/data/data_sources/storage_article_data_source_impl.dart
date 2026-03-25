import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:news_app_clean_architecture/features/create_article/data/data_sources/article_data_sources.dart';

/// Cloud Storage implementation of [StorageArticleDataSource].
///
/// This is the sole class that interacts with Firebase Cloud Storage
/// for article image uploads. All Storage-specific logic is isolated here.
class StorageArticleDataSourceImpl implements StorageArticleDataSource {
  final FirebaseStorage _storage;

  StorageArticleDataSourceImpl(this._storage);

  static const String _basePath = 'media/articles';

  @override
  Future<String> uploadImage(File imageFile) async {
    final fileName = _generateFileName(imageFile);
    final ref = _storage.ref().child('$_basePath/$fileName');

    final uploadTask = await ref.putFile(imageFile);
    final downloadUrl = await uploadTask.ref.getDownloadURL();

    return downloadUrl;
  }

  /// Generates a unique filename using a timestamp prefix.
  ///
  /// Format: `{unix_millis}_{original_filename}`
  /// Example: `1711367890123_photo.jpg`
  String _generateFileName(File imageFile) {
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final originalName = imageFile.path.split('/').last;
    return '${timestamp}_$originalName';
  }
}
