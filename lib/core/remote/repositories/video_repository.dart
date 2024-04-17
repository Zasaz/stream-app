import 'dart:convert';

class VideoRepository {
  String getVideoUrlFromBase64(String base64String) {
    return utf8.decode(base64.decode(base64String));
  }
}
