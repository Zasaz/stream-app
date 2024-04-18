import 'package:flutter/material.dart';

import '../../model/channel_model.dart';
import '../network_request.dart';

class ChannelRepository {
  Future<List<ChannelModel>> fetchChannelsByPackageId(String packageId) async {
    debugPrint("packageId in repository: $packageId");
    NetworkRequest networkRequest = NetworkRequest();
    Map<String, dynamic> jsonResponse =
        await networkRequest.getChannels(packageId);
    debugPrint("jsonResponse: $jsonResponse");
    return _parseChannels(jsonResponse); // Pass the Map directly
  }

  List<ChannelModel> _parseChannels(Map<String, dynamic> jsonData) {
    final List<dynamic> channelsData = jsonData['data'];
    debugPrint("channelsData: $channelsData");
    return channelsData
        .map<ChannelModel>(
            (data) => ChannelModel.fromJson(data as Map<String, dynamic>))
        .toList();
  }
}
