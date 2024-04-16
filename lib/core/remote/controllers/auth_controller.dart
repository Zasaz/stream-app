import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tv_channels_app/core/local/local_storage.dart';
import 'package:tv_channels_app/utils/constants/app_constants.dart';
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
      log("_loginModel: $_loginModel");
      if (_loginModel != null) {
        message = "Login successful";
        await LocalStorage().addStringToSP(
            AppConstants.token, _loginModel!.data!.accessToken.toString());
        await LocalStorage().addStringToSP(AppConstants.operator_uid,
            _loginModel!.data!.operatorUid.toString());
        await LocalStorage().addStringToSP(
            AppConstants.userId, _loginModel!.data!.userId.toString());
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
