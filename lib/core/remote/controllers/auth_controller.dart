import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../local/local_storage.dart';
import '../../../utils/constants/app_constants.dart';
import '../../failure/failure.dart';
import '../repositories/auth_repositories.dart';

import '../../model/login_model.dart';

final authControllerNotifier = ChangeNotifierProvider<AuthController>(
  (ref) => AuthController(
    authRepository: AuthRepository(),
  ),
);

class AuthController extends ChangeNotifier {
  final AuthRepository _authRepository;
  bool isLoading = false;
  String message = "";
  String? statusCode;
  LoginModel? _loginModel;

  AuthController({required AuthRepository authRepository})
      : _authRepository = authRepository;

  Future<void> login(String username, String password, String firstName,
      String lastName) async {
    isLoading = true;
    message = ""; // Clear previous messages
    notifyListeners();

    try {
      _loginModel =
          await _authRepository.login(username, password, firstName, lastName);
      debugPrint("_loginModel: $_loginModel");
      if (_loginModel != null) {
        message = "Login successful";

        int expiresInMs = int.tryParse(_loginModel!.data!.expiresIn ?? "0") ??
            0; // Assuming expiresIn is in seconds
        int expiryTimestamp =
            DateTime.now().millisecondsSinceEpoch + expiresInMs * 1000;

        await LocalStorage().addStringToSP(
            AppConstants.token, _loginModel!.data!.accessToken ?? "");
        await LocalStorage().addStringToSP(
            AppConstants.operator_uid, _loginModel!.data!.operatorUid ?? "");
        await LocalStorage().addStringToSP(
            AppConstants.userId, _loginModel!.data!.userId.toString());
        await LocalStorage().addStringToSP(AppConstants.tokenExpiry,
            expiryTimestamp.toString()); // Store expiry as timestamp

        statusCode = "200";
      } else {
        message = "Login failed, no user data received";
        statusCode = "400";
      }
    } on SignInFailure catch (e) {
      message = e.message;
      statusCode = "401";
    } catch (e) {
      message = "An error occurred: ${e.toString()}";
      statusCode = "500";
    }

    isLoading = false;
    notifyListeners();
  }
}
