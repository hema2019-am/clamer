import 'dart:io';

import 'package:clamer/screens/display_pdf.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';

class PDFScreen extends StatefulWidget {
  final String title;
  final String pdfPath;

  const PDFScreen({Key key, this.title, this.pdfPath}) : super(key: key);

  @override
  _PDFScreenState createState() => _PDFScreenState();
}

class _PDFScreenState extends State<PDFScreen> {
  int _totalPages = 0;

  bool pdfReady = false;
  PDFViewController _pdfViewController;
  int _currentPage = 0;

  File file;
  TextEditingController textController = TextEditingController();
  String pageNumber;
  int pages;

  @override
  void initState() {
    super.initState();

    file = File(widget.pdfPath);
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
          widget.title,
          style: TextStyle(
              color: Colors.blue[500],
              fontSize: 25,
              fontStyle: FontStyle.italic),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text("Page number: $_currentPage"),

                    Container(
                      width: 70,

                      child: FloatingActionButton (

                        child: Text("Go to",
                        ),

                      onPressed: (){
                           setState(() {
                             if(pages > _totalPages){



                                 showDialog(context: context, builder: (context) =>
                                     AlertDialog(content: Text("Not correct page number"),
                                       actions: [
                                         RaisedButton(

                                           onPressed: () {
                                             Navigator.pop(context);
                                             _currentPage = 0;

                                           }, child: Text("close"),



                                         )
                                       ],
                                     )

                                 );

                             }else {
                               _currentPage = pages;
                               setState(() {

                               });
                             }
                           });

                      }),
                    ),

                    Container(
                      width: 65,
                      height: 50,
                      color: Colors.white,
                      margin: EdgeInsets.all(6),
                      child: TextField(

                        maxLength: 3,
                        keyboardType: TextInputType.number,
                        controller: textController,
                        decoration: InputDecoration(

                          border: OutlineInputBorder(),


                        ),
                        onChanged: (text) {
                          setState(() {

                            pageNumber= textController.text;
                            pages = int.parse(pageNumber);




                          });
                         
                        },

                      ),
                    ),
                  ],
                ),
              ),

              Container(
                margin: EdgeInsets.only(top: 10),
                height: 500,
                child: Stack(
                  children: <Widget>[
                    PDFView(
                      filePath: file.path,
                      autoSpacing: true,
                      enableSwipe: false,
                      swipeHorizontal: false,
                      pageSnap: true,
                      nightMode: false,
                      onError: (e) {
                        print(e);
                      },
                      onRender: (_pages) {
                        setState(() {
                          _totalPages = _pages;
                          pdfReady = true;
                        });
                      },
                      onViewCreated: (PDFViewController vc) {
                        setState(() {
                          _pdfViewController = vc;
                        });
                      },
                      onPageChanged: (int page, int total) {
                        setState(() {
                          if(_currentPage > _totalPages) {
                            showDialog(context: context, builder: (context) =>
                                AlertDialog(content: Text("Not correct page nunber"),
                                  actions: [
                                    FloatingActionButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                          Text("Close");
                                        }
                                    )
                                  ],
                                )

                            );
                            _currentPage = 0;
                            setState(() {

                            });
                          }else{
                            _pdfViewController.setPage(_currentPage);
                          }
                        });
                      },
                      onPageError: (page, e) {},
                    ),
                    !pdfReady
                        ? Center(
                            child: CircularProgressIndicator(),
                          )
                        : Offstage()
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          _currentPage > 0
              ? FloatingActionButton.extended(
                  onPressed: () {
                    setState(() {
                      _currentPage -= 1;
                      _pdfViewController.setPage(_currentPage);
                    });
                  },
                  icon: Icon(Icons.arrow_left),
                  label: Text("${_currentPage - 1} / $_totalPages "),
                  backgroundColor: Colors.blue,
                )
              : Offstage(),
          _currentPage + 1 < _totalPages
              ? FloatingActionButton.extended(
                  onPressed: () {
                    setState(() {
                      _currentPage += 1;
                      _pdfViewController.setPage(_currentPage);
                    });
                  },
                  icon: Icon(Icons.arrow_right),
                  backgroundColor: Colors.blue,
                  label: Text("${_currentPage + 1} / $_totalPages "),
                )
              : Offstage(),
        ],
      ),
    );
  }
}
