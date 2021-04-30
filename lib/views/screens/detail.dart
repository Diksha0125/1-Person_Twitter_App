import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:twitter_one_person_app/api/tweet_api.dart';
import 'package:twitter_one_person_app/api/tweet_notifier.dart';
import 'package:twitter_one_person_app/model/tweets.dart';
import 'package:twitter_one_person_app/styles.dart';

import 'tweet_form.dart';

class TweetDetail extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    TweetNotifier tweetNotifier = Provider.of<TweetNotifier>(context);

    _onFoodDeleted(Tweets tweet) {
      Navigator.pop(context);
      tweetNotifier.deleteTweet(tweet);
    }

    return Scaffold(
      backgroundColor: Colors.grey[800],
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        brightness: Brightness.light,
        elevation: 1,
      ),
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            children: <Widget>[
              Container(
                padding: EdgeInsets.only(top: 20, left: 60, right: 60),
                child: Image.network(
                  tweetNotifier.currentTweet.image != null
                      ? tweetNotifier.currentTweet.image
                      : 'https://www.testingxperts.com/wp-content/uploads/2019/02/placeholder-img.jpg',
                  width: MediaQuery.of(context).size.width,
                  height: 250,
                  fit: BoxFit.fitWidth,
                ),
              ),
              Text(
                '${tweetNotifier.currentTweet.description}',
                style: TwitterTextStyle.heading5,
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          FloatingActionButton(
            heroTag: 'button1',
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (BuildContext context) {
                  return TweetForm(
                    isUpdating: true,
                  );
                }),
              );
            },
            child: Icon(Icons.edit),
            foregroundColor: Colors.white,
          ),
          SizedBox(width: 10),
          FloatingActionButton(
            heroTag: 'button2',
            onPressed: () {
              deleteTweet(tweetNotifier.currentTweet, _onFoodDeleted);
            },
            child: Icon(Icons.delete),
            backgroundColor: Colors.red,
            foregroundColor: Colors.white,
          ),
        ],
      ),
    );
  }
}
