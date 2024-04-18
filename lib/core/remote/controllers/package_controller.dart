import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../model/package_model.dart';
import '../repositories/package_repository.dart';
import '../../../utils/utils.dart';

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
  List<PackageModel>? _packages;

  PackageController({required PackageRepository packageRepository})
      : _packageRepository = packageRepository {
    fetchPackages(); // Call fetchPackages on initialization
  }

  Future<void> fetchPackages() async {
    isLoading = true;
    notifyListeners();

    try {
      _packages = await _packageRepository.fetchPackages();
      if (_packages != null && _packages!.isNotEmpty) {
        message = "Packages fetched successfully.";
        debugPrint("Packages fetched successfully: ${_packages?.length}");
        debugPrint("PrettyJson Package: ${prettyJson(_packages)}");
        statusCode = "200";
      } else {
        message = "No Packages available";
        statusCode = "400";
      }
    } catch (e) {
      message = "An error occurred: $e";
      statusCode = "500";
    }

    isLoading = false;
    notifyListeners();
  }

  List<PackageModel>? get packages => _packages;
}
