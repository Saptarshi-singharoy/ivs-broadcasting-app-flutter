import 'package:flutter/material.dart';
import 'package:ivs_broadcast_app/broad_cast_widget.dart';
import 'package:ivs_broadcast_app/ivs_player_widget.dart';
import 'package:ivs_broadcast_app/services/api_service.dart';
import 'package:ivs_broadcast_app/stream_player.dart';
import 'package:ivs_broadcaster/Broadcaster/ivs_broadcaster.dart';
import 'package:ivs_broadcaster/Player/Widget/ivs_player_view.dart';
import 'package:ivs_broadcaster/Player/ivs_player.dart';
import 'package:firebase_core/firebase_core.dart';
import './services/notification_service.dart';

final NotificationService _notificationService = NotificationService();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await _notificationService.init();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String? _fcmToken;

  @override
  void initState() {
    super.initState();
    _initializeNotifications();
  }

  Future<void> _initializeNotifications() async {
    await _notificationService.requestPermission();
    final token = await _notificationService.getFCMToken();
    setState(() {
      _fcmToken = token;
    });
    _notificationService.configureFirebaseListeners();
    if (_fcmToken != null) {
      try {
        await ApiService.saveToken(_fcmToken, "saptarshi123456");
      } catch (e) {
        print("Failed to store fcm token");
        throw Exception(e);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'IVS Broadcasting',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const Column(
        children: [
          Expanded(child: BroadCastWidget()),
          Expanded(child: StreamPlayer())
        ],
      ),
    );
  }
}

class BroadcastPage extends StatefulWidget {
  const BroadcastPage({super.key});

  @override
  _BroadcastPageState createState() => _BroadcastPageState();
}

class _BroadcastPageState extends State<BroadcastPage> {
  bool isBroadcasting = false;
  late IvsBroadcaster _ivsBroadcaster;
  IvsPlayer? ivsPlayer;

  @override
  void initState() {
    super.initState();
    ivsPlayer = IvsPlayer();
    _ivsBroadcaster = IvsBroadcaster.instance;
  }

  // Start broadcasting
  Future<void> startBroadcasting() async {
    String streamKey =
        'sk_ap-south-1_N000R0cAO6i1_ViDGIjyULWUHU0olOp9bRoXfScd1es'; // Add your AWS IVS stream key here
    String streamUrl =
        'https://eab30f14a9fe.ap-south-1.playback.live-video.net/api/video/v1/ap-south-1.730335194207.channel.rMfiUBunert8.m3u8'; // Add your AWS IVS stream URL here

    await _ivsBroadcaster.startPreview(
      imgset: streamUrl,
      streamKey: streamKey,
    );

    // if (result) {
    //   setState(() {
    //     isBroadcasting = true;
    //   });
    // } else {
    //   // Handle failure
    //   ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    //     content: Text("Failed to start broadcasting."),
    //   ));
    // }
  }

  // Stop broadcasting
  Future<void> stopBroadcasting() async {
    await _ivsBroadcaster.stopBroadcast();
    setState(() {
      isBroadcasting = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('IVS Broadcasting'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Preview of the broadcast
          isBroadcasting
              ? SizedBox(
                  height: 300,
                  width: double.infinity,
                  child: IvsPlayerView(
                    controller: ivsPlayer!,
                  ),
                )
              : SizedBox(
                  height: 300,
                  width: double.infinity,
                  child:
                      const Center(child: Text('No stream preview available')),
                ),
          const SizedBox(height: 20),
          // Button to start/stop broadcasting
          ElevatedButton(
            onPressed: isBroadcasting ? stopBroadcasting : startBroadcasting,
            child: Text(
                isBroadcasting ? 'Stop Broadcasting' : 'Start Broadcasting'),
          ),
        ],
      ),
    );
  }
}
