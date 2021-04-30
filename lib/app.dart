import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:twitter_one_person_app/api/auth_notifier.dart';
import 'package:twitter_one_person_app/views/screens/feed.dart';
import 'package:twitter_one_person_app/views/screens/login.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Coding with Curry',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        accentColor: Colors.lightBlue,
      ),
      home: Consumer<AuthNotifier>(
        builder: (context, notifier, child) {
          return notifier.user != null ? Feed() : Login();
        },
      ),
    );
  }
}
