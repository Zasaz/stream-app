import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tv_channels_app/core/local/local_storage.dart';
import 'package:tv_channels_app/presenter/auth/name_view.dart';
import 'package:tv_channels_app/utils/constants/app_constants.dart';
import '../../core/remote/controllers/package_controller.dart';
import 'channels_view.dart';

class PackageView extends ConsumerStatefulWidget {
  const PackageView({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _MainViewState();
}

class _MainViewState extends ConsumerState<PackageView> {
  @override
  Widget build(BuildContext context) {
    // Watch the controller for changes
    // final channelController = ref.watch(channelControllerNotifier);
    // final channels = channelController.channels;
    final packageController = ref.watch(packageControllerNotifier);

    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Packages',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
          ),
          actions: [
            IconButton(
              iconSize: 24,
              color: Colors.red,
              onPressed: () async {
                await LocalStorage().clearSharedPref(AppConstants.token);
                if (!mounted) return;
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const NameView()),
                );
              },
              icon: const Icon(Icons.logout),
            ),
          ],
          automaticallyImplyLeading: false,
        ),
        body: packageController.isLoading
            ? const Center(child: CircularProgressIndicator())
            : ListView.builder(
                physics: const AlwaysScrollableScrollPhysics(
                  parent: BouncingScrollPhysics(),
                ),
                padding: const EdgeInsets.only(right: 5, left: 5),
                itemCount: packageController.packages?.length,
                itemBuilder: (context, index) {
                  final package = packageController.packages![index];
                  return Card(
                    elevation: 1.5,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(8)),
                    ),
                    child: ListTile(
                      title: Text('Package ID: ${package.id}'),
                      subtitle: Text(
                        'Purchased: ${package.purchased?.toString() ?? "Not purchased"}',
                      ),
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ChannelsView(
                            packageId: package.id.toString(),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }
}
