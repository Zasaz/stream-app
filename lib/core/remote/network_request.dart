import 'dart:convert';
import 'dart:developer';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:tv_channels_app/core/local/local_storage.dart';
import 'package:tv_channels_app/utils/constants/app_constants.dart';
import 'package:tv_channels_app/core/model/package_model.dart';

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

  // Future<dynamic> getPackages() async {
  //   try {
  //     String token = await LocalStorage().getStringFromSp(AppConstants.token);
  //     String oid =
  //         await LocalStorage().getStringFromSp(AppConstants.operator_uid);
  //     String uid = await LocalStorage().getStringFromSp(AppConstants.userId);
  //     log("Tokenwieljksdamn: $token");
  //     log("uidwieljksdamn: $uid");
  //     log("oidwieljksdamn: $oid");
  //     final response = await http.get(
  //       Uri.parse(
  //           "https://office-new-dev.uniqcast.com:12611/api/client/v1/$oid/users/$uid/packages?device_class=Mobile"),
  //       headers: {
  //         'Content-Type': 'application/json',
  //         'Authorization': 'Bearer $token',
  //       },
  //     );
  //     debugPrint(
  //         "Full URL: https://office-new-dev.uniqcast.com:12611/api/client/v1/$oid/users/$uid/packages?device_class=Mobile");
  //     debugPrint("Package Response Status: ${response.statusCode}");
  //     debugPrint("Package Response Headers: ${response.headers}");
  //     log("Package Response Body: ${response.body}");

  //     // debugPrint("Package Response Status: ${response.statusCode}");
  //     // log("Package Response Body: ${response.body}");

  //     // Checking the status code directly inside the function
  //     if (response.statusCode == 200) {
  //       return jsonDecode(
  //           response.body); // Parse the JSON only if the status code is OK
  //     } else if (response.statusCode == 401) {
  //       // Handle unauthorized access
  //       debugPrint('Unauthorized: Token may be expired or invalid');
  //       throw Exception("Unauthorized: Token may be expired or invalid");
  //     } else {
  //       // Handle other errors
  //       debugPrint('Error fetching channels: ${response.statusCode}');
  //       throw Exception(
  //           "Error fetching channels: Status code ${response.statusCode}");
  //     }
  //   } catch (e) {
  //     debugPrint('Error sending request: ${e.toString()}');
  //     throw Exception(
  //         'Failed to fetch channels due to network error: ${e.toString()}');
  //   }
  // }

  // Future<String> getPackages() async {
  //   try {
  //     String token = await LocalStorage().getStringFromSp(AppConstants.token);
  //     String oid =
  //         await LocalStorage().getStringFromSp(AppConstants.operator_uid);
  //     String uid = await LocalStorage().getStringFromSp(AppConstants.userId);

  //     final Uri url = Uri.parse(
  //         "https://office-new-dev.uniqcast.com:12611/api/client/v1/$oid/users/$uid/packages");
  //     final response = await http.get(
  //       url,
  //       headers: {
  //         'Content-Type': 'application/json',
  //         'Authorization': 'Bearer $token',
  //       },
  //     );

  //     if (response.statusCode == 200) {
  //       return response.body; // This ensures a string is returned
  //     } else {
  //       throw Exception(
  //           'Failed to load packages with status code: ${response.statusCode}');
  //     }
  //   } catch (e) {
  //     throw Exception('Network error when fetching packages: $e');
  //   }
  // }

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
        log("Response body: ${response.body}");
        List<dynamic> itemsJson = jsonDecode(response.body)['data'];
        return itemsJson.map((json) => PackageModel.fromJson(json)).toList();
      } else {
        log("Failed with status: ${response.statusCode} and body: ${response.body}");
        throw Exception('Failed to load items');
      }
    } catch (e) {
      log("Exception caught: $e");
      throw Exception("Failed to fetch packages: $e");
    }
  }

  //----------------------------------------------------------------
  //----------------------------------------------------------------

  // Future<dynamic> getChannels(String packageId) async {
  //   try {
  //     // String token =
  //     //     "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJleHAiOjE3MTMzNzQxMzksImlhdCI6MTcxMzM3MjMzOSwiaXNzIjoidW5pcUNhc3QiLCJzdWIiOiJhY2Nlc3MiLCJkaWQiOjE4MDg5LCJkdWlkIjoiZmx1dHRlcl90ZXN0X2RldmljZV8ke3VtYWlyfV8ke2FobWVkfSIsIm9pZCI6MTI4LCJvdWlkIjoiamVya29fbWFqY2VuIiwicmlkIjoxMjgsInJvbGUiOlsic3Vic2NyaWJlciJdLCJydWlkIjoiZGVmYXVsdCIsInVpZCI6NjMxMiwidmVyc2lvbiI6Mn0.q2Ccf6f7aFBnqb9r2kCbNqpr7s4jcK7olQlBz8-nHUQ";

  //     String token = await LocalStorage().getStringFromSp(AppConstants.token);
  //     String oid =
  //         await LocalStorage().getStringFromSp(AppConstants.operator_uid);
  //     if (kDebugMode) {
  //       log("Token: $token");
  //     }
  //     final response = await http.get(
  //       Uri.parse(
  //           "https://office-new-dev.uniqcast.com:12611/api/client/v2/$oid/channels?packages=$packageId"),
  //       headers: {
  //         'Content-Type': 'application/json',
  //         'Authorization': 'Bearer $token',
  //       },
  //     );
  //     debugPrint("Response Status: ${response.statusCode}");
  //     debugPrint("Response Body: ${response.body}");

  //     // Checking the status code directly inside the function
  //     if (response.statusCode == 200) {
  //       return jsonDecode(
  //           response.body); // Parse the JSON only if the status code is OK
  //     } else if (response.statusCode == 401) {
  //       // Handle unauthorized access
  //       debugPrint('Unauthorized: Token may be expired or invalid');
  //       throw Exception("Unauthorized: Token may be expired or invalid");
  //     } else {
  //       // Handle other errors
  //       debugPrint('Error fetching channels: ${response.statusCode}');
  //       throw Exception(
  //           "Error fetching channels: Status code ${response.statusCode}");
  //     }
  //   } catch (e) {
  //     debugPrint('Error sending request: ${e.toString()}');
  //     throw Exception(
  //         'Failed to fetch channels due to network error: ${e.toString()}');
  //   }
  // }

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
        log('Error fetching channels: ${response.statusCode}');
        throw Exception(
            "Error fetching channels: Status code ${response.statusCode}");
      }
    } catch (e) {
      log('Error sending request: ${e.toString()}');
      throw Exception(
          'Failed to fetch channels due to network error: ${e.toString()}');
    }
  }

  dynamic _checkStatusCode(http.Response response) {
    var decodedJson = jsonDecode(response
        .body); // Decode JSON first to handle both success and error uniformly.
    debugPrint("Decoded JSON: $decodedJson");

    if (response.statusCode == 200 && decodedJson['status'] == 'ok') {
      return _handleSuccessResponse(decodedJson);
    } else if (decodedJson['status'] == 'error') {
      throw SignInFailure(
          message: decodedJson['data']
              ['message']); // Custom error based on API response
    } else {
      throw SignInFailure(
          message:
              "Unexpected error occurred with status code ${response.statusCode}: ${decodedJson['data']['message'] ?? 'No message available'}");
    }
  }

  dynamic _handleSuccessResponse(Map<String, dynamic> decodedJson) {
    try {
      // Construct and return a meaningful object or simply pass through the JSON.
      return decodedJson; // Or a more structured data handling
    } catch (e) {
      debugPrint("Error handling success response: $e");
      rethrow; // Rethrow or handle appropriately
    }
  }

  // dynamic _handleBadRequest(Map<String, dynamic> decodedJson) {
  //   var error = decodedJson["error"];
  //   var desc = decodedJson["error_description"];
  //   throw SignInFailure(message: desc ?? error ?? "Bad request");
  // }
}
