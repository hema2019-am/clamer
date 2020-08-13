import 'package:clamer/screens/Music.dart';
import 'package:clamer/screens/downloadedMusic.dart';
import 'package:flutter/material.dart';

class MusicAlways extends StatefulWidget {
  @override
  _MusicAlwaysState createState() => _MusicAlwaysState();
}

class _MusicAlwaysState extends State<MusicAlways> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          leading: BackButton(
            color: Colors.black,
          ),
          backgroundColor: Colors.blue[100],
          elevation: 0,
          title: Text("Music",  style: TextStyle(
              color: Colors.blue[500],
              fontSize: 25,
              fontStyle: FontStyle.italic
          ),),
          bottom: TabBar( labelColor: Colors.black,tabs: [
            Tab(text: "Downloaded Music", ),
            Tab(text: "to be downloaded",)
          ]),
        ),
        body: TabBarView(
            children: [
             downloadedMusic(),
              Music(),
            ]
        ),
      ),
    );
  }
}
