import 'dart:convert';
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

class ChannelRepository {
  Future<List<ChannelModel>> fetchChannelsByPackageId(String packageId) async {
    NetworkRequest networkRequest = NetworkRequest();
    var response =
        await networkRequest.getChannels(packageId); // Implement this method
    return _parseChannels(response);
  }

  List<ChannelModel> _parseChannels(String responseBody) {
    final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
    return parsed
        .map<ChannelModel>((json) => ChannelModel.fromJson(json))
        .toList();
  }
}
