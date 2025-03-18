import 'package:flutter/material.dart';
import 'package:ivs_broadcaster/Player/Widget/ivs_player_view.dart';
import 'package:ivs_broadcaster/Player/ivs_player.dart';
// import 'package:ivs_broadcaster/Player/ivs_player_view.dart';

class IVSPlayerWidget extends StatefulWidget {
  @override
  ivsPlayerWidgetState createState() => ivsPlayerWidgetState();
}

class ivsPlayerWidgetState extends State<IVSPlayerWidget> {
  late IvsPlayer ivsPlayer;
  final String _streamUrl =
      'https://eab30f14a9fe.ap-south-1.playback.live-video.net/api/video/v1/ap-south-1.730335194207.channel.Y9CFVXzZxIcK.m3u8';

  @override
  void initState() {
    super.initState();
    ivsPlayer = IvsPlayer();
    ivsPlayer.initialize();
    ivsPlayer.startPlayer(
      _streamUrl,
      autoPlay: true,
    );
  }

  @override
  void dispose() {
    ivsPlayer.stopPlayer();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 16 / 9,
      child: IvsPlayerView(
        controller: ivsPlayer,
        autoDispose: true,
        aspectRatio: 16 / 9,
      ),
    );
  }
}

extension on IvsPlayer {
  void initialize() {}
}

class PlayerWidget extends StatelessWidget {
  const PlayerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      onPressed: () {
        Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => IVSPlayerWidget()),
        );
      },
      color: Colors.amber[600],
      child: const Text("Go to Stream"),
    );
  }
}
