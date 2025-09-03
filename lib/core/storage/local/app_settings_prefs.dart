import 'package:shared_preferences/shared_preferences.dart';
import '../../../constants/shared_prefs_constants/shared_prefs_constants.dart';
import '../../extensions/extensions.dart';

/// A class defined for saving and retrieving data from SharedPreferences.
class AppSettingsPrefs {
  final SharedPreferences _sharedPreferences;

  AppSettingsPrefs(this._sharedPreferences);

  /// Clear all shared prefs
  void clear() {
    _sharedPreferences.clear();
  }

  // ---------------------------
  // 🟢 SETTERS
  // ---------------------------

  Future<void> setString({required String key, required String value}) async {
    await _sharedPreferences.setString(key, value);
  }

  Future<void> setBool({required String key, required bool value}) async {
    await _sharedPreferences.setBool(key, value);
  }

  Future<void> setDouble({required String key, required double value}) async {
    await _sharedPreferences.setDouble(key, value);
  }

  Future<void> setInt({required String key, required int value}) async {
    await _sharedPreferences.setInt(key, value);
  }


  Future<String?> getString({required String key}) async {
    return _sharedPreferences.getString(key);
  }

  /// Set app locale
  Future<void> setLocale({required String locale}) async {
    await _sharedPreferences.setString(
      SharedPrefsConstants.locale,
      locale,
    );
  }

  /// Set if onboarding viewed
  Future<void> setOutBoardingScreenViewed() async {
    await _sharedPreferences.setBool(
      SharedPrefsConstants.outBoardingViewed,
      true,
    );
  }

  /// Set if user logged in
  Future<void> setUserLoggedIn() async {
    await _sharedPreferences.setBool(
      SharedPrefsConstants.isLoggedIn,
      true,
    );
  }

  /// Set user token
  Future<void> setToken({required String token}) async {
    await _sharedPreferences.setString(
      SharedPrefsConstants.token,
      token,
    );
  }

  // ---------------------------
  // 🟡 GETTERS
  // ---------------------------



  Future<bool?> getBool({required String key}) async {
    return _sharedPreferences.getBool(key);
  }

  Future<double?> getDouble({required String key}) async {
    return _sharedPreferences.getDouble(key);
  }

  Future<int?> getInt({required String key}) async {
    return _sharedPreferences.getInt(key);
  }

  /// Get app locale
  String getLocale() {
    return _sharedPreferences
        .getString(SharedPrefsConstants.locale)
        .pareWithDefaultLocale();
  }

  /// Check if onboarding viewed
  bool getOutBoardingScreenViewed() {
    return _sharedPreferences
        .getBool(SharedPrefsConstants.outBoardingViewed)
        .onNull();
  }

  /// Check if user logged in
  bool getUserLoggedIn() {
    return _sharedPreferences
        .getBool(SharedPrefsConstants.isLoggedIn)
        .onNull();
  }

  /// Get user token
  String getToken() {
    return _sharedPreferences
        .getString(SharedPrefsConstants.token)
        .onNull();
  }
}
