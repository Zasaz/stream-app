import 'dart:convert';
import 'dart:developer';
import 'package:tv_channels_app/core/model/channel_model.dart';
import 'package:tv_channels_app/core/remote/network_request.dart';

// class ChannelRepository {
//   Future<List<ChannelModel>> channels(String packageId) async {
//     NetworkRequest networkRequest = NetworkRequest();
//     var response = await networkRequest.getChannels(packageId);
//     return _parseChannels(response); // handling JSON decoding
//   }

//   List<ChannelModel> _parseChannels(String responseBody) {
//     final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
//     return parsed
//         .map<ChannelModel>((json) => ChannelModel.fromJson(json))
//         .toList();
//   }
// }

// class ChannelRepository {
//   Future<List<ChannelModel>> fetchChannelsByPackageId(String packageId) async {
//     NetworkRequest networkRequest = NetworkRequest();
//     var response =
//         await networkRequest.getChannels(packageId); // Implement this method
//     return _parseChannels(response);
//   }

//   List<ChannelModel> _parseChannels(String responseBody) {
//     final parsed = json.decode(responseBody)['data'] as List;
//     log("parsed: ${parsed.length}");
//     return parsed
//         .map<ChannelModel>(
//             (json) => ChannelModel.fromJson(json as Map<String, dynamic>))
//         .toList();
//   }
// }

class ChannelRepository {
  // Future<List<ChannelModel>> fetchChannelsByPackageId(String packageId) async {
  //   log("packageId in repository: $packageId");
  //   // NetworkRequest networkRequest = NetworkRequest();
  //   // String jsonResponse = await networkRequest.getChannels(packageId);
  //   // log("jsonResponse: $jsonResponse");
  //   // return _parseChannels(jsonResponse);

  //   NetworkRequest networkRequest = NetworkRequest();
  //   try {
  //     String jsonResponse = await networkRequest.getChannels(packageId);
  //     log("jsonResponse: $jsonResponse");
  //     return _parseChannels(jsonResponse);
  //   } catch (exception) {
  //     log("Failed to fetch channels: $exception");
  //     rethrow; // Re-throw to handle this failure appropriately upstream
  //   }
  // }

  // List<ChannelModel> _parseChannels(String responseBody) {
  //   final jsonData = json.decode(responseBody);
  //   final List<dynamic> channelsData = jsonData['data'];
  //   log("channelsData: $channelsData");
  //   return channelsData
  //       .map<ChannelModel>(
  //           (data) => ChannelModel.fromJson(data as Map<String, dynamic>))
  //       .toList();
  // }

  Future<List<ChannelModel>> fetchChannelsByPackageId(String packageId) async {
    log("packageId in repository: $packageId");
    NetworkRequest networkRequest = NetworkRequest();
    Map<String, dynamic> jsonResponse =
        await networkRequest.getChannels(packageId);
    log("jsonResponse: $jsonResponse");
    return _parseChannels(jsonResponse); // Pass the Map directly
  }

  List<ChannelModel> _parseChannels(Map<String, dynamic> jsonData) {
    final List<dynamic> channelsData = jsonData['data'];
    log("channelsData: $channelsData");
    return channelsData
        .map<ChannelModel>(
            (data) => ChannelModel.fromJson(data as Map<String, dynamic>))
        .toList();
  }
}
