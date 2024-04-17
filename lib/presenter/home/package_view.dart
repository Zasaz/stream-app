import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tv_channels_app/core/model/channel_model.dart';
import 'package:tv_channels_app/core/remote/controllers/channel_controller.dart';
import 'package:tv_channels_app/core/remote/controllers/package_controller.dart';
import 'package:tv_channels_app/presenter/home/channels_view.dart';

class PackageView extends ConsumerStatefulWidget {
  const PackageView({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _MainViewState();
}

class _MainViewState extends ConsumerState<PackageView> {
  @override
  Widget build(BuildContext context) {
    // Watch the channel controller for changes
    final channelController = ref.watch(channelControllerNotifier);
    final channels = channelController.channels;
    final packageController = ref.watch(packageControllerNotifier);

    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Packages',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
          ),
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
