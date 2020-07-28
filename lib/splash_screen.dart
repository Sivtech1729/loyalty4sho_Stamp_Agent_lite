import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutterbarberagent/dash_board.dart';
import 'auth.dart';

class SplashScreenPage extends StatefulWidget {
  @override
  _SplashScreenState createState() => new _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreenPage> {

  startTime() async {
    var _duration = new Duration(seconds: 2);
    return new Timer(_duration, navigationPage);
  }

  void navigationPage() {
    Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(
      builder: (context) => LoginAndSignupPage(),
    ),  (Route<dynamic> route)=>false);
  }

  @override
  void initState() {
    super.initState();
    startTime();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      color: Colors.white,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            child: CircleAvatar(
              child: Text(
                "Logo",
              ),
              radius: 40,
              backgroundColor: Colors.black,
            ),
            padding: EdgeInsets.all(5),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
            ),
          ),
          Text('Loyalty-Stamp', style: TextStyle(
              color: Colors.black, fontSize: 25, fontWeight: FontWeight.bold),)
        ],
      ),
    ),);
  }
}
