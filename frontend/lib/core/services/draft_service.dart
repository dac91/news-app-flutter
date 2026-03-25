import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

/// Manages article draft persistence using SharedPreferences.
///
/// Drafts are stored as a JSON string under a single key.
/// Only one draft is supported at a time (the current form state).
class DraftService {
  static const _draftKey = 'article_draft';

  /// Saves the current form fields as a draft.
  Future<void> saveDraft({
    required String title,
    required String description,
    required String content,
    required String author,
    String? imageUrl,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final draft = jsonEncode({
      'title': title,
      'description': description,
      'content': content,
      'author': author,
      if (imageUrl != null) 'imageUrl': imageUrl,
    });
    await prefs.setString(_draftKey, draft);
  }

  /// Loads a previously saved draft, or returns null if none exists.
  Future<Map<String, String>?> loadDraft() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_draftKey);
    if (raw == null) return null;

    try {
      final decoded = jsonDecode(raw) as Map<String, dynamic>;
      return decoded.map((k, v) => MapEntry(k, v?.toString() ?? ''));
    } catch (_) {
      return null;
    }
  }

  /// Deletes the saved draft.
  Future<void> clearDraft() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_draftKey);
  }

  /// Returns true if a draft exists.
  Future<bool> hasDraft() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.containsKey(_draftKey);
  }
}
