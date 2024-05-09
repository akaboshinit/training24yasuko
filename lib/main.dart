import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:just_audio/just_audio.dart';
import 'package:training24yasuko/firebase_options.dart';
import 'package:training24yasuko/model.dart';

Future<void> main() async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MainApp());
}

enum AudioType {
  kafun,
  hiShort,
  hiLong;

  String get text {
    switch (this) {
      case AudioType.kafun:
        return "花粉";
      case AudioType.hiShort:
        return "ﾊｲ----!";
      case AudioType.hiLong:
        return "ﾊｲ----!";
    }
  }

  String get getUrl {
    switch (this) {
      case AudioType.kafun:
        return "https://firebasestorage.googleapis.com/v0/b/training24yasuko.appspot.com/o/yasuko_kafun.mp3?alt=media";
      case AudioType.hiShort:
        return "https://firebasestorage.googleapis.com/v0/b/training24yasuko.appspot.com/o/yasuko_hi_short.mp3?alt=media";
      case AudioType.hiLong:
        return "https://firebasestorage.googleapis.com/v0/b/training24yasuko.appspot.com/o/yasuko_hi_long.mp3?alt=media";
    }
  }
}

class MainApp extends HookWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    final db = FirebaseFirestore.instance;
    final yasukoCollection = db.collection("yasukoCount");
    final player = AudioPlayer();

    useEffect(() {
      for (var url in AudioType.values) {
        player.setAudioSource(
          AudioSource.uri(Uri.parse(url.getUrl)),
        );
      }
      return null;
    }, []);

    return MaterialApp(
      title: "やす子は一歩も引かない",
      home: Scaffold(
        body: SizedBox(
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AudioBox(
                type: AudioType.kafun,
                player: player,
                yasukoCollection: yasukoCollection,
              ),
              const SizedBox(height: 16.0),
              AudioBox(
                type: AudioType.hiShort,
                player: player,
                yasukoCollection: yasukoCollection,
              ),
              // const SizedBox(height: 16.0),
              // AudioBox(
              //   type: AudioType.hiLong,
              //   player: player,
              //   yasukoCollection: yasukoCollection,
              // ),
            ],
          ),
        ),
      ),
    );
  }
}

class AudioBox extends HookWidget {
  const AudioBox(
      {super.key,
      required this.type,
      required this.player,
      required this.yasukoCollection});

  final AudioType type;
  final AudioPlayer player;
  final CollectionReference yasukoCollection;

  @override
  Widget build(BuildContext context) {
    Future<void> startAudio(AudioType type) async {
      final storageUrl = type.getUrl;
      await player.setUrl(storageUrl);
      player.play();
    }

    Future<void> tap({
      required VoidCallback onIncrement,
    }) async {
      await yasukoCollection.doc(type.name).set({
        "count": FieldValue.increment(1),
      }, SetOptions(merge: true));
      onIncrement();
    }

    return Column(
      children: [
        ElevatedButton(
          onPressed: () async {
            await startAudio(type);
            await tap(onIncrement: () {});
          },
          child: Text(type.text),
        ),
        StreamBuilder(
          stream: yasukoCollection.doc(type.name).snapshots(),
          builder: (context, snapshot) {
            if (snapshot.error != null ||
                !snapshot.hasData ||
                snapshot.data == null) {
              return const CircularProgressIndicator();
            }

            final counter = Counter.fromFirestore(snapshot.data?.data() ?? {});
            final count = counter.count;

            return Text("$count");
          },
        ),
      ],
    );
  }
}
