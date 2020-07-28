import 'package:flutter/material.dart';
import 'package:flutterbarberagent/auth.dart';
import 'package:flutterbarberagent/splash_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dash_board.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  var email = prefs.getString('email');
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: email == null ? SplashScreenPage() : DashBoard(),
    ),
  );
}
