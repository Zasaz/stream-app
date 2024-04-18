import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tv_channels_app/core/local/local_storage.dart';
import 'package:tv_channels_app/presenter/auth/name_view.dart';
import 'package:tv_channels_app/presenter/home/package_view.dart';
import 'package:tv_channels_app/utils/constants/app_constants.dart';
import 'package:tv_channels_app/utils/utils.dart';

class SplashView extends ConsumerStatefulWidget {
  const SplashView({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SplashViewState();
}

class _SplashViewState extends ConsumerState<SplashView> {
  void navigateAfter3Seconds() async {
    await LocalStorage.init(); // Assuming an init method if needed
    await Future.delayed(const Duration(seconds: 1));

    String token = await LocalStorage().getStringFromSp(AppConstants.token);
    String oid =
        await LocalStorage().getStringFromSp(AppConstants.operator_uid);
    String uid = await LocalStorage().getStringFromSp(AppConstants.userId);
    if (kDebugMode) {
      log("Token: $token");
      log("oid: $oid");
      log("uid: $uid");
    }

    // Ensure navigation code runs only if the widget is still mounted
    if (!mounted) return;

    if (token.isEmpty) {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => const NameView()));
    } else {
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (context) => const PackageView()));
    }
  }

  @override
  void initState() {
    super.initState();
    navigateAfter3Seconds();
    // String encodedUrl =
    //     "aHR0cHM6Ly9kZW1vLnVuaWZpZWQtc3RyZWFtaW5nLmNvbS9rOHMvZmVhdHVyZXMvc3RhYmxlL3ZpZGVvL3RlYXJzLW9mLXN0ZWVsL3RlYXJzLW9mLXN0ZWVsLmlzbS8ubTN1OA==";
    // String decodedUrl = decodeStreamUrl(encodedUrl);
    // log("Decoded URL: $decodedUrl");
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text(
          'StreamApp',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 34,
          ),
        ),
      ),
    );
  }
}
