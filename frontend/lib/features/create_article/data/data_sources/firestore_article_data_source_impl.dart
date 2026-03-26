import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:news_app_clean_architecture/features/create_article/data/data_sources/article_data_sources.dart';
import 'package:news_app_clean_architecture/features/create_article/data/models/firebase_article_model.dart';

/// Firestore implementation of [FirestoreArticleDataSource].
///
/// This is the sole class that interacts with the Firestore service
/// for article CRUD operations. All Firestore-specific logic is isolated here,
/// including `Timestamp` ↔ `DateTime` and `FieldValue` conversions (AV 1.2.4).
class FirestoreArticleDataSourceImpl implements FirestoreArticleDataSource {
  final FirebaseFirestore _firestore;

  FirestoreArticleDataSourceImpl(this._firestore);

  static const String _collectionName = 'articles';

  @override
  Future<FirebaseArticleModel> createArticle(FirebaseArticleModel model) async {
    final json = model.toJson();
    // Replace sentinel null with Firestore server timestamp
    json['createdAt'] = FieldValue.serverTimestamp();

    final docRef = await _firestore.collection(_collectionName).add(json);

    // Read back the created document to get the server timestamp
    final snapshot = await docRef.get();
    return _modelFromSnapshot(snapshot);
  }

  @override
  Future<FirebaseArticleModel> updateArticle(FirebaseArticleModel model) async {
    if (model.id == null) {
      throw ArgumentError('Cannot update article without an ID');
    }

    final json = model.toUpdateJson();
    // Convert DateTime → Timestamp for Firestore, or use server timestamp
    json['createdAt'] = json['createdAt'] != null
        ? Timestamp.fromDate(json['createdAt'] as DateTime)
        : FieldValue.serverTimestamp();

    await _firestore.collection(_collectionName).doc(model.id).update(json);

    // Read back the updated document
    final snapshot =
        await _firestore.collection(_collectionName).doc(model.id).get();
    return _modelFromSnapshot(snapshot);
  }

  @override
  Future<List<FirebaseArticleModel>> getArticlesByOwner(
    String ownerUid,
  ) async {
    final snapshot = await _firestore
        .collection(_collectionName)
        .where('ownerUid', isEqualTo: ownerUid)
        .orderBy('createdAt', descending: true)
        .get();

    return snapshot.docs.map((doc) => _modelFromSnapshot(doc)).toList();
  }

  /// Converts a Firestore document snapshot to a [FirebaseArticleModel].
  ///
  /// Handles the `Timestamp` → `DateTime` conversion so the model
  /// stays free of Firestore imports (AV 1.2.4).
  FirebaseArticleModel _modelFromSnapshot(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>? ?? {};
    // Convert Firestore Timestamp to DateTime before passing to model
    final rawCreatedAt = data['createdAt'];
    if (rawCreatedAt is Timestamp) {
      data['createdAt'] = rawCreatedAt.toDate();
    } else {
      data['createdAt'] = null;
    }
    return FirebaseArticleModel.fromRawData(data, doc.id);
  }
}
