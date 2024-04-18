import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../model/channel_model.dart';
import '../repositories/channel_repository.dart';

final channelControllerNotifier = ChangeNotifierProvider<ChannelController>(
  (ref) => ChannelController(
    channelRepository: ChannelRepository(),
  ),
);

class ChannelController extends ChangeNotifier {
  final ChannelRepository _channelRepository;
  bool isLoading = false;
  String message = "";
  String? statusCode;
  List<ChannelModel>? _channels = [];
  ChannelModel? selectedChannel;
  bool viewingChannels = false; // To control UI state

  ChannelController({required ChannelRepository channelRepository})
      : _channelRepository = channelRepository;

  List<ChannelModel>? get channels => _channels;

  Future<void> fetchChannelsByPackageId(String packageId) async {
    debugPrint("channelstttt: $channels");
    debugPrint("channels: $_channels");
    isLoading = true;
    notifyListeners();
    try {
      _channels = await _channelRepository.fetchChannelsByPackageId(packageId);
      print("Fetched channels: ${_channels!.length}");
      if (_channels!.isNotEmpty) {
        message = "Channels fetched successfully.";
        statusCode = "200";
      } else {
        message = "No channels available";
        statusCode = "400";
      }
    } catch (e) {
      message = "An error occurred: $e";
      statusCode = "500";
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
