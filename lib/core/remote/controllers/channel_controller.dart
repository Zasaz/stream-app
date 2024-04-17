import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tv_channels_app/core/failure/failure.dart';
import 'package:tv_channels_app/core/model/channel_model.dart';
import 'package:tv_channels_app/core/remote/repositories/channel_repository.dart';

final channelControllerNotifier = ChangeNotifierProvider<ChannelController>(
  (ref) => ChannelController(
    channelRepository: ChannelRepository(),
  ),
);

// class ChannelController extends ChangeNotifier {
//   final ChannelRepository _channelRepository;
//   bool isLoading = false;
//   String message = "";
//   String? statusCode;
//   List<ChannelModel>? _channels; //  handle a list of ChannelModel

//   ChannelController({required ChannelRepository channelRepository})
//       : _channelRepository = channelRepository;

//   Future<void> fetchChannels() async {
//     isLoading = true;
//     message = ""; // Clear previous messages
//     notifyListeners();

//     try {
//       _channels = await _channelRepository.channels(); // Updated to handle list
//       if (_channels != null && _channels!.isNotEmpty) {
//         message = "Channels fetched successfully.";
//         statusCode = "200";
//       } else {
//         message = "No channels available";
//         statusCode = "400";
//       }
//     } on SignInFailure catch (e) {
//       message = e.message;
//       statusCode = "401";
//     } catch (e) {
//       message = "An error occurred: ${e.toString()}";
//       statusCode = "500";
//     }

//     isLoading = false;
//     notifyListeners();
//   }

//   // Getter to access channels outside of this class
//   List<ChannelModel>? get channels => _channels;
// }

// class ChannelController extends ChangeNotifier {
//   final ChannelRepository _channelRepository;
//   bool isLoading = false;
//   String message = "";
//   String? statusCode;
//   List<ChannelModel>? _channels;

//   ChannelController({required ChannelRepository channelRepository})
//       : _channelRepository = channelRepository;

//   List<ChannelModel>? get channels => _channels;

//   Future<void> fetchChannelsByPackageId(String packageId) async {
//     isLoading = true;
//     notifyListeners();

//     try {
//       _channels = await _channelRepository.fetchChannelsByPackageId(packageId);
//       if (_channels != null && _channels!.isNotEmpty) {
//         message = "Channels fetched successfully.";
//         statusCode = "200";
//       } else {
//         message = "No channels available";
//         statusCode = "400";
//       }
//     } catch (e) {
//       message = "An error occurred: ${e.toString()}";
//       statusCode = "500";
//     }

//     isLoading = false;
//     notifyListeners();
//   }
// }

class ChannelController extends ChangeNotifier {
  final ChannelRepository _channelRepository;
  bool isLoading = false;
  String message = "";
  String? statusCode;
  List<ChannelModel>? _channels;
  ChannelModel? selectedChannel;
  bool viewingChannels = false; // To control UI state

  ChannelController({required ChannelRepository channelRepository})
      : _channelRepository = channelRepository;

  List<ChannelModel>? get channels => _channels;

  Future<void> fetchChannelsByPackageId(String packageId) async {
    isLoading = true;
    notifyListeners();
    try {
      _channels = await _channelRepository.fetchChannelsByPackageId(packageId);
      if (_channels != null) {
        viewingChannels = true; // Update state to show channels
        message = "Channels fetched successfully.";
        statusCode = "200";
      } else {
        message = "No channels available";
        statusCode = "400";
      }
    } catch (e) {
      message = "An error occurred: ${e.toString()}";
      statusCode = "500";
    }
    isLoading = false;
    notifyListeners();
  }

  void selectChannel(ChannelModel channel) {
    selectedChannel = channel;
    notifyListeners();
  }

  void goBackToPackages() {
    viewingChannels = false;
    selectedChannel = null;
    notifyListeners();
  }
}
