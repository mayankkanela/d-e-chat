import 'dart:async';

import 'package:shared_preferences/shared_preferences.dart';

export 'package:shared_preferences/shared_preferences.dart';

class Prefs {
  static Future<SharedPreferences>? _prefs = SharedPreferences.getInstance();
  static SharedPreferences? _prefInstance;

  static bool _isInit = false;

  static void init() async {
    _isInit = true;
    _prefInstance = await _prefs;
  }

  static void dispose() {
    _prefs = null;
    _prefInstance = null;
  }

  static bool isInit() {
    return (_isInit == true) ? true : false;
  }

  static Future<bool?> containsKeyF(String key) async {
    bool? contains;
    if (_prefInstance == null) {
      var prefs = await _prefs;
      contains = prefs?.containsKey(key);
    } else {
      contains = _prefInstance?.containsKey(key);
    }
    return contains;
  }

  static dynamic get(String key) {
    assert(_isInit, "Prefs.init() must be called");
    assert(_prefInstance != null,
        "call Prefs.getF(key) instead. SharedPreferences not ready yet!");
    return _prefInstance?.get(key);
  }

  static Future<dynamic> getF(String key) async {
    dynamic value;
    if (_prefInstance == null) {
      var prefs = await _prefs;
      value = prefs?.get(key);
    } else {
      value = get(key);
    }
    print(value);
    return value;
  }

  static Future<bool> setStringF(String key, String value) async {
    var prefs = await _prefs;
    return prefs?.setString(key, value) ?? Future.value(false);
  }
}
