import 'dart:convert';

import 'package:better_player/better_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tv_channels_app/presenter/home/widgets/logo_widget.dart';
import '../../core/remote/controllers/channel_controller.dart';
import '../../utils/utils.dart';

class ChannelsView extends ConsumerStatefulWidget {
  final String packageId;
  const ChannelsView({Key? key, required this.packageId}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ChannelsViewState();
}

class _ChannelsViewState extends ConsumerState<ChannelsView> {
  BetterPlayerController? _betterPlayerController;
  String? selectedChannelUrl;
  bool showVideoPlayer = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        ref
            .read(channelControllerNotifier)
            .fetchChannelsByPackageId(widget.packageId);
      }
    });
  }

  void playChannel(String base64Url) {
    String url = decodeBase64(base64Url);

    if (_betterPlayerController != null) {
      _betterPlayerController!
          .dispose(); // Dispose the current player if exists
    }

    // Setup a new video player controller for the decoded URL
    BetterPlayerDataSource dataSource = BetterPlayerDataSource(
      BetterPlayerDataSourceType.network,
      url,
    );

    _betterPlayerController = BetterPlayerController(
      const BetterPlayerConfiguration(
        aspectRatio: 16 / 9,
        autoPlay: true,
      ),
      betterPlayerDataSource: dataSource,
    );

    setState(() {
      selectedChannelUrl = url;
      showVideoPlayer = true;
    });
  }

  String decodeBase64(String base64String) {
    return utf8.decode(base64.decode(base64String));
  }

  @override
  void dispose() {
    _betterPlayerController?.dispose(); // Ensure the controller is disposed
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final channelController = ref.watch(channelControllerNotifier);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Channels'),
      ),
      body: channelController.isLoading
          ? const Center(child: CircularProgressIndicator())
          : channelController.channels!.isEmpty
              ? const Center(child: Text("No channels available"))
              : Column(
                  children: [
                    if (showVideoPlayer && selectedChannelUrl != null)
                      Expanded(
                        flex: 1, // Size ratio for video player
                        child:
                            BetterPlayer(controller: _betterPlayerController!),
                      ),
                    Expanded(
                      flex: 2,
                      child: GridView.builder(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2, // Two items per row
                          childAspectRatio: (MediaQuery.of(context).size.width /
                                  2) /
                              150, // Ratio based on screen width and desired height
                          crossAxisSpacing: 2, // Horizontal space between items
                          mainAxisSpacing: 2, // Vertical space between items
                        ),
                        itemCount: channelController.channels?.length,
                        itemBuilder: (context, index) {
                          final channel = channelController.channels?[index];
                          return GestureDetector(
                            onTap: () => playChannel(
                                streamUrl), // Use the class-level base64 URL for decoding and playing
                            child: Card(
                              elevation: 1.5,
                              shape: const RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(8)),
                              ),
                              clipBehavior: Clip.antiAlias,
                              child: Column(
                                children: <Widget>[
                                  Expanded(
                                    child: ChannelLogoWidget(
                                      channelId: channel!.id,
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.all(8.0),
                                    color: Colors.black.withOpacity(
                                        0.5), // Semi-transparent overlay for better text visibility
                                    width: double.infinity,
                                    child: Center(
                                      child: Text(
                                        channel.name,
                                        style: const TextStyle(
                                            fontSize: 16, color: Colors.white),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                        physics: const AlwaysScrollableScrollPhysics(
                          parent: BouncingScrollPhysics(),
                        ),
                        padding: const EdgeInsets.all(5),
                      ),
                    ),
                  ],
                ),
    );
  }
}
