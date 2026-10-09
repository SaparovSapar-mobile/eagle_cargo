import 'package:shared_preferences/shared_preferences.dart';

class PreferenceManager {
  static late SharedPreferences _prefs;

  static final PreferenceManager _instance = PreferenceManager._internal();

  static PreferenceManager get instance => _instance;

  PreferenceManager._internal();

  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  Future<bool> setStringValue(String key, String value) async {
    return await _prefs.setString(key, value);
  }

  String getStringValue(String key) {
    return _prefs.getString(key) ?? "";
  }

  Future<bool> setBoolValue(String key, bool value) async {
    return await _prefs.setBool(key, value);
  }

  bool getBoolValue(String key) {
    return _prefs.getBool(key) ?? false;
  }

  Future<bool> setIntValue(String key, int value) async {
    return await _prefs.setInt(key, value);
  }

  int getIntValue(String key) {
    return _prefs.getInt(key) ?? 0;
  }

  Future<bool> removeKey(String key) async {
    return await _prefs.remove(key);
  }

  Future<bool> clearAll() async {
    return await _prefs.clear();
  }
}
