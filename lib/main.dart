import 'package:audioplayers/audioplayers.dart';
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
      home: MusicApp(),
    );
  }
}

class MusicApp extends StatefulWidget {
  @override
  _MusicAppState createState() => _MusicAppState();
}

class _MusicAppState extends State<MusicApp> {
  List musicList = [
    {
      'title': "Diurala Pawasanna",
      'singer': 'Centigraz',
      'url': 'http://topbadu.net/sinhala_mp3/Centigradz_Diurala_Pawasanna.mp3',
      'cover': 'https://tune.lk/storage/app/public/img/artist/1584102213.jpg'
    },
    {
      'title': "Miduma",
      'singer': 'Centigraz',
      'url': 'https://luan.xyz/files/audio/nasa_on_a_mission.mp3',
      'cover':
          'https://a10.gaanacdn.com/images/albums/47/3058247/crop_175x175_1613702526_3058247.jpg'
    },
    {
      'title': "Diurala Pawasanna",
      'singer': 'Centigraz',
      'url': 'https://luan.xyz/files/audio/ambient_c_motion.mp3',
      'cover':
          'https://artmusic.lk/wp-content/uploads/2020/10/artmusic.lk-Obata-Lanvee-Apoorwa-Theme-Song-FM-Derana-Raween-Kanishka-Nuwandika-Senarathne.jpeg'
    },
  ];

  final FlutterAudioQuery audioQuery = FlutterAudioQuery();
  List<SongInfo> songs = [];

  Future<void> getSongs() async {
    // var status = await Permission.camera.status;
    // if (status.isDenied) {
    songs = await audioQuery.getSongs();
    print(songs[0]);
    // }
  }

  @override
  void initState() {
    super.initState();
    getSongs();
  }

  String currentSinger = "";
  String currentTitle = "";
  String currentCover = "";
  IconData btn = Icons.play_arrow;

  AudioPlayer audioPlayer = new AudioPlayer(mode: PlayerMode.MEDIA_PLAYER);
  AudioCache audioCache;
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
      backgroundColor: Color(0xff16202a),
      appBar: AppBar(
        backgroundColor: Color(0xff1c2939),
        title: Text("My Music Player"),
        elevation: 0,
      ),
      body: Column(
        children: [
          Expanded(
            // child: ListView.builder(
            //     itemCount: musicList.length,
            //     itemBuilder: (context, index) => customListTile(
            //         title: musicList[index]['title'],
            //         singer: musicList[index]['singer'],
            //         cover: musicList[index]['cover'],
            //         onTap: () {
            //           playMusic(musicList[index]['url']);
            //           setState(() {
            //             currentTitle = musicList[index]['title'];
            //             currentCover = musicList[index]['cover'];
            //             currentSinger = musicList[index]['singer'];
            //           });
            //         })),
            // child: ListView.builder(
            //     itemCount: songs.length,
            //     itemBuilder: (context, index) => customListTile(
            //         title: musicList[index]['title'],
            //         singer: musicList[index]['singer'],
            //         cover: musicList[index]['cover'],
            //         onTap: () {
            //           playMusic(musicList[index]['url']);
            //           setState(() {
            //             currentTitle = musicList[index]['title'];
            //             currentCover = musicList[index]['cover'];
            //             currentSinger = musicList[index]['singer'];
            //           });
            //         })),
            child: ListView.builder(
              itemCount: songs.length,
              itemBuilder: (context, index) {
                var song = songs[index];

                return ListTile(
                  title: Text(song.title),
                  onTap: () {
                    playMusic(song.filePath);
                  },
                  subtitle: Row(
                    children: [
                      Text(song.artist),
                    ],
                  ),
                );
              },
            ),
          ),
          Container(
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(color: Color(0xff1c2939), boxShadow: [
              BoxShadow(
                color: Color(0x55212121),
              )
            ]),
            child: Column(
              children: [
                Slider.adaptive(
                    value: position.inMicroseconds.toDouble(),
                    min: 0.0,
                    max: duration.inMicroseconds.toDouble(),
                    onChanged: (value) {}),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      height: 80.0,
                      width: 80.0,
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16.0),
                          image: DecorationImage(
                              image: NetworkImage(currentCover))),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          currentTitle,
                          style: TextStyle(
                              fontSize: 18.0,
                              fontWeight: FontWeight.w600,
                              color: Colors.white),
                        ),
                        SizedBox(
                          height: 5.0,
                        ),
                        Text(currentSinger,
                            style: TextStyle(
                                color: Colors.white24, fontSize: 16.0))
                      ],
                    ),
                    IconButton(
                        icon: Icon(btn),
                        onPressed: () {
                          if (isPlaying) {
                            audioPlayer.pause();
                            setState(() {
                              isPlaying = false;
                              btn = Icons.pause;
                            });
                          } else {
                            audioPlayer.resume();
                            setState(() {
                              isPlaying = true;
                              btn = Icons.play_arrow;
                            });
                          }
                        },
                        iconSize: 42),
                    TextButton(
                      style: ButtonStyle(
                        foregroundColor:
                            MaterialStateProperty.all<Color>(Colors.blue),
                      ),
                      onPressed: () => getSongs,
                      child: Text('Scan'),
                    )
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
