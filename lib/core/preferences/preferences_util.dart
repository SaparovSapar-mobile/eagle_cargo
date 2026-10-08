import 'package:shared_preferences/shared_preferences.dart';

import 'preference_keys.dart';

class PreferenceManager {
  //I dont know what is it :)
  PreferenceManager._init() {
    SharedPreferences.getInstance().then((value) {
      _preferences = value;
    });
  }
  static final PreferenceManager _instance = PreferenceManager._init();

  SharedPreferences? _preferences;
  static PreferenceManager get instance => _instance;
  //Initiator
  static Future ensureInitialized() async {
    instance._preferences ??= await SharedPreferences.getInstance();
  }

  //Remove specific element with KEY
  Future<void> remove(PreferenceKeys key) async =>
      await _preferences?.remove(key.name);

  //Clear all persistent datas from memory
  Future<void> clearAll() async {
    await _preferences?.clear();
  }

  //I don't know what is that
  Future<void> clearAllSaveFirst() async {
    if (_preferences != null) {
      await _preferences!.clear();
      await setBoolValue(PreferenceKeys.IS_FIRST_APP, true);
    }
  }

  //GET & SET String values
  Future<void> setStringValue(PreferenceKeys key, String value) async {
    await _preferences?.setString(key.name, value);
  }

  String getStringValue(PreferenceKeys key) =>
      _preferences?.getString(key.name) ?? '';

  //GET & SET Boolean values
  Future<void> setBoolValue(PreferenceKeys key, bool value) async {
    await _preferences?.setBool(key.name, value);
  }

  bool getBoolValue(PreferenceKeys key) {
    if (key == PreferenceKeys.IS_FIRST_APP &&
        _preferences!.getBool(key.name) == null) {
      return true;
    }
    return _preferences!.getBool(key.name) ?? false;
  }

  //GET & SET List<String> values
  Future<void> setStringList(PreferenceKeys key, List<String> value) async {
    await _preferences?.setStringList(key.name, value);
  }

  List<String> getStringList(PreferenceKeys key) =>
      _preferences?.getStringList(key.name) ?? [];
}
