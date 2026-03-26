import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:news_app_clean_architecture/features/ai_insight/data/data_sources/ai_insight_data_sources.dart';
import 'package:news_app_clean_architecture/features/ai_insight/data/models/ai_insight_model.dart';

/// Firestore implementation of [InsightCacheDataSource].
///
/// Caches AI insights in a dedicated `ai_insights` collection to avoid
/// redundant Gemini API calls for the same article. Each document is
/// keyed by a hash of the article URL.
class FirestoreInsightCacheImpl implements InsightCacheDataSource {
  final FirebaseFirestore _firestore;

  FirestoreInsightCacheImpl(this._firestore);

  static const String _collectionName = 'ai_insights';

  @override
  Future<AiInsightModel?> getCachedInsight(String cacheKey) async {
    final doc =
        await _firestore.collection(_collectionName).doc(cacheKey).get();

    if (!doc.exists || doc.data() == null) {
      return null;
    }

    return AiInsightModel.fromRawData(doc.data()!);
  }

  @override
  Future<void> cacheInsight(String cacheKey, AiInsightModel model) async {
    await _firestore
        .collection(_collectionName)
        .doc(cacheKey)
        .set(model.toJson());
  }
}
