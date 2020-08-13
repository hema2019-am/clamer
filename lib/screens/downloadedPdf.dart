import 'dart:io';

import 'package:clamer/screens/display_pdf.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

class DownloadedPDF extends StatefulWidget {
  @override
  _DownloadedPDFState createState() => _DownloadedPDFState();
}

class _DownloadedPDFState extends State<DownloadedPDF> {
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
      if (path.endsWith('.pdf')) _textFiles.add(entity);
    }

    setState(() {});

    print(_textFiles);
    print(_textFiles.length);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueAccent[100],
      body: _textFiles.length < 1
          ? Text("no books to read")
          : ListView.builder(
              itemCount: _textFiles.length,
              itemBuilder: (context, i) {
                String path =
                    _textFiles.elementAt(i).path.split("/").removeLast();

                return GestureDetector(
                  onTap: () {
                    String pdfUrl = _textFiles.elementAt(i).path;
                    String pdfName = path.substring(0, path.lastIndexOf('.'));

                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => display_pdf(
                                  file: pdfUrl,
                                  fileName: pdfName,
                                  coverBook: "book_placeholder.png",
                                )));
                  },
                  child: Container(
                    child: Card(
                        elevation: 0.0,
                        color: Colors.blue,
                        child: Padding(
                            padding: const EdgeInsets.all(0.0),
                            child: SizedBox(
                              height: MediaQuery.of(context).size.height * 0.15,
                              width: MediaQuery.of(context).size.width * 0.5,
                              child: Card(
                                elevation: 0,
                                child: Row(children: <Widget>[
                                  new Container(
                                    height:
                                        MediaQuery.of(context).size.width * 0.2,
                                    width:
                                        MediaQuery.of(context).size.width * 0.2,
                                    child: Image.asset(
                                        "assets/book_placeholder.png"),
                                  ),
                                  Padding(
                                      padding: const EdgeInsets.only(
                                          left: 20, right: 5, top: 15),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: <Widget>[
                                          Text(
                                            path.substring(
                                                0, path.lastIndexOf('.')),
                                            style: TextStyle(
                                              fontWeight: FontWeight.w500,
                                              fontSize: 18,
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
                                            _textFiles.elementAt(i).path);
                                        file.delete();
                                        _textFiles = List.from(_textFiles)
                                          ..removeAt(i);

                                        setState(() {});
                                      },
                                    ),
                                  )
                                ]),
                              ),
                            ))),
                  ),
                );
              }),
    );
  }
}
