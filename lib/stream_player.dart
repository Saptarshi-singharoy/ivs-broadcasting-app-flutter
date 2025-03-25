import 'package:flutter/material.dart';
import 'package:ivs_broadcast_app/ivs_player_widget.dart';
import 'package:ivs_broadcast_app/services/api_service.dart';

class StreamPlayer extends StatefulWidget {
  const StreamPlayer({super.key});

  @override
  State<StreamPlayer> createState() => _StreamPlayerState();
}

class _StreamPlayerState extends State<StreamPlayer> {
  String playbackUrl = "";

  Future<void> startStream() async {
    try {
      final response = await ApiService.findChannel();

      setState(() {
        playbackUrl = response['playbackUrl'];
      });
    } catch (e) {
      print('Error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to start broadcast: $e')),
      );
      throw Exception(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        child: Column(
          children: [
            const SizedBox(
              width: 250,
              child: TextField(
                obscureText: false,
                decoration: InputDecoration(
                    border: OutlineInputBorder(), labelText: 'Password'),
              ),
            ),
            MaterialButton(
              onPressed: () async {
                await startStream();
                Navigator.of(context).push(
                  MaterialPageRoute(
                      builder: (context) => IVSPlayerWidget(
                          playbackUrl: playbackUrl
                          // 'https://eab30f14a9fe.ap-south-1.playback.live-video.net/api/video/v1/ap-south-1.730335194207.channel.Y9CFVXzZxIcK.m3u8',
                          )),
                );
              },
              color: Colors.amber[600],
              child: const Text("Go to Stream"),
            )
          ],
        ),
      ),
    );
  }
}
