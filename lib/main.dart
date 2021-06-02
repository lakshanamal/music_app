import 'package:flutter/material.dart';
import 'components/custom_list.dart';
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
      'url': 'https://luan.xyz/files/audio/ambient_c_motion.mp3',
      'cover':'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRZL_947MiMwYjbz6KRX57tuBubJp-YNk4kUg&usqp=CAU'
    },
    {
      'title': "Diurala Pawasanna",
      'singer': 'Centigraz',
      'url': 'https://luan.xyz/files/audio/nasa_on_a_mission.mp3',
       'cover':'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRZL_947MiMwYjbz6KRX57tuBubJp-YNk4kUg&usqp=CAU'
    },
    {
      'title': "Diurala Pawasanna",
      'singer': 'Centigraz',
      'url': 'https://luan.xyz/files/audio/ambient_c_motion.mp3',
       'cover':'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRZL_947MiMwYjbz6KRX57tuBubJp-YNk4kUg&usqp=CAU'
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text("My Music Player"),
        elevation: 0,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount:musicList.length,
              itemBuilder: (context,index)=>customListTile(
             title: musicList[index]['title'],
              singer:musicList[index]['singer'],
              cover:musicList[index]['cover']
            )),
          ),
          Container()
        ],
      ),
    );
  }
}
