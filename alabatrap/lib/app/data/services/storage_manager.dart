import 'package:alabatrap/app/core/util/extensions/optional_x.dart';
import 'package:flutter/foundation.dart';
import 'package:rx_shared_preferences/rx_shared_preferences.dart';

class _Keys {
  static const String lang = 'language';
}

class Storage {
  static late final SharedPreferences _prefs;
  static late final RxSharedPreferences _rxPrefs;

  static void _remove(String key) => _prefs.remove(key);
  static T? _get<T>(String key) => _prefs.get(key)?.asOrNull<T>();
  static Future<void> _set<T>(String key, T? val, {bool notify = false}) {
    if (val is bool) {
      return notify ? _rxPrefs.setBool(key, val) : _prefs.setBool(key, val);
    }
    if (val is double) {
      return notify ? _rxPrefs.setDouble(key, val) : _prefs.setDouble(key, val);
    }
    if (val is int) {
      return notify ? _rxPrefs.setInt(key, val) : _prefs.setInt(key, val);
    }
    if (val is String) {
      return notify ? _rxPrefs.setString(key, val) : _prefs.setString(key, val);
    }
    if (val is List<String>) {
      return notify
          ? _rxPrefs.setStringList(key, val)
          : _prefs.setStringList(key, val);
    }
    throw Exception('Type not supported!');
  }

  static void remove(String key) => _remove(key);

  static T? get<T>(String key) => _get(key);

  static Future<void> set<T>(String key, T? val, {bool notify = false}) {
    return _set(key, val, notify: notify);
  }

  static setup() async {
    _prefs = await SharedPreferences.getInstance();
    _rxPrefs = RxSharedPreferences(
      _prefs,
      // disable logging when running in release mode.
      kReleaseMode ? null : const RxSharedPreferencesDefaultLogger(),
    );
  }

  static String? get lang => _get(_Keys.lang);

  static Future setLang(String? val) => _set(_Keys.lang, val);
}
