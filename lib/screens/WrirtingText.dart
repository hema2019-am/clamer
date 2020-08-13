import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:path_provider/path_provider.dart';
import 'package:clamer/screens/Texting.dart';

class WritingText extends StatefulWidget {
  final String fileName;

  const WritingText({Key key, this.fileName}) : super(key: key);

  @override
  _WritingTextState createState() => _WritingTextState();
}

class _WritingTextState extends State<WritingText> {
  TextEditingController textController = TextEditingController();
  TextEditingController titleController = TextEditingController();
  String message = '';
  String title;

  _write(String text) async {
    final Directory directory = await getApplicationDocumentsDirectory();
    title = message.substring(0, 3);
    final File file = File('${directory.path}/ $title.txt');
    await file.writeAsString(text);
  }

  Future<String> _read() async {
    try {
      final File file = File(widget.fileName);
      message = file.readAsStringSync();
      title = widget.fileName.split('.txt').removeLast();
      textController.text = message;
      titleController.text = title;
    } catch (e) {}

    return message;
  }

  @override
  void initState() {
    _read();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueAccent[100],
      appBar: AppBar(
        backgroundColor: Colors.blue[100],
        leading: BackButton(
          color: Colors.black,
        ),
        title: Text(
          "write you thoughts",
          style: TextStyle(
              color: Colors.blue[500],
              fontSize: 25,
              fontStyle: FontStyle.italic),
        ),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Container(
                color: Colors.white,
                margin: EdgeInsets.all(6),
                child: TextField(
                  maxLines: 28,
                  controller: textController,
                  decoration: InputDecoration(

                    border: OutlineInputBorder(),

                  ),
                  onChanged: (text) {
                    setState(() {
                      message = textController.text;
                    });
                  },
                ),
              ),
              Container(
                child: RaisedButton.icon(
                  color: Colors.blue[200],
                    icon: Icon(Icons.save),
                    label: Text('Save'),
                    onPressed: () {
                      setState(() {
                        _write(message);
                        Fluttertoast.showToast(
                            msg: "Saved",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.BOTTOM,
                            timeInSecForIosWeb: 1,
                            backgroundColor: Colors.cyan[500],
                            textColor: Colors.white);

                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => Texting(),
                            ));
                      });
                    }),
              )
            ],
          ),
        ),
      ),
    );
  }
}
