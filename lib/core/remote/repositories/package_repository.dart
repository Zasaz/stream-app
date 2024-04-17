import 'package:tv_channels_app/core/model/package_model.dart';
import 'package:tv_channels_app/core/remote/network_request.dart';

class PackageRepository {
  final NetworkRequest _networkRequest = NetworkRequest();
  Future<List<PackageModel>> fetchPackages() async {
    try {
      List<PackageModel> packages = await _networkRequest.getPackages();
      return packages;
    } catch (e) {
      throw Exception("Failed to fetch packages: $e");
    }
  }
}
