import 'package:flutter/material.dart';
import 'package:clamer/screens/downloadedPdf.dart';
import 'package:clamer/screens/read_book.dart';

class tabs extends StatefulWidget {
  @override
  _tabsState createState() => _tabsState();
}

class _tabsState extends State<tabs> {
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
          title: Text("Books to read",  style: TextStyle(
              color: Colors.blue[500],
              fontSize: 25,
              fontStyle: FontStyle.italic
          ),),
          bottom: TabBar( labelColor: Colors.black,tabs: [
            Tab(text: "Offline Book", ),
            Tab(text: "to be read",)
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
