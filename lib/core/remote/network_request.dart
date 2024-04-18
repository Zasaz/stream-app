import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../local/local_storage.dart';
import '../../utils/constants/app_constants.dart';
import '../model/package_model.dart';

class SignInFailure implements Exception {
  final String message;
  SignInFailure({required this.message});

  @override
  String toString() => 'SignInFailure: $message';
}

class NetworkRequest {
  Future<dynamic> getToken(String url, String username, String password,
      String firstName, String lastName) async {
    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'username': username,
          'password': password,
          "login_type": "Credentials",
          "device": "flutter_test_device_${firstName}_$lastName"
        }),
      );
      debugPrint("Response Status: ${response.statusCode}");
      debugPrint("Response Body: ${response.body}");

      return _checkStatusCode(response);
    } catch (e) {
      debugPrint('Error sending request: ${e.toString()}');
      throw SignInFailure(message: 'Failed to connect to the server');
    }
  }

  //----------------------------------------------------------------
  //----------------------------------------------------------------

  Future<List<PackageModel>> getPackages() async {
    try {
      String token = await LocalStorage().getStringFromSp(AppConstants.token);
      String oid =
          await LocalStorage().getStringFromSp(AppConstants.operator_uid);
      String uid = await LocalStorage().getStringFromSp(AppConstants.userId);
      final Uri url = Uri.parse(
          "https://office-new-dev.uniqcast.com:12611/api/client/v1/$oid/users/$uid/packages?device_class=Mobile");
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        debugPrint("Response body: ${response.body}");
        List<dynamic> itemsJson = jsonDecode(response.body)['data'];
        return itemsJson.map((json) => PackageModel.fromJson(json)).toList();
      } else {
        debugPrint(
            "Failed with status: ${response.statusCode} and body: ${response.body}");
        throw Exception('Failed to load items');
      }
    } catch (e) {
      debugPrint("Exception caught: $e");
      throw Exception("Failed to fetch packages: $e");
    }
  }

  //----------------------------------------------------------------
  //----------------------------------------------------------------

  Future<Map<String, dynamic>> getChannels(String packageId) async {
    try {
      String token = await LocalStorage().getStringFromSp(AppConstants.token);
      String oid =
          await LocalStorage().getStringFromSp(AppConstants.operator_uid);
      final response = await http.get(
        Uri.parse(
            "https://office-new-dev.uniqcast.com:12611/api/client/v2/$oid/channels?packages=$packageId"),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );
      debugPrint("Response Status: ${response.statusCode}");
      debugPrint("Response Body: ${response.body}");

      if (response.statusCode == 200) {
        return jsonDecode(response
            .body); // This now correctly reflects the expected return type
      } else {
        debugPrint('Error fetching channels: ${response.statusCode}');
        throw Exception(
            "Error fetching channels: Status code ${response.statusCode}");
      }
    } catch (e) {
      debugPrint('Error sending request: ${e.toString()}');
      throw Exception(
          'Failed to fetch channels due to network error: ${e.toString()}');
    }
  }

  //----------------------------------------------------------------
  //----------------------------------------------------------------

  dynamic _checkStatusCode(http.Response response) {
    var decodedJson = jsonDecode(response
        .body); // Decode JSON first to handle both success and error uniformly.
    debugPrint("Decoded JSON: $decodedJson");

    if (response.statusCode == 200 && decodedJson['status'] == 'ok') {
      return _handleSuccessResponse(decodedJson);
    } else if (decodedJson['status'] == 'error') {
      throw SignInFailure(
          message: decodedJson['data']
              ['message']); // error based on API response
    } else {
      throw SignInFailure(
          message:
              "Unexpected error occurred with status code ${response.statusCode}: ${decodedJson['data']['message'] ?? 'No message available'}");
    }
  }

  dynamic _handleSuccessResponse(Map<String, dynamic> decodedJson) {
    try {
      return decodedJson;
    } catch (e) {
      debugPrint("Error handling success response: $e");
      rethrow; // Rethrow
    }
  }
}
