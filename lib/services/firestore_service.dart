import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/flashcard_model.dart';
import 'package:flutter/foundation.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Singleton
  static final FirestoreService _instance = FirestoreService._internal();
  factory FirestoreService() => _instance;
  FirestoreService._internal();

  /// Syncs User Stats (Coins, Streak) to Firestore
  Future<void> syncUserStats(int coins, int streak) async {
    final user = _auth.currentUser;
    if (user == null) return;

    try {
      await _db.collection('users').doc(user.uid).set({
        'totalCoins': coins,
        'currentStreak': streak,
        'lastSync': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
      debugPrint("☁️ Synced stats to cloud.");
    } catch (e) {
      debugPrint("❌ Error syncing to cloud: $e");
    }
  }

  /// Example: Fetch user decks (Placeholder for future)
  Future<List<Flashcard>> fetchCloudDecks() async {
    // Implementation needed
    return [];
  }
}
