// import 'dart:convert';
// import 'package:tv_channels_app/core/model/channel_model.dart';
// import 'package:tv_channels_app/core/model/package_model.dart';
// import 'package:tv_channels_app/core/remote/network_request.dart';

// class PackageRepository {
//   Future<List<PackageModel>> fetchPackages() async {
//     NetworkRequest networkRequest = NetworkRequest();
//     var response = await networkRequest.getPackages();
//     if (response.statusCode == 200) {
//       return parsePackages(response.body);
//     } else {
//       throw Exception("Failed to fetch packages: ${response.statusCode}");
//     }
//   }

//   List<PackageModel> parsePackages(String responseBody) {
//     final parsed = jsonDecode(responseBody);
//     if (parsed['data'] != null) {
//       return (parsed['data'] as List)
//           .map<PackageModel>((json) => PackageModel.fromJson(json))
//           .toList();
//     } else {
//       throw Exception("Data field is missing or not a list");
//     }
//   }
// }

import 'dart:convert';
import 'package:tv_channels_app/core/model/package_model.dart';
import 'package:tv_channels_app/core/remote/network_request.dart';

class PackageRepository {
  final NetworkRequest _networkRequest = NetworkRequest();

  Future<List<PackageModel>> fetchPackages() async {
    try {
      String jsonResponse = await _networkRequest.getPackages();
      final List<dynamic> dataList = jsonDecode(jsonResponse)['data'];
      return dataList
          .map<PackageModel>(
              (json) => PackageModel.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw Exception("Failed to fetch packages: $e");
    }
  }
}
