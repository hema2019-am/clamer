import 'dart:io';
import 'dart:async';



import 'package:flutter/material.dart';

import 'package:fluttertoast/fluttertoast.dart';

import 'package:path_provider/path_provider.dart';

import 'package:http/http.dart' as http;


import 'package:clamer/screens/PDFScreen.dart';

class display_pdf extends StatefulWidget {
  final String file;
  final String fileName;

  final String coverBook;

  const display_pdf({Key key, this.file, this.fileName, this.coverBook})
      : super(key: key);

  @override
  _display_pdfState createState() => _display_pdfState();
}

class _display_pdfState extends State<display_pdf> {
  String pdfAtDisk = "";
  String pdfAtStorage = "";
  bool filePresent = false;
  List<FileSystemEntity> _files;
  List<FileSystemEntity> _textFiles = [];
  bool _isInternet = true;


  var files;

  @override
  void initState() {
    super.initState();
    checkInternet();

    getFileFromUrl(widget.file).then((f) {

        pdfAtDisk = f.path;
        print(pdfAtDisk);

    });

    getFromDirectory();
  }

  void getFromDirectory() async {
    try {
      Directory dir = await getApplicationDocumentsDirectory();
      String file = "${dir.path}/${widget.fileName}.pdf";
      print(file);

      _files = dir.listSync(recursive: true, followLinks: false);
      for (FileSystemEntity entity in _files) {
        String path = entity.path;
        if (path.endsWith("${widget.fileName}.pdf")) {
          _textFiles.add(entity);
          filePresent = true;
        }
      }


    } catch (e) {
      print(e);
    }
  }

  Future<File> getFileFromUrl(String url,) async {
    try {
      var data = await http.get(url);
      var bytes = data.bodyBytes;
      var dir = await getApplicationDocumentsDirectory();
      File file = File("${dir.path}/${widget.fileName}.pdf");

      File urlFile = await file.writeAsBytes(bytes);
      return urlFile;
    } catch (e) {
      throw Exception("Error opening url file");
    }

  }

  checkInternet() async {
    try {
      final response = await InternetAddress.lookup("example.com");
      if (response.isNotEmpty && response[0].rawAddress.isNotEmpty) {
        _isInternet = true;
        setState(() {

        });
      }
    } on SocketException catch (_) {
      _isInternet = false;
      setState(() {

      });
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.blueAccent[100],
        appBar: AppBar(
          leading: BackButton(
            color: Colors.black,
          ),
          backgroundColor: Colors.blue[100],
          elevation: 0,
          title: Text(
            widget.fileName,
            style: TextStyle(
                color: Colors.blue[500],
                fontSize: 25,
                fontStyle: FontStyle.italic),
          ),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            new Container(
              color: Colors.blueAccent[100],
              margin: EdgeInsets.only(left: 40),
              height: 500,
              width: 300,
              child: FadeInImage.assetNetwork(
                image: widget.coverBook,
                placeholder: "assets/book_placeholder.png",
              ),
            ),
            FlatButton(
              color: Colors.blue[500],
              onPressed: () {
                setState(() {
                  if (filePresent == true) {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                PDFScreen(
                                  title: widget.fileName,
                                  pdfPath: _textFiles[0].path,
                                )));
                    print("this worke");
                  } else {
                    if (_isInternet) {
                      Fluttertoast.showToast(
                          msg: "please wait to display the book",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.BOTTOM,
                          timeInSecForIosWeb: 1,
                          backgroundColor: Colors.blueAccent[400],
                          textColor: Colors.white);

                      Timer(Duration(seconds: 5), () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    PDFScreen(
                                      title: widget.fileName,
                                      pdfPath: pdfAtDisk,
                                    ),));
                        print("this");
                      });
                    } else {
                      showDialog(context: context, builder: (context) =>
                          AlertDialog(title: Text("No Internet"),
                            content: Text("Connect to intenet"),
                            actions: [
                              FlatButton(
                                  child: Text("Retry"),
                                  onPressed: () {
                                    Navigator.pop(context);
                                  }
                              )
                            ],));
                      setState(() {
                        checkInternet();
                      });
                    }
                  }
                });
              },
              child: _textFiles.length != 0
                  ? Text(
                "Open Book",
                style: TextStyle(fontSize: 20),
              )
                  : Text(
                "Download Book",
                style: TextStyle(fontSize: 20),
              ),
            ),
          ],
        ));
  }


}