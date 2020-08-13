import 'dart:io';

import 'package:clamer/screens/Music.dart';
import 'package:clamer/screens/display_music.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';


class downloadedMusic extends StatefulWidget {
  @override
  _downloadedMusicState createState() => _downloadedMusicState();
}

class _downloadedMusicState extends State<downloadedMusic> {


  var files;
  List<FileSystemEntity> _files;
  List<FileSystemEntity> _musicFiles = [] ;


  @override
  void initState() {
    super.initState();
    getFiles();
  }

  void getFiles() async {
    Directory dir = await getApplicationDocumentsDirectory();


    // different method
//    var fm = FileManager(root: Directory(txtPath));
//    files = await fm.filesTree(
//        extensions: ["txt"]
//    );
//    setState(() {
//
//    });

    _files = dir.listSync(recursive: true, followLinks: false);
    for (FileSystemEntity entity in _files) {
      String path = entity.path;
      if (path.endsWith('.mp3')) _musicFiles.add(entity);
    }

    setState(() {});

    print(_musicFiles);
    print(_musicFiles.length);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueAccent[100],
      body: _musicFiles.length < 1
          ? Text("no music")
          : ListView.builder(
          itemCount: _musicFiles.length,

          itemBuilder: (context, i)
          {
            String path = _musicFiles
                .elementAt(i)
                .path
                .split("/")
                .removeLast();

            return GestureDetector(
              onTap: (){

                String MusicUrl = _musicFiles.elementAt(i).path;
                String MusicName = path.substring(0, path.lastIndexOf('.')) ;

                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => display_music(
                          music_path: MusicUrl,
                          music_name: MusicName,
                          music_cover: "",
                )));
              },
              child: Container(
                child: Card(
                    elevation: 0.0,
                    color: Colors.blue,
                    child: Padding(
                        padding: const EdgeInsets.all(0.0),
                        child: SizedBox(
                          height: MediaQuery
                              .of(context)
                              .size
                              .height * 0.15,
                          width: MediaQuery
                              .of(context)
                              .size
                              .width,
                          child: Card(
                            elevation: 0,

                            child: Row(
mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: <Widget>[
                                  new Container(
                                    height:
                                    MediaQuery
                                        .of(context)
                                        .size
                                        .width * 0.2,
                                    width:
                                    MediaQuery
                                        .of(context)
                                        .size
                                        .width * 0.2,
                                    child: Image.asset("assets/headphones_placeholder.png"),
                                  ),
                                  Padding(
                                      padding: const EdgeInsets.only(
                                          left: 5, right: 5, top: 15),
                                      child: Column(
                                        mainAxisAlignment:
                                        MainAxisAlignment.start,
                                        children: <Widget>[
                                          Text(
                                            path.substring(0, path.lastIndexOf('.')),
                                            style: TextStyle(
                                              fontWeight:
                                              FontWeight.w500,
                                              fontSize: 20,
                                            ),
                                          ),
                                        ],
                                      )),
                                  Container(
                                    width: 50.0,
                                    height: 50.0,
                                    child: new RawMaterialButton(
                                      shape: new CircleBorder(),
                                      elevation: 0.0,
                                      child: Icon(
                                        Icons.delete,
                                        color: Colors.blue,
                                      ),
                                      onPressed: () {
                                        File file = new File(
                                            _musicFiles.elementAt(i).path);
                                        file.delete();
                                        _musicFiles = List.from(_musicFiles)
                                          ..removeAt(i);

                                        setState(() {});
                                      },
                                    ),
                                  )
                                ]),
                          ),
                        ))),
              ),
            );}),
    );
  }
}
