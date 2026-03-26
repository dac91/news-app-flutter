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

    // Explicitly set content type so Firebase Storage security rules
    // can validate `request.resource.contentType.matches('image/.*')`.
    // Without this, putFile may not set the content type on all platforms,
    // causing an "unauthorized" rejection from the rules.
    final contentType = _resolveContentType(fileName);
    final metadata = SettableMetadata(contentType: contentType);

    final uploadTask = await ref.putFile(imageFile, metadata);
    final downloadUrl = await uploadTask.ref.getDownloadURL();

    return downloadUrl;
  }

  /// Resolves the MIME content type from the file extension.
  ///
  /// Defaults to `image/jpeg` for unrecognised extensions since
  /// the app only allows image uploads via the camera/gallery picker.
  String _resolveContentType(String fileName) {
    final ext = fileName.split('.').last.toLowerCase();
    switch (ext) {
      case 'png':
        return 'image/png';
      case 'gif':
        return 'image/gif';
      case 'webp':
        return 'image/webp';
      case 'heic':
      case 'heif':
        return 'image/heic';
      case 'jpg':
      case 'jpeg':
      default:
        return 'image/jpeg';
    }
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
