import 'package:shared_preferences/shared_preferences.dart';

class TimeStorage {
  static const String key = "saved_times";

  // Save a new time (in milliseconds)
  static Future<void> saveTime(int milliseconds) async {
    final prefs = await SharedPreferences.getInstance();

    // Load existing list
    List<String> times = prefs.getStringList(key) ?? [];

    // Add new time
    times.add(milliseconds.toString());

    // Save updated list
    await prefs.setStringList(key, times);
  }

  // Load all saved times
  static Future<List<int>> loadTimes() async {
  final prefs = await SharedPreferences.getInstance();
  List<String> times = prefs.getStringList(key) ?? [];

  // Convert to int
  List<int> msTimes = times.map(int.parse).toList();

  // Sort ascending (fastest first)
  msTimes.sort();

  return msTimes;
}


  // Clear all saved times (optional)
  static Future<void> clearTimes() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(key);
  }
}
