import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../features/news/domain/entities/user_preferences.dart';
import '../../features/news/domain/entities/article_summary.dart';

class FirebaseService {
  final FirebaseAuth _auth;
  final FirebaseFirestore _firestore;

  FirebaseService()
      : _auth = FirebaseAuth.instance,
        _firestore = FirebaseFirestore.instance;

  User? get currentUser => _auth.currentUser;

  Stream<User?> get authStateChanges => _auth.authStateChanges();

  Future<UserCredential> signInWithEmailAndPassword(
    String email,
    String password,
  ) async {
    return await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  Future<UserCredential> createUserWithEmailAndPassword(
    String email,
    String password,
  ) async {
    return await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }

  Future<void> saveUserPreferences(UserPreferences preferences) async {
    if (currentUser == null) return;

    await _firestore
        .collection('users')
        .doc(currentUser!.uid)
        .collection('preferences')
        .doc('user_prefs')
        .set(preferences.toJson());
  }

  Future<UserPreferences?> getUserPreferences() async {
    if (currentUser == null) return null;

    final doc = await _firestore
        .collection('users')
        .doc(currentUser!.uid)
        .collection('preferences')
        .doc('user_prefs')
        .get();

    if (!doc.exists) return null;

    return UserPreferences.fromJson(doc.data()!);
  }

  Future<void> saveArticleSummary(
    String articleId,
    ArticleSummary summary,
  ) async {
    if (currentUser == null) return;

    await _firestore
        .collection('users')
        .doc(currentUser!.uid)
        .collection('summaries')
        .doc(articleId)
        .set({
      'originalContent': summary.originalContent,
      'summary': summary.summary,
      'generatedAt': summary.generatedAt.toIso8601String(),
      'wordCount': summary.wordCount,
      'readingTime': summary.readingTime,
    });
  }

  Future<List<String>> getBookmarkedArticles() async {
    if (currentUser == null) return [];

    final doc = await _firestore
        .collection('users')
        .doc(currentUser!.uid)
        .collection('preferences')
        .doc('user_prefs')
        .get();

    if (!doc.exists) return [];

    final prefs = UserPreferences.fromJson(doc.data()!);
    return prefs.bookmarkedArticles;
  }

  Future<void> toggleBookmark(String articleId) async {
    if (currentUser == null) return;

    final userPrefs = await getUserPreferences();
    if (userPrefs == null) return;

    List<String> bookmarks = List.from(userPrefs.bookmarkedArticles);
    if (bookmarks.contains(articleId)) {
      bookmarks.remove(articleId);
    } else {
      bookmarks.add(articleId);
    }

    final updatedPrefs = userPrefs.copyWith(bookmarkedArticles: bookmarks);
    await saveUserPreferences(updatedPrefs);
  }

  Future<void> updatePremiumStatus(bool isPremium) async {
    if (currentUser == null) return;

    final userPrefs = await getUserPreferences();
    if (userPrefs == null) return;

    final updatedPrefs = userPrefs.copyWith(isPremium: isPremium);
    await saveUserPreferences(updatedPrefs);
  }
}
