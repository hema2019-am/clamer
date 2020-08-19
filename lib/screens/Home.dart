import 'dart:io';

import 'package:flutter/material.dart';
import 'package:carousel_pro/carousel_pro.dart';
import 'package:clamer/back.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:permission_handler/permission_handler.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Map<PermissionGroup, PermissionStatus> permissions;

  @override
  void initState() {
    super.initState();
    getPermission();

    checkInternet();
  }

  checkInternet() async {
    try {
      final response = await InternetAddress.lookup("example.com");
      if (response.isNotEmpty && response[0].rawAddress.isNotEmpty) {
        setState(() {});
      }
    } on SocketException catch (_) {
      _showAlert(context);
      setState(() {});
    }
  }

  void getPermission() async {
    permissions = await PermissionHandler().requestPermissions([

      PermissionGroup.storage,
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.blueAccent[100],
        appBar: AppBar(
          backgroundColor: Colors.blue[100],
          elevation: 0,
          title: Text(
            'Calmer',
            style: TextStyle(
                color: Colors.blue[500],
                fontSize: 25,
                fontStyle: FontStyle.italic),
          ),
        ),
        body: SingleChildScrollView(
          child: Container(
            child: Container(
              child: Column(
                children: <Widget>[
                  SizedBox(
                    height: 180.0,
                    width: double.infinity,
                    child: Carousel(
                      images: [
                        SvgPicture.asset("assets/boy_wrirting.svg"),
                        SvgPicture.asset('assets/man_music.svg'),
                        SvgPicture.asset('assets/girl_raeding.svg'),
                      ],
                      dotColor: Colors.blue,
                    ),
                  ),
                  Container(
                    child: Column(
                      children: <Widget>[
                        SizedBox(
                          height: 10,
                        ),
                        MyBackground(
                          image: 'assets/book.svg',
                          pageName: 'ReadBook',
                        ),
                        MyBackground(
                          image: 'assets/headphone.svg',
                          pageName: 'Music',
                        ),
                        MyBackground(
                          image: 'assets/scribble_thumb.svg',
                          pageName: 'Texting',
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ));
  }

  _showAlert(BuildContext context) => showDialog(
      context: context,
      builder: (context) => AlertDialog(
            title: Text("No Internet"),
            content: Text(
                "Please Connect to internet, if you have now downloaded any book or music\nBut, downloaded so enjoy"),
            actions: [
              FlatButton(
                  child: Text("close"),
                  onPressed: () {
                    Navigator.pop(context);
                  })
            ],
          ));
}

class MyClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.lineTo(0, size.height - 80);
    path.quadraticBezierTo(
        size.width / 2, size.height, size.width, size.height - 80);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    // TODO: implement shouldReclip
    return false;
  }
}
