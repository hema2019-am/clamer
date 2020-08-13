
import 'package:clamer/screens/Tabs.dart';
import 'package:flutter/material.dart';
import 'package:clamer/screens/Home.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:clamer/screens/read_book.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:clamer/screens/Music.dart';
import 'package:clamer/screens/Texting.dart';

import 'screens/MusicAlways.dart';

class MyBackground extends StatelessWidget {

  final String image;
  final String pageName;

  const MyBackground({
    Key key,
    this.image,
    this.pageName,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        navigateToPage(context, pageName);
      },
      child: ClipPath(
        clipper: MyClipper(),
        child: Container(
          height: 200,
          width: double.infinity,
          decoration: BoxDecoration(

            borderRadius: BorderRadius.circular(5.0),
            border: Border.all(color: Colors.black),
            gradient: LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              colors: [
                Color(0xFF3383CD),
                Color(0xFF11249F),
              ],
            ),
          ),

          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[

              Expanded(

                    child: SvgPicture.asset("$image", width: 200),

              ),
            ],
          ),



          ),
        ),
    );

  }
}

navigateToPage(context,String pageName ) async{
  switch(pageName){
    case 'ReadBook' :  Navigator.push(context, MaterialPageRoute(builder:(context) => Tabs()));
    break;
    case 'Music' : Navigator.push(context, MaterialPageRoute(builder: (context) => MusicAlways()));
    break;
    case 'Texting' : Navigator.push(context, MaterialPageRoute(builder: (context) => Texting()));
    break;


  }
}
