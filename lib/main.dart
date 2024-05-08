import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "やす子は一歩も引かない",
      home: Scaffold(
        body: SizedBox(
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () async {
                  final player = AudioPlayer();
                  await player.setUrl(
                      'https://firebasestorage.googleapis.com/v0/b/training24yasuko.appspot.com/o/yasuko_kafun.mp3?alt=media');
                  player.play();
                },
                child: const Text('ｶﾌﾝ----!'),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  final player = AudioPlayer();
                  await player.setUrl(
                      'https://firebasestorage.googleapis.com/v0/b/training24yasuko.appspot.com/o/yasuko_hi_long.mp3?alt=media');
                  player.play();
                },
                child: const Text('longﾊｲ----!'),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  final player = AudioPlayer();
                  await player.setUrl(
                      'https://firebasestorage.googleapis.com/v0/b/training24yasuko.appspot.com/o/yasuko_hi_short.mp3?alt=media');
                  player.play();
                },
                child: const Text('ﾊｲ----!'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
