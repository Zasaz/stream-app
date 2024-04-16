import 'dart:convert';
import 'package:tv_channels_app/core/model/channel_model.dart';
import 'package:tv_channels_app/core/remote/network_request.dart';

class ChannelRepository {
  Future<List<ChannelModel>> channels() async {
    NetworkRequest networkRequest = NetworkRequest();
    var response = await networkRequest.getChannels();
    return _parseChannels(response); // handling JSON decoding
  }

  List<ChannelModel> _parseChannels(String responseBody) {
    final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
    return parsed
        .map<ChannelModel>((json) => ChannelModel.fromJson(json))
        .toList();
  }
}
