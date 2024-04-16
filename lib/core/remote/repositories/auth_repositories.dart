import 'dart:developer';

import '../../model/login_model.dart';
import '../network_request.dart';

import '../base/auth_base.dart';

class AuthRepository extends BaseAuth {
  @override
  Future<LoginModel> login(
    String username,
    String password,
    String firstName,
    String lastName,
  ) async {
    String serverUrl =
        "https://office-new-dev.uniqcast.com:12611/api/client/v2/global/login";
    NetworkRequest networkRequest = NetworkRequest();

    try {
      var response = await networkRequest.getToken(
          serverUrl, username, password, firstName, lastName);
      return LoginModel.fromJson(
          response); // Assuming this will be handled if `_checkStatusCode` does not throw
    } catch (e) {
      log("Error during login: ${e.toString()}");
      rethrow; // Ensure errors are propagated up to be handled by UI logic
    }
  }
}
