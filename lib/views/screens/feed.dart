import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:twitter_one_person_app/api/auth_notifier.dart';
import 'package:twitter_one_person_app/api/tweet_api.dart';
import 'package:twitter_one_person_app/api/tweet_notifier.dart';
import 'package:twitter_one_person_app/colors.dart';
import 'package:twitter_one_person_app/styles.dart';
import 'package:twitter_one_person_app/views/screens/detail.dart';
import 'package:twitter_one_person_app/views/screens/tweet_form.dart';

class Feed extends StatefulWidget {
  @override
  _FeedState createState() => _FeedState();
}

class _FeedState extends State<Feed> {
  @override
  void initState() {
    TweetNotifier tweetNotifier =
        Provider.of<TweetNotifier>(context, listen: false);
    gettweetss(tweetNotifier);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    AuthNotifier authNotifier = Provider.of<AuthNotifier>(context);
    TweetNotifier tweetNotifier = Provider.of<TweetNotifier>(context);

    Future<void> _refreshList() async {
      gettweetss(tweetNotifier);
    }

    final appBar = AppBar(
      backgroundColor: Colors.transparent,
      brightness: Brightness.light,
      elevation: 1,
      title: Text(
        authNotifier.user != null ? authNotifier.user.displayName : "Tweets",
      ),
      actions: <Widget>[
        // action button
        FlatButton(
          onPressed: () => signout(authNotifier),
          child: Icon(Icons.logout, color: white),
        ),
      ],
    );

    final floatingActionButton = FloatingActionButton(
      onPressed: () {
        tweetNotifier.currentTweet = null;
        Navigator.of(context).push(
          MaterialPageRoute(builder: (BuildContext context) {
            return TweetForm(isUpdating: false);
          }),
        );
      },
      child: Icon(Icons.add),
      foregroundColor: Colors.white,
    );

    final body = RefreshIndicator(
      child: ListView.separated(
        itemCount: tweetNotifier.tweetList.length,
        separatorBuilder: (BuildContext context, int index) {
          return Divider(color: white, indent: 10, endIndent: 10);
        },
        itemBuilder: (BuildContext context, int index) {
          return ListTile(
            leading: CircleAvatar(radius: 26),
            title: Padding(
              padding: EdgeInsets.all(10.0),
              child: Text(
                tweetNotifier.tweetList[index].description,
                style: TwitterTextStyle.heading5,
              ),
            ),
            subtitle: tweetNotifier.tweetList[index].image != null
                ? Image.network(
                    tweetNotifier.tweetList[index].image,
                    width: 120,
                    fit: BoxFit.fitWidth,
                  )
                : Container(),
            onTap: () {
              tweetNotifier.currentTweet = tweetNotifier.tweetList[index];
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (BuildContext context) {
                return TweetDetail();
              }));
            },
          );
        },
      ),
      onRefresh: _refreshList,
    );

    return Scaffold(
        backgroundColor: Colors.grey[800],
        appBar: appBar,
        body: body,
        floatingActionButton: floatingActionButton);
  }
}
