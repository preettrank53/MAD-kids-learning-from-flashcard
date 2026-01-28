import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PrefsService extends ChangeNotifier {
  static const String keyChildName = 'child_name';
  static const String keyStars = 'user_stars'; // "Stars" as requested
  static const String keyStreak = 'user_streak';
  static const String keyLastDate = 'last_played_date';

  String _childName = "Learner";
  int _stars = 0;
  int _streak = 0;

  String get childName => _childName;
  int get stars => _stars;
  int get streak => _streak;

  Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    _childName = prefs.getString(keyChildName) ?? "Learner";
    _stars = prefs.getInt(keyStars) ?? 0;
    _streak = prefs.getInt(keyStreak) ?? 0;
    
    // Check streak on init? Or explicit call? 
    // User asked for updateStreak() logic. We'll do it there or on load.
    // Let's safe-check streak on load too.
    _checkStreakLogic(prefs);
    
    notifyListeners();
  }

  Future<void> setChildName(String name) async {
    _childName = name;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(keyChildName, name);
    notifyListeners();
  }

  Future<void> addStars(int amount) async {
    _stars += amount;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(keyStars, _stars);
    notifyListeners();
  }

  Future<void> updateStreak() async {
    final prefs = await SharedPreferences.getInstance();
    await _checkStreakLogic(prefs);
    notifyListeners();
  }

  Future<void> _checkStreakLogic(SharedPreferences prefs) async {
    String? lastDateStr = prefs.getString(keyLastDate);
    DateTime now = DateTime.now();
    String todayStr = "${now.year}-${now.month}-${now.day}";

    if (lastDateStr == todayStr) {
      // Already played today
      return;
    }

    if (lastDateStr != null) {
      DateTime lastDate = DateTime.parse(lastDateStr);
      // Check difference
      // We reconstruct dates to ignore time component
      DateTime dLast = DateTime(lastDate.year, lastDate.month, lastDate.day);
      DateTime dNow = DateTime(now.year, now.month, now.day);
      
      int diff = dNow.difference(dLast).inDays;

      if (diff == 1) {
        // Consecutive
        _streak++;
      } else if (diff > 1) {
        // Broke streak (Reset to 1 because they played today)
        _streak = 1;
      } else {
        // Should not happen (diff 0 handled above, negative implies time travel)
      }
    } else {
      // First time
      _streak = 1;
    }

    // Save new state
    await prefs.setString(keyLastDate, todayStr);
    await prefs.setInt(keyStreak, _streak);
    
    // Sync to local variable
    // (Actual saving happens above, but good to keep robust)
  }
}
