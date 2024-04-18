import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

showToast(Color color, String msg) {
  Fluttertoast.showToast(
      msg: msg,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 3,
      backgroundColor: color,
      textColor: Colors.white,
      fontSize: 14.0);
}

String streamUrl =
    "aHR0cHM6Ly9kZW1vLnVuaWZpZWQtc3RyZWFtaW5nLmNvbS9rOHMvZmVhdHVyZXMvc3RhYmxlL3ZpZGVvL3RlYXJzLW9mLXN0ZWVsL3RlYXJzLW9mLXN0ZWVsLmlzbS8ubTN1OA==";

int getCurrentTimestamp() => DateTime.now().millisecondsSinceEpoch;

// Utility function to decode base64
String decodeBase64(String base64String) {
  return utf8.decode(base64.decode(base64String));
}

String prettyJson(jsonObject) {
  var encoder = const JsonEncoder.withIndent("     ");
  return encoder.convert(jsonObject);
}

String decodeStreamUrl(String base64Url) {
  return utf8.decode(base64.decode(base64Url));
}
