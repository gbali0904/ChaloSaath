
// lib/core/storage/app_preference.dart
import 'package:shared_preferences/shared_preferences.dart';

import '../../services/service_locator.dart';
import 'app_key.dart';

class AppPreference {
  final SharedPreferences _prefs;

  AppPreference(this._prefs);

  /// Save boolean value
  Future<void> setBool(AppKey key, bool value) async {
    await _prefs.setBool(key.value, value);
  }

  /// Get boolean value
  bool getBool(AppKey key, {bool defaultValue = false}) {
    return _prefs.getBool(key.value) ?? defaultValue;
  }

  /// Save string value
  Future<void> setString(AppKey key, String value) async {
    await _prefs.setString(key.value, value);
  }

  /// Get string value
  String getString(AppKey key, {String defaultValue = ''}) {
    return _prefs.getString(key.value) ?? defaultValue;
  }

  /// Clear any key
  Future<void> clear(AppKey key) async {
    await _prefs.remove(key.value);
  }

  /// Clear all keys
  Future<void> clearAll() async {
    await _prefs.clear();
  }

  Future<void> clearAllExceptOnboardingSeen() async {
    final seen = getX<AppPreference>().getBool(AppKey.onboardingSeen);
    await _prefs.clear();
    await getX<AppPreference>().setBool(
      AppKey.onboardingSeen,
      seen,
    );

  }

}
