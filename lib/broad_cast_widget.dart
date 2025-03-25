import 'package:flutter/material.dart';
import 'package:ivs_broadcast_app/services/api_service.dart';
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

  String _streamKey = "";
  String _ingestServer = "";

  Future<void> startBroadcast() async {
    print("Start Broadcast");
    try {
      final response = await ApiService.createChannel(false);
      print(response);

      setState(() {
        _ingestServer = response['ingestServer'];
        _streamKey = response['streamKey'];
      });

      print('Ingest Server: $_ingestServer');
      print('Stream Key: $_streamKey');

      if (_ingestServer.isEmpty || _streamKey.isEmpty) {
        throw Exception('Ingest server or stream key is empty');
      }

      await ivsBroadcaster?.startPreview(
        imgset: "rtmps://$_ingestServer:443/app/",
        streamKey: _streamKey,
        //you can also give cameraType
        // Its by Default Back
        //camerType: CameraType.BACK,
      );
      await ivsBroadcaster?.startBroadcast();
      await ApiService.sendNotifications("New Notification",
          {"success": true, "message": "notification came successfully"});
    } catch (e) {
      print('Error in starting broadcast: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to start broadcast: $e')),
      );
    }
  }

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
              onPressed: startBroadcast,
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
