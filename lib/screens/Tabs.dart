import 'package:flutter/material.dart';
import 'package:clamer/screens/display_pdf.dart';
import 'package:clamer/screens/downloadedPdf.dart';
import 'package:clamer/screens/read_book.dart';

class Tabs extends StatefulWidget {
  @override
  _TabsState createState() => _TabsState();
}

class _TabsState extends State<Tabs> {
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
          title: Text("Books To Read",  style: TextStyle(
              color: Colors.blue[500],
              fontSize: 25,
              fontStyle: FontStyle.italic
          ),),
          bottom: TabBar( labelColor: Colors.black,tabs: [
            Tab(text: "Downloaded book", ),
            Tab(text: "to be downloaded",)
          ]),
        ),
        body: TabBarView(
            children: [
              DownloadedPDF(),
              ReadBook(),
            ]
        ),
      ),
    );
  }
}
