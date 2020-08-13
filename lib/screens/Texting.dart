import 'dart:io';

import 'package:clamer/screens/Home.dart';
import 'package:flutter/material.dart';

import 'package:path_provider/path_provider.dart';

import 'package:clamer/screens/WrirtingText.dart';
import 'package:flutter/foundation.dart';

class Texting extends StatefulWidget {
  @override
  _TextingState createState() => _TextingState();
}

class _TextingState extends State<Texting> {
  var files;
  List<FileSystemEntity> _files;
  List<FileSystemEntity> _textFiles = [];

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
      if (path.endsWith('.txt')) _textFiles.add(entity);

    }

    setState(() {});

    print(_textFiles);
    print(_textFiles.length);
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      backgroundColor: Colors.blueAccent[100],
      appBar: AppBar(
        backgroundColor: Colors.blue[100],
        elevation: 0,
        leading: BackButton(
          color: Colors.black,
        ),
        title: Text("Minding"
        , style: TextStyle(
              color: Colors.blue[500],
              fontSize: 25,
              fontStyle: FontStyle.italic
          ),),
      ),
      body: Column(
        children: [
          Container(
            height: 590,
            child: Container(
              child: _textFiles == null
                  ? CircularProgressIndicator()
                  : ListView.builder(
                      padding: const EdgeInsets.all(16.0),
                      itemCount: _textFiles.length,
                      itemBuilder: (context, i) {
                        String path = _textFiles
                            .elementAt(i)
                            .path
                            .split("/")
                            .removeLast();

                        return Card(
                          color: Colors.blue,
                            child: Card(
                              child: ListTile(

                          title: new Text(
                                path.substring(0, path.lastIndexOf('.'))),
                          leading: Icon(Icons.insert_drive_file),
                          trailing: Icon(Icons.arrow_right),
                          onLongPress: () {
                              File file = new File(_textFiles.elementAt(i).path);
                              showDialog(context: context,
                               builder: (BuildContext context){
                                return  AlertDialog(
                                    title: new Text('do you want to delete'),
                                    actions: <Widget>[
                                      FlatButton(
                                        child: new Text("OK"),
                                        onPressed: () {



                                          setState(() {
                                             file.delete();
                                             _textFiles = List.from(_textFiles)..removeAt(i);
                                             Navigator.of(context).pop();
                                          });


                                        },
                                      ),
                                      FlatButton(
                                        child: new Text("Close"),
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                      )

                                    ]);
                               });

                          },
                          onTap: () {
                              setState(() {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => WritingText(
                                              fileName:
                                                  _textFiles.elementAt(i).path,
                                            )));

                              });


                          },
                        ),
                            ));
                      }),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: FlatButton.icon(
                onPressed: () {
                  setState(() {
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (context) => WritingText()));

                  });


                },

                icon: Icon(Icons.pages),
                label: Text("lets writes")),
          )
        ],
      ),
    );
  }
}
