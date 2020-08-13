
import 'package:flutter/material.dart';
import 'package:clamer/screens/Home.dart';
import 'package:splashscreen/splashscreen.dart';


void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,

      home: Splash(),
    );
  }
}

class Splash extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SplashScreen(
      seconds: 6,
      navigateAfterSeconds: new Home(),

      image: new Image.asset("assets/icon.png"),
      loadingText: Text("Loading"),
      photoSize: 100.0,
      loaderColor: Colors.blue,
      backgroundColor: Colors.cyan[200],
    );
  }
}


