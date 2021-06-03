import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
// import 'components/custom_list.dart';
import 'package:flutter_audio_query/flutter_audio_query.dart';
import 'package:permission_handler/permission_handler.dart';

// main method in flutter
void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MusicApp(),
    );
  }
}

class MusicApp extends StatefulWidget {
  @override
  _MusicAppState createState() => _MusicAppState();
}

class _MusicAppState extends State<MusicApp> {
  final FlutterAudioQuery audioQuery = FlutterAudioQuery();
  List<SongInfo> songs = [];

  Future<void> getSongs() async {
    songs = await audioQuery.getSongs();
    return songs;
  }

  @override
  void initState() {
    super.initState();
    getSongs();
  }

  IconData btn = Icons.play_arrow;

  AudioPlayer audioPlayer = new AudioPlayer(mode: PlayerMode.MEDIA_PLAYER);
  // AudioCache audioCache=getSongs();
  bool isPlaying = false;
  String currentSong = "";

  Duration duration = new Duration();
  Duration position = new Duration();

  void playMusic(String url) async {
    if (isPlaying && currentSong != url) {
      audioPlayer.pause();
      int result = await audioPlayer.play(url);

      if (result == 1) {
        setState(() {
          currentSong = url;
        });
      }
    } else if (!isPlaying) {
      int result = await audioPlayer.play(url);

      if (result == 1) {
        setState(() {
          isPlaying = true;
          btn = Icons.play_arrow;
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
          padding: EdgeInsets.only(top: 48.0),
          child: Container(
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Musify",
                      style: TextStyle(color: Colors.white, fontSize: 24),
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
                Expanded(
                    child: Container(
                  decoration: BoxDecoration(
                      color: Color(0xff242424),
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30.0),
                        topRight: Radius.circular(30.0),
                      )),
                )),
                Container(
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.all(Radius.circular(40))),
                    child: Column(children: [
                      // Slider.adaptive(
                      //     value: position.inMicroseconds.toDouble(),
                      //     min: 0.0,
                      //     max: duration.inMicroseconds.toDouble(),
                      //     onChanged: (value) {}),
                      Row(
                        // mainAxisAlignment: MainAxisAlignment.spaceEvenly,

                        children: [
                          SizedBox(
                            height: 200,
                            width: 200,
                            child: Blob(),
                          ),
                          MaterialButton(
                            child: Icon(
                              Icons.skip_previous_outlined,
                              color: Colors.orange,
                            ),
                            padding: EdgeInsets.all(20),
                            onPressed: () {
                              if (isPlaying) {
                                audioPlayer.pause();
                                setState(() {
                                  isPlaying = false;
                                  btn = Icons.skip_previous_outlined;
                                });
                              } else {
                                audioPlayer.resume();
                                setState(() {
                                  isPlaying = true;
                                  btn = Icons.pause;
                                });
                              }
                            },
                          ),
                          MaterialButton(
                            child: Icon(
                              Icons.play_arrow,
                              color: Colors.orange[800],
                              size: 35,
                            ),
                            padding: EdgeInsets.all(20),
                            onPressed: () {
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
                            },
                          ),
                          MaterialButton(
                            child: Icon(
                              Icons.skip_next_outlined,
                              color: Colors.orange,
                            ),
                            padding: EdgeInsets.all(20),
                            onPressed: () {
                              if (isPlaying) {
                                audioPlayer.pause();
                                setState(() {
                                  isPlaying = false;
                                  btn = Icons.skip_next_outlined;
                                });
                              } else {
                                audioPlayer.resume();
                                setState(() {
                                  isPlaying = true;
                                  btn = Icons.pause;
                                });
                              }
                            },
                          ),
                        ],
                      ),
                    ]))
              ],
            ),
          ),
        ),
      ),

      // body: Column(
      //   children: [
      //     Expanded(
      //       child: ListView.builder(
      //         itemCount: songs.length,
      //         itemBuilder: (context, index) {
      //           var song = songs[index];

      //           return ListTile(
      //             leading: MaterialButton(
      //               onPressed: () {},
      //               color: Colors.blue,
      //               textColor: Colors.white,
      //               child: Icon(
      //                 Icons.music_note_outlined,
      //                 size: 24,
      //               ),
      //               padding: EdgeInsets.all(16),
      //               shape: CircleBorder(),
      //             ),
      //             title: Text(
      //               song.title,
      //               style: TextStyle(color: Colors.white),
      //             ),
      //             onTap: () {
      //               playMusic(song.filePath);
      //             },
      //             subtitle: Row(
      //               children: [
      //                 Text(
      //                   song.artist,
      //                   style: TextStyle(color: Color(0xff3c8cef)),
      //                 ),
      //               ],
      //             ),
      //           );
      //         },
      //       ),
      //     ),
      //     Container(
      //       padding: EdgeInsets.all(10),
      //       decoration: BoxDecoration(color: Color(0xff1c2939), boxShadow: [
      //         BoxShadow(
      //           color: Color(0x55212121),
      //         )
      //       ]),
      //       child: Column(
      //         children: [
      //           Slider.adaptive(
      //               value: position.inMicroseconds.toDouble(),
      //               min: 0.0,
      //               max: duration.inMicroseconds.toDouble(),
      //               onChanged: (value) {}),
      //           Row(
      //             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      //             children: [
      //               MaterialButton(
      //                 child: Icon(
      //                   Icons.next_plan,
      //                   color: Colors.white,
      //                 ),
      //                 color: Colors.blue,
      //                 shape: CircleBorder(),
      //                 padding: EdgeInsets.all(20),
      //                 onPressed: () {
      //                   if (isPlaying) {
      //                     audioPlayer.pause();
      //                     setState(() {
      //                       isPlaying = false;
      //                       btn = Icons.play_arrow;
      //                     });
      //                   } else {
      //                     audioPlayer.resume();
      //                     setState(() {
      //                       isPlaying = true;
      //                       btn = Icons.pause;
      //                     });
      //                   }
      //                 },
      //               ),
      //               MaterialButton(
      //                 child: Icon(
      //                   Icons.play_arrow,
      //                   color: Colors.white,
      //                 ),
      //                 padding: EdgeInsets.all(20),
      //                 onPressed: () {
      //                   if (isPlaying) {
      //                     audioPlayer.pause();
      //                     setState(() {
      //                       isPlaying = false;
      //                       btn = Icons.play_arrow;
      //                     });
      //                   } else {
      //                     audioPlayer.resume();
      //                     setState(() {
      //                       isPlaying = true;
      //                       btn = Icons.pause;
      //                     });
      //                   }
      //                 },
      //               ),
      //               MaterialButton(
      //                 child: Icon(
      //                   Icons.play_arrow,
      //                   color: Colors.white,
      //                 ),
      //                 color: Colors.blue,
      //                 shape: CircleBorder(),
      //                 padding: EdgeInsets.all(20),
      //                 onPressed: () {
      //                   if (isPlaying) {
      //                     audioPlayer.pause();
      //                     setState(() {
      //                       isPlaying = false;
      //                       btn = Icons.play_arrow;
      //                     });
      //                   } else {
      //                     audioPlayer.resume();
      //                     setState(() {
      //                       isPlaying = true;
      //                       btn = Icons.pause;
      //                     });
      //                   }
      //                 },
      //               ),
      //             ],
      //           )
      //         ],
      //       ),
      //     )
      //   ],
      // ),
    );
  }
}

class Blob extends StatelessWidget {
final double rotation;
final double scale;
final double color;
  const Blob({
  //  
   this.color,this.rotation,this.scale
  }) : assert(color !=null);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Color(0xff0092ff),
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(150),
              topRight: Radius.circular(240),
              bottomLeft: Radius.circular(220),
              bottomRight: Radius.circular(180))),
    );
  }
}
