import 'package:flutter/material.dart';
import '../../../core/local/local_storage.dart';

class AuthProvider with ChangeNotifier {
  bool _isLoggedIn = false;

  bool get isLoggedIn => _isLoggedIn;

  Future<void> login(String token) async {
    await LocalStorage().addStringToSP('token', token);
    _isLoggedIn = true;
    notifyListeners();
  }

  Future<void> logout() async {
    await LocalStorage().clearSharedPref('token');
    _isLoggedIn = false;
    notifyListeners();
  }

  Future<void> checkLoginStatus() async {
    String token = await LocalStorage().getStringFromSp('token');
    _isLoggedIn = token.isNotEmpty;
    notifyListeners();
  }
}
