import 'package:flutter/material.dart';
import 'package:ivs_broadcaster/Broadcaster/Widgets/preview_widget.dart';
import 'package:ivs_broadcaster/Broadcaster/ivs_broadcaster.dart';

class BroadCastWidget extends StatefulWidget {
  const BroadCastWidget({
    super.key,
  });

  @override
  State<BroadCastWidget> createState() => _BroadCastWidgetState();
}

class _BroadCastWidgetState extends State<BroadCastWidget> {
  IvsBroadcaster? ivsBroadcaster;
  //put your key and ingset url starts with rtmps://

  String key = "sk_ap-south-1_csjTJBpSQgcE_wudaUznvG9vkDunZGARWJzJyg5Ln46";
  String url =
      // "https://eab30f14a9fe.ap-south-1.playback.live-video.net/api/video/v1/ap-south-1.730335194207.channel.Y9CFVXzZxIcK.m3u8";
      "rtmps://eab30f14a9fe.global-contribute.live-video.net:443/app/";

  @override
  void initState() {
    super.initState();
    //Make sure to use .broadcaster
    ivsBroadcaster = IvsBroadcaster.instance;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            // Start Broadcast
            ElevatedButton(
              onPressed: () async {
                await ivsBroadcaster?.startPreview(
                  imgset: url,
                  streamKey: key,
                  //you can also give cameraType
                  // Its by Default Back
                  //camerType: CameraType.BACK,
                );
                await ivsBroadcaster?.startBroadcast();
              },
              child: const Text('Start Broadcast'),
            ),
            // Stop Broadcast
            ElevatedButton(
              onPressed: () async {
                await ivsBroadcaster?.stopBroadcast();
              },
              child: const Text('Stop Broadcast'),
            ),
          ],
        ),
      ),
      body: const BroadcaterPreview(),
    );
  }
}
