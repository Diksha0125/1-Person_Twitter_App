import 'package:flutter/material.dart';
import 'package:twitter_one_person_app/view/HomePage.dart';
import 'package:twitter_one_person_app/view/Login.dart';
import 'package:twitter_one_person_app/view/SignUp.dart';
import 'package:twitter_one_person_app/view/Start.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(),
      debugShowCheckedModeBanner: false,
      home: HomePage(),
      routes: <String, WidgetBuilder>{
        "Login": (BuildContext context) => Login(),
        "SignUp": (BuildContext context) => SignUp(),
        "start": (BuildContext context) => Start(),
        "home": (BuildContext context) => HomePage(),
      },
    );
  }
}
