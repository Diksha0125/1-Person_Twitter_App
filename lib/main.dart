import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:twitter_one_person_app/api/tweet_notifier.dart';
import 'package:twitter_one_person_app/app.dart';

import 'api/auth_notifier.dart';

void main() => runApp(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (context) => AuthNotifier(),
          ),
          ChangeNotifierProvider(
            create: (context) => TweetNotifier(),
          ),
        ],
        child: MyApp(),
      ),
    );
