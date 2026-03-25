import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:news_app_clean_architecture/features/create_article/data/data_sources/article_data_sources.dart';
import 'package:news_app_clean_architecture/features/create_article/data/models/firebase_article_model.dart';

/// Firestore implementation of [FirestoreArticleDataSource].
///
/// This is the sole class that interacts with the Firestore service
/// for article creation. All Firestore-specific logic is isolated here.
class FirestoreArticleDataSourceImpl implements FirestoreArticleDataSource {
  final FirebaseFirestore _firestore;

  FirestoreArticleDataSourceImpl(this._firestore);

  static const String _collectionName = 'articles';

  @override
  Future<FirebaseArticleModel> createArticle(FirebaseArticleModel model) async {
    final docRef = await _firestore
        .collection(_collectionName)
        .add(model.toJson());

    // Read back the created document to get the server timestamp
    final snapshot = await docRef.get();
    return FirebaseArticleModel.fromRawData(
      snapshot.data()!,
      snapshot.id,
    );
  }
}
