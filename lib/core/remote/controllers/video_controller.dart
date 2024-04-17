import 'package:better_player/better_player.dart';
import 'package:flutter/material.dart';
import 'package:tv_channels_app/core/remote/repositories/video_repository.dart';

class VideoController extends ChangeNotifier {
  final VideoRepository _videoRepository;
  BetterPlayerController? playerController;

  VideoController(this._videoRepository);

  void setupVideoPlayer(String base64String) {
    String videoUrl = _videoRepository.getVideoUrlFromBase64(base64String);
    BetterPlayerDataSource dataSource = BetterPlayerDataSource(
      BetterPlayerDataSourceType.network,
      videoUrl,
      liveStream: true,
    );
    playerController = BetterPlayerController(
      const BetterPlayerConfiguration(
        autoPlay: true,
        looping: false,
        fullScreenByDefault: false,
        aspectRatio: 16 / 9,
      ),
      betterPlayerDataSource: dataSource,
    );
    notifyListeners();
  }

  void disposePlayer() {
    playerController?.dispose();
    playerController = null;
    notifyListeners();
  }

  @override
  void dispose() {
    super.dispose();
    disposePlayer();
  }
}
