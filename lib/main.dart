import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'components/play_button.dart';
import 'package:flutter_audio_query/flutter_audio_query.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:carousel_slider/carousel_slider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
    );
  }
}

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 3), () {
      Navigator.of(context)
          .pushReplacement(MaterialPageRoute(builder: (_) => MusicApp()));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffff6f00),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Musify",
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 50,
                  fontWeight: FontWeight.w500),
            ),
            SizedBox(
              height: 20.0,
            ),
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            )
          ],
        ),
      ),
    );
  }
}

class MusicApp extends StatefulWidget {
  @override
  _MusicAppState createState() => _MusicAppState();
}

class _MusicAppState extends State<MusicApp> {
  String currentTitle = "";
  String currentSinger = "";
  String currentImage = "";
  String currentPath = "";

  final FlutterAudioQuery audioQuery = FlutterAudioQuery();
  List<SongInfo> songs = [];
  void getSongs() async {
    if (await Permission.storage.request().isGranted) {
      songs = await audioQuery.getSongs();

      setState(() {
        songs = songs;
        currentTitle = songs[0].title;
        currentSinger = songs[0].artist;
        currentPath = songs[0].filePath;
      });
    }
  }

  @override
  void initState() {
    getSongs();
    super.initState();
  }

  IconData btn = Icons.play_arrow;

  AudioPlayer audioPlayer = new AudioPlayer(mode: PlayerMode.MEDIA_PLAYER);
  AudioCache audioCache = AudioCache();

  bool isPlaying = false;
  String currentSong = "";

  Duration duration = new Duration();
  Duration position = new Duration();

  void playMusic(String url) async {
    if (isPlaying && currentSong != url) {
      audioPlayer.pause(); // anith ewa close karanawa
      int result = await audioPlayer.play(url, isLocal: true);

      if (result == 1) {
        setState(() {
          currentSong = url;
          isPlaying = true;
          btn = Icons.pause;
        });
      }
    } else if (!isPlaying) {
      int result = await audioPlayer.play(url, isLocal: true);

      if (result == 1) {
        setState(() {
          isPlaying = true;
          btn = Icons.pause;
        });
      }
    }
    audioPlayer.onDurationChanged.listen((event) {
      setState(() {
        duration = event;
      });
    });
    audioPlayer.onAudioPositionChanged.listen((event) {
      setState(() {
        position = event;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Container(
        width: double.infinity,
        child: Padding(
          padding: EdgeInsets.only(top: 40.0),
          child: Container(
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Text(
                        "Musify",
                        style: TextStyle(color: Colors.white, fontSize: 24),
                      ),
                    ),
                    Row(
                      children: [
                        IconButton(
                            icon: Icon(
                              Icons.search,
                              color: Colors.white,
                            ),
                            onPressed: () {}),
                        Transform.scale(
                            scale: 0.7,
                            child: CupertinoSwitch(
                                value: true,
                                trackColor: Color(0xff4a4a4a),
                                activeColor: Color(0xffff5e00),
                                onChanged: (value) {
                                  setState(() {
                                    value = !value;
                                  });
                                })),
                      ],
                    )
                  ],
                ),
                Container(
                  height: 40,
                  // mainAxisAlignment: MainAxisAlignment.center,
                  alignment: Alignment.center,
                  padding: EdgeInsets.all(5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding:
                            const EdgeInsets.only(bottom: 8, left: 8, right: 8),
                        child: Text(
                          "Songs",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      Padding(
                        padding:
                            const EdgeInsets.only(bottom: 8, left: 8, right: 8),
                        child: Text(
                          "PlayList",
                          style: TextStyle(color: Colors.orange, fontSize: 24),
                        ),
                      ),
                      Padding(
                        padding:
                            const EdgeInsets.only(bottom: 8, left: 8, right: 8),
                        child: Text(
                          "Hello",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                    child: Container(
                        decoration: BoxDecoration(
                            color: Color(0xff121212),
                            borderRadius:
                                BorderRadius.all(Radius.circular(20))),
                        child: ListView.builder(
                            itemCount: songs.length,
                            itemBuilder: (context, index) {
                              return Container(
                                margin: EdgeInsets.only(bottom: 5),
                                decoration: BoxDecoration(
                                  color: Color(0xff212121),
                                ),
                                child: ListTile(
                                  leading: MaterialButton(
                                    onPressed: () {},
                                    color: Color(0xff4d4d4d),
                                    textColor: Colors.orange,
                                    child: Icon(
                                      Icons.music_note_outlined,
                                      size: 22,
                                    ),
                                    padding: EdgeInsets.all(20),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                  ),
                                  title: Text(
                                    songs[index].title,
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 13),
                                  ),
                                  onTap: () {
                                    currentTitle = songs[index].title;
                                    currentSinger = songs[index].artist;
                                    currentPath = songs[index].filePath;
                                    currentImage = "";
                                    playMusic(currentPath);
                                    setState(() {
                                      isPlaying = true;
                                    });
                                  },
                                  subtitle: Row(
                                    children: [
                                      Text(
                                        songs[index].artist,
                                        style: TextStyle(
                                            color: Colors.orange[300]),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            }))),

                // last row  /////////////
                Container(
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(30.0),
                          topRight: Radius.circular(30.0),
                        )),
                    child: Column(children: [
                      // Slider.adaptive(
                      //     value: position.inMicroseconds.toDouble(),
                      //     min: 0.0,
                      //     max: duration.inMicroseconds.toDouble(),
                      //     onChanged: (value) {}),

                      Row(
                        children: [
                          SizedBox(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    color: Colors.orange),
                                padding: EdgeInsets.all(5),
                                child: Icon(
                                  Icons.music_note,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.only(left: 10.0, right: 10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Container(
                                  width: 180,
                                  child: Row(
                                    children: <Widget>[
                                      Flexible(
                                        child: RichText(
                                          overflow: TextOverflow.ellipsis,
                                          strutStyle:
                                              StrutStyle(fontSize: 12.0),
                                          text: TextSpan(
                                              style: TextStyle(
                                                  color: Colors.white),
                                              text: currentTitle),
                                        ),
                                      ),
                                    ],
                                  ),

                                  //   Text(currentSinger,
                                  //       style: TextStyle(
                                  //           color: Colors.grey, fontSize: 12.0))
                                  // ,
                                ),
                                Container(
                                  width: 180,
                                  child: Text(
                                    currentSinger,
                                    style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 10.0,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 20,
                            width: 41,
                            child: MaterialButton(
                              child: Icon(
                                Icons.skip_previous_sharp,
                                color: Colors.orange,
                              ),
                              onPressed: () {},
                            ),
                          ),
                          SizedBox(
                            height: 20,
                            width: 40,
                            child: MaterialButton(
                              child: Icon(
                                Icons.skip_next_rounded,
                                color: Colors.orange,
                              ),
                              onPressed: () {},
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(left: 10),
                            width: 50,
                            alignment: Alignment.center,
                            child: SizedBox(
                              height: 50,
                              width: 50,
                              child: PlayButton(
                                initialIsPlaying: isPlaying,
                                onPressed: () {
                                  {
                                    if (currentSong == "") {
                                      playMusic(currentPath);
                                    } else {
                                      if (isPlaying) {
                                        audioPlayer.pause();
                                        setState(() {
                                          isPlaying = false;
                                          btn = Icons.play_arrow;
                                        });
                                      } else {
                                        audioPlayer.resume();
                                        setState(() {
                                          isPlaying = true;
                                          btn = Icons.pause;
                                        });
                                      }
                                    }
                                  }
                                },
                                playIcon: Icon(btn),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ]))
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// PlayButton(
//                               onPressed: () {
//                                 {
//                                   if (currentSong == "") {
//                                     playMusic(currentPath);
//                                   } else {
//                                     if (isPlaying) {
//                                       audioPlayer.pause();
//                                       setState(() {
//                                         isPlaying = false;
//                                         btn = Icons.play_arrow;
//                                       });
//                                     } else {
//                                       audioPlayer.resume();
//                                       setState(() {
//                                         isPlaying = true;
//                                         btn = Icons.pause;
//                                       });
//                                     }
//                                   }
//                                 }
//                               },
//                               initialIsPlaying: isPlaying,
//                               playIcon: Icon(btn),
//                             ),

// MaterialButton(
//                                 child: Icon(
//                                   btn,
//                                   color: Colors.white,
//                                 ),
//                                 onPressed: () {
//                                   if (currentSong == "") {
//                                     playMusic(currentPath);
//                                   } else {
//                                     if (isPlaying) {
//                                       audioPlayer.pause();
//                                       setState(() {
//                                         isPlaying = false;
//                                         btn = Icons.play_arrow;
//                                       });
//                                     } else {
//                                       audioPlayer.resume();
//                                       setState(() {
//                                         isPlaying = true;
//                                         btn = Icons.pause;
//                                       });
//                                     }
//                                   }
//                                 },
//                               )
