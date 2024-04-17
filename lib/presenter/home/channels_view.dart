import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tv_channels_app/core/remote/controllers/channel_controller.dart';

class ChannelsView extends ConsumerStatefulWidget {
  final String packageId;
  const ChannelsView({Key? key, required this.packageId}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ChannelsViewState();
}

class _ChannelsViewState extends ConsumerState<ChannelsView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        ref
            .read(channelControllerNotifier)
            .fetchChannelsByPackageId(widget.packageId);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final channelController = ref.watch(channelControllerNotifier);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Channels'),
      ),
      body: channelController.isLoading
          ? const Center(child: CircularProgressIndicator())
          : channelController.channels!.isEmpty
              ? const Center(child: Text("No channels available"))
              : ListView.builder(
                  physics: const AlwaysScrollableScrollPhysics(
                    parent: BouncingScrollPhysics(),
                  ),
                  padding: const EdgeInsets.only(right: 5, left: 5),
                  itemCount: channelController.channels?.length,
                  itemBuilder: (context, index) {
                    final channel = channelController.channels?[index];
                    return Card(
                      elevation: 1.5,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(8)),
                      ),
                      child: ListTile(
                        title: Text(channel!.name),
                        onTap: () {/* your tap logic here */},
                      ),
                    );
                  },
                ),
    );
  }
}
