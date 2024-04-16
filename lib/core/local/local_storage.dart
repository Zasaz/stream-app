import 'package:shared_preferences/shared_preferences.dart';

class LocalStorage {
  //  SAVE VALUES IN SHARED-PREFERENCES
  static late SharedPreferences prefs;
  static init() async {
    prefs = await SharedPreferences.getInstance();
  }

  addStringToSP(String keyName, String keyValue) async {
    prefs.setString(keyName, keyValue);
  }

  addIntToSP(String keyName, int keyValue) async {
    prefs.setInt(keyName, keyValue);
  }

  addBoolToSp(String keyName, bool keyValue) async {
    prefs.setBool(keyName, keyValue);
  }

  addDoubleToSp(String keyName, double keyValue) async {
    prefs.setDouble(keyName, keyValue);
  }

  //  GET VALUES FROM SHARED-PREFERENCES

  Future<String> getStringFromSp(String keyName) async {
    String stringValue = prefs.getString(keyName) ?? "";
    return stringValue;
  }

  getIntFromSp(String keyName) async {
    int? intValue = prefs.getInt(keyName);
    return intValue;
  }

  getBoolFromSp(String keyName) async {
    bool? boolValue = prefs.getBool(keyName);
    return boolValue;
  }

  getDoubleFromSp(String keyName) async {
    double? doubleValue = prefs.getDouble(keyName);
    return doubleValue;
  }

  clearSharedPref(String keyValue) async {
    prefs.remove(keyValue);
  }
}
