import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:just_audio/just_audio.dart';
import 'package:training24yasuko/firebase_options.dart';

Future<void> main() async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MainApp());
}

enum AudioType {
  kafun,
  hiShort;
  // hiLong;

  String get text {
    switch (this) {
      case AudioType.kafun:
        return "花粉";
      case AudioType.hiShort:
        return "ﾊｲ----!";
      // case AudioType.hiLong:
      //   return "ﾊｲ----!";
    }
  }

  String get getUrl {
    switch (this) {
      case AudioType.kafun:
        return "https://firebasestorage.googleapis.com/v0/b/training24yasuko.appspot.com/o/yasuko_kafun.mp3?alt=media";
      case AudioType.hiShort:
        return "https://firebasestorage.googleapis.com/v0/b/training24yasuko.appspot.com/o/yasuko_hi_short.mp3?alt=media";
      // case AudioType.hiLong:
      //   return "https://firebasestorage.googleapis.com/v0/b/training24yasuko.appspot.com/o/yasuko_hi_long.mp3?alt=media";
    }
  }
}

class MainApp extends HookWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
        title: "一歩も引かないやす子", debugShowCheckedModeBanner: false, home: App());
  }
}

final db = FirebaseFirestore.instance;
final yasukoCollection = db.collection("yasukoCount");
final player = AudioPlayer();
final maxWidth = 400.toDouble();

class App extends HookWidget {
  const App({super.key});
  @override
  Widget build(BuildContext context) {
    useEffect(() {
      player.setVolume(1.0);
      for (var url in AudioType.values) {
        player.setAudioSource(
          AudioSource.uri(Uri.parse(url.getUrl)),
        );
      }

      return null;
    }, []);

    Future<void> tap({
      required AudioType type,
    }) async {
      final storageUrl = type.getUrl;

      AudioPlayer tmpPlayer = player;
      if (type == AudioType.hiShort) {
        tmpPlayer = AudioPlayer();
      } else {
        await tmpPlayer.stop();
      }

      await tmpPlayer.setUrl(storageUrl);
      tmpPlayer.play();
      await yasukoCollection.doc(type.name).set({
        "count": FieldValue.increment(1),
      }, SetOptions(merge: true));
    }

    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: SizedBox(
          width: maxWidth,
          child: Container(
            width: double.infinity,
            height: double.infinity,
            color: Colors.black,
            child: Stack(
              alignment: Alignment.center,
              children: [
                Positioned(
                  left: 0,
                  top: 0,
                  width: maxWidth,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Image.network(
                        "cover.png",
                        fit: BoxFit.contain,
                      ),
                      Positioned(
                        bottom: 0,
                        height: 250,
                        width: maxWidth,
                        child: Container(
                          foregroundDecoration: const BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Colors.black,
                                Colors.transparent,
                              ],
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              stops: [0.6, 0],
                            ),
                          ),
                          child: const SizedBox(
                            width: double.infinity,
                            height: 900,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Positioned(
                  bottom: 0,
                  width: MediaQuery.of(context).size.width,
                  child: Column(
                    children: [
                      const Text(
                        "みんなで連打！！",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 38,
                          fontWeight: FontWeight.bold,
                          shadows: <Shadow>[
                            Shadow(
                              offset: Offset(2.0, 2.0),
                              blurRadius: 1.0,
                              color: Color.fromARGB(255, 0, 0, 0),
                            ),
                            Shadow(
                              offset: Offset(2.0, 2.0),
                              blurRadius: 2.0,
                              color: Color.fromARGB(255, 10, 144, 50),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 12,
                      ),
                      GestureDetector(
                        onTap: () async {
                          await tap(
                            type: AudioType.kafun,
                          );
                        },
                        child: Image.network(
                          "button2.png",
                          width: 300,
                        ),
                      ),
                      StreamBuilder(
                        stream: yasukoCollection.doc("kafun").snapshots(),
                        builder: (context, snapshot) {
                          if (snapshot.error != null ||
                              !snapshot.hasData ||
                              snapshot.data == null) {
                            return const CircularProgressIndicator();
                          }

                          final count = snapshot.data?.data()!["count"];

                          return RichText(
                            text: TextSpan(children: [
                              const TextSpan(
                                text: "連続",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const WidgetSpan(
                                  alignment: PlaceholderAlignment.baseline,
                                  baseline: TextBaseline.alphabetic,
                                  child: SizedBox(width: 10)),
                              TextSpan(
                                text: count.toString(),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 38,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const WidgetSpan(
                                  alignment: PlaceholderAlignment.baseline,
                                  baseline: TextBaseline.alphabetic,
                                  child: SizedBox(width: 10)),
                              const TextSpan(
                                text: "回",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ]),
                          );
                        },
                      ),
                      const SizedBox(height: 12),
                      GestureDetector(
                        onTap: () async {
                          await tap(
                            type: AudioType.hiShort,
                          );
                        },
                        child: Image.network(
                          "button1.png",
                          width: 300,
                        ),
                      ),
                      StreamBuilder(
                        stream: yasukoCollection.doc("hiShort").snapshots(),
                        builder: (context, snapshot) {
                          if (snapshot.error != null ||
                              !snapshot.hasData ||
                              snapshot.data == null) {
                            return const CircularProgressIndicator();
                          }

                          final count = snapshot.data?.data()!["count"];

                          return RichText(
                            text: TextSpan(children: [
                              const TextSpan(
                                text: "連続",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const WidgetSpan(
                                  alignment: PlaceholderAlignment.baseline,
                                  baseline: TextBaseline.alphabetic,
                                  child: SizedBox(width: 10)),
                              TextSpan(
                                text: count.toString(),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 38,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const WidgetSpan(
                                  alignment: PlaceholderAlignment.baseline,
                                  baseline: TextBaseline.alphabetic,
                                  child: SizedBox(width: 10)),
                              const TextSpan(
                                text: "回",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ]),
                          );
                        },
                      ),
                      const SizedBox(
                        height: 28,
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
