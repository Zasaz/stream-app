import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tv_channels_app/core/failure/failure.dart';
import 'package:tv_channels_app/core/model/channel_model.dart';
import 'package:tv_channels_app/core/model/package_model.dart';
import 'package:tv_channels_app/core/remote/repositories/channel_repository.dart';
import 'package:tv_channels_app/core/remote/repositories/package_repository.dart';

final packageControllerNotifier = ChangeNotifierProvider<PackageController>(
  (ref) => PackageController(
    packageRepository: PackageRepository(),
  ),
);

class PackageController extends ChangeNotifier {
  final PackageRepository _packageRepository;
  bool isLoading = false;
  String message = "";
  String? statusCode;
  List<PackageModel>? _packages; //  handle a list of packageModel instances

  PackageController({required PackageRepository packageRepository})
      : _packageRepository = packageRepository;

  Future<void> fetchPackages() async {
    isLoading = true;
    message = ""; // Clear previous messages
    notifyListeners();

    try {
      _packages =
          await _packageRepository.fetchPackages(); // Updated to handle list
      debugPrint("Packages loaded: ${_packages?.length}");

      if (_packages != null && _packages!.isNotEmpty) {
        message = "Packages fetched successfully.";
        statusCode = "200";
      } else {
        message = "No Packages available";
        statusCode = "400";
      }
    } on SignInFailure catch (e) {
      message = e.message;
      statusCode = "401";
    } catch (e) {
      message = "An error occurred: ${e.toString()}";
      statusCode = "500";
    }

    isLoading = false;
    notifyListeners();
  }

  // Getter to access channels outside of this class
  List<PackageModel>? get packages => _packages;
}

// class PackageController extends ChangeNotifier {
//   final PackageRepository _packageRepository;
//   bool isLoading = false;
//   List<PackageModel>? packages;
//   String? errorMessage;

//   // PackageController(this._packageRepository);
//   PackageController({required PackageRepository packageRepository})
//       : _packageRepository = packageRepository;

//   Future<void> loadPackages() async {
//     isLoading = true;
//     notifyListeners();

//     try {
//       packages = await _packageRepository.fetchPackages();
//       errorMessage = null;
//     } catch (e) {
//       errorMessage = e.toString();
//       packages = [];
//     }

//     isLoading = false;
//     notifyListeners();
//   }
// }
