import 'package:flutter/material.dart';


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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar:AppBar(
        backgroundColor: Colors.blue,
        title: Text("My Music Player"),
        elevation: 0,
      ),
      body: Column(
        children: [
          Expanded(child: ListView(),),
          Container()
        ],
      ),
      
    );
  }
}