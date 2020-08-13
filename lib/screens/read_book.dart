import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:clamer/screens/display_pdf.dart';


class ReadBook extends StatefulWidget {
  @override
  _ReadBookState createState() => _ReadBookState();
}

class _ReadBookState extends State<ReadBook> {
  void _sendData(BuildContext context) {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.blueAccent[100],

        body: StreamBuilder(
          stream: Firestore.instance.collection("clamer_books").snapshots(),
          builder: (context, snapshot) {
            if (snapshot.data == null) return CircularProgressIndicator();
            return ListView.builder(
              itemBuilder: (context, index) {
                DocumentSnapshot books = snapshot.data.documents[index];
                return GestureDetector(
                  onTap: () {
                    String pdfUrl = books['bookPdf'];
                    String pdfName = books['bookName'];

                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => display_pdf(
                                  file: pdfUrl,
                                  fileName: pdfName,
                                  coverBook: books['cover'],
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
                                        placeholder: "assets/book_placeholder.png",
                                        image: books['cover'])),
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
                                                    books['bookName'],
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
                                                        books["author"],
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
