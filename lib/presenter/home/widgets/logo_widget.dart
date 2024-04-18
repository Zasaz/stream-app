import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'package:http/http.dart' as http;

Future<bool> checkImageExists(String imageUrl) async {
  try {
    final response =
        await http.get(Uri.parse(imageUrl), headers: {'Range': 'bytes=0-0'});
    return response.statusCode == 200;
  } catch (_) {
    return false;
  }
}

class ChannelLogoWidget extends StatefulWidget {
  final int channelId;

  const ChannelLogoWidget({Key? key, required this.channelId})
      : super(key: key);

  @override
  _ChannelLogoWidgetState createState() => _ChannelLogoWidgetState();
}

class _ChannelLogoWidgetState extends State<ChannelLogoWidget> {
  late Future<bool> _imageExists;

  @override
  void initState() {
    super.initState();
    String imageUrl =
        "https://office-new-dev.uniqcast.com:12802/api/client/v1/global/images/${widget.channelId}?accessKey=WkVjNWNscFhORDBLCg==";
    _imageExists = checkImageExists(imageUrl);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: _imageExists,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.data == true) {
            return CachedNetworkImage(
              imageUrl:
                  "https://office-new-dev.uniqcast.com:12802/api/client/v1/global/images/${widget.channelId}?accessKey=WkVjNWNscFhORDBLCg==",
              width: MediaQuery.of(context).size.width,
              height: 100,
              cacheKey:
                  "new_test_key_${widget.channelId}", // Change key to bypass cache
              fit: BoxFit.fitWidth,
              placeholder: (context, url) =>
                  const Center(child: CircularProgressIndicator()),
              errorWidget: (context, url, error) => const Icon(Icons.error),
            );
          } else {
            return Container(
              width: MediaQuery.of(context).size.width,
              height: 100,
              color: Colors.grey[300],
              child: const Icon(Icons.broken_image, color: Colors.grey),
            );
          }
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}
