import 'dart:collection';

import 'package:flutter/cupertino.dart';
import 'package:twitter_one_person_app/model/tweets.dart';

class TweetNotifier with ChangeNotifier {
  List<Tweets> _tweetList = [];
  Tweets _currentTweet;

  UnmodifiableListView<Tweets> get tweetList =>
      UnmodifiableListView(_tweetList);

  Tweets get currentTweet => _currentTweet;

  set tweetList(List<Tweets> tweetList) {
    _tweetList = tweetList;
    notifyListeners();
  }

  set currentTweet(Tweets tweets) {
    _currentTweet = tweets;
    notifyListeners();
  }

  addTweet(Tweets tweets) {
    _tweetList.insert(0, tweets);
    notifyListeners();
  }

  deleteTweet(Tweets tweets) {
    _tweetList.removeWhere((_tweet) => _tweet.id == tweets.id);
    notifyListeners();
  }
}
