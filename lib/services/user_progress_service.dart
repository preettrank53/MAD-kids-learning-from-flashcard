import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'firestore_service.dart';

class UserProgressService extends ChangeNotifier {
  
  // Singleton pattern
  static final UserProgressService _instance = UserProgressService._internal();
  factory UserProgressService() => _instance;
  UserProgressService._internal();

  final FirestoreService _firestoreService = FirestoreService();

  int _totalCoins = 0;
  int _currentStreak = 0;
  String _lastLoginDate = '';

  int get totalCoins => _totalCoins;
  int get currentStreak => _currentStreak;

  Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    _totalCoins = prefs.getInt('totalCoins') ?? 0;
    _currentStreak = prefs.getInt('currentStreak') ?? 0;
    _lastLoginDate = prefs.getString('lastLoginDate') ?? '';
    
    _checkDailyStreak(prefs);
    notifyListeners();
  }

  // --- COINS LOGIC ---

  Future<void> addCoins(int amount) async {
    _totalCoins += amount;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('totalCoins', _totalCoins);
    _firestoreService.syncUserStats(_totalCoins, _currentStreak);
    notifyListeners();
  }

  // --- STREAK LOGIC ---

  Future<void> _checkDailyStreak(SharedPreferences prefs) async {
    DateTime now = DateTime.now();
    String today = "${now.year}-${now.month}-${now.day}";
    
    if (_lastLoginDate == today) {
      // Already logged in today, do nothing
      return;
    }

    if (_lastLoginDate.isNotEmpty) {
      DateTime lastDate = DateTime.parse(_lastLoginDate);
      // Check if last login was yesterday (difference of 1 day)
      // Note: This is a simplified check. A robust one checks day difference.
      final difference = now.difference(lastDate).inDays;
      
      if (difference == 1) {
        // Consecutive day!
        _currentStreak++;
      } else if (difference > 1) {
        // Streak broken
        _currentStreak = 1;
      } else {
        // Should not happen if logic is correct (difference 0 handled above)
      }
    } else {
      // First time ever
      _currentStreak = 1;
    }

    _lastLoginDate = today;
    await prefs.setString('lastLoginDate', _lastLoginDate);
    await prefs.setInt('currentStreak', _currentStreak);
    _firestoreService.syncUserStats(_totalCoins, _currentStreak);
    // Give bonus for daily login? Maybe later.
  }
}
