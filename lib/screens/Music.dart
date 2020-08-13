import 'dart:io';

import 'package:clamer/screens/display_music.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';



class Music extends StatefulWidget {
  @override
  _MusicState createState() => _MusicState();
}

class _MusicState extends State<Music> {




  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.blueAccent[100],


        body: StreamBuilder(
          stream: Firestore.instance.collection("clamer_music").snapshots(),
          builder: (context, snapshot) {
            if (snapshot.data == null) return CircularProgressIndicator();
            return ListView.builder(
              itemBuilder: (context, index) {
                DocumentSnapshot music = snapshot.data.documents[index];
                return GestureDetector(
                  onTap: () {
                    String music_path = music['music_path'];
                    String music_name = music['music_name'];


                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => display_music(
                             music_name: music_name,
                              music_path: music_path,
                              music_cover: music['music_cover'],
                            )));
                  },
                  child: Card(
                      elevation: 0.0,
                      color: Colors.blue,
                      child: Padding(
                          padding: const EdgeInsets.all(0.0),
                          child: SizedBox(
                            height: MediaQuery.of(context).size.height * 0.15,
                            width: MediaQuery.of(context).size.width,
                            child: Card(
                              elevation: 0,
                              child: Row(children: <Widget>[
                                new Container(
                              height:
                              MediaQuery.of(context).size.width * 0.3,
                                width:
                                MediaQuery.of(context).size.width * 0.3,
                                 child: FadeInImage.assetNetwork(
                                  placeholder: "assets/headphones_placeholder.png",
                                  image: music['music_cover'] ),

//                                 ),
                                ),
                                Padding(
                                    padding: const EdgeInsets.only(
                                        left: 10, right: 5, top: 5),
                                    child: Column(
                                      mainAxisAlignment:
                                      MainAxisAlignment.start,
                                      children: <Widget>[
                                        new Container(
                                          child: Column(
                                            mainAxisAlignment:
                                            MainAxisAlignment.start,
                                            children: <Widget>[
                                              Column(
                                                mainAxisAlignment:
                                                MainAxisAlignment.start,
                                                crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                                children: <Widget>[
                                                  Text(
                                                    music['music_name'],
                                                    style: TextStyle(
                                                      fontWeight:
                                                      FontWeight.w500,
                                                      fontSize: 20,
                                                    ),
                                                  ),
                                                  SizedBox(height: 10.0),
                                                  Row(
                                                    children: <Widget>[
                                                      Text(
                                                        music['Artist'],
                                                        style: TextStyle(
                                                            fontWeight:
                                                            FontWeight.w700,
                                                            color:
                                                            Colors.black26),
                                                      )
                                                    ],
                                                  )
                                                ],
                                              )
                                            ],
                                          ),
                                        ),
                                      ],
                                    )),
                              ]),
                            ),
                          ))),
                );
              },
              itemCount: snapshot.data.documents.length ?? [],
            );
          },
        ));

  }
}
