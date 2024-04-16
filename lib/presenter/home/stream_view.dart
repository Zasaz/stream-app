import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tv_channels_app/core/model/channel_model.dart';
import 'package:tv_channels_app/core/remote/controllers/channel_controller.dart';
import 'package:tv_channels_app/core/remote/controllers/package_controller.dart';

class StreamView extends ConsumerStatefulWidget {
  const StreamView({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _MainViewState();
}

class _MainViewState extends ConsumerState<StreamView> {
  @override
  Widget build(BuildContext context) {
    // Watch the channel controller for changes
    final channelController = ref.watch(channelControllerNotifier);
    final channels = channelController.channels;
    final packageController = ref.watch(packageControllerNotifier);

    return Scaffold(
        appBar: AppBar(title: const Text('Package List')),
        body: Consumer(
          builder: (context, watch, child) {
            if (packageController.isLoading) {
              return const CircularProgressIndicator();
            } else if (packageController.message != null) {
              return Text('Error: ${packageController.message}');
            } else if (packageController.packages?.isEmpty ?? true) {
              return const Text('No packages available');
            } else {
              return ListView.builder(
                itemCount: packageController.packages!.length,
                itemBuilder: (context, index) {
                  final package = packageController.packages![index];
                  return ListTile(
                    title: Text('Package ID: ${package.id}'),
                    subtitle: Text(
                        'Purchased: ${package.purchased ?? "Not purchased"}'),
                  );
                },
              );
            }
          },
        ));
  }
}
