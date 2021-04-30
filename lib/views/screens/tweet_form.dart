import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:twitter_one_person_app/api/tweet_api.dart';
import 'package:twitter_one_person_app/api/tweet_notifier.dart';
import 'package:twitter_one_person_app/colors.dart';
import 'package:twitter_one_person_app/model/tweets.dart';
import 'package:twitter_one_person_app/styles.dart';

class TweetForm extends StatefulWidget {
  final bool isUpdating;

  TweetForm({@required this.isUpdating});

  @override
  _TweetFormState createState() => _TweetFormState();
}

class _TweetFormState extends State<TweetForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  Tweets _currentTweet;
  String _imageUrl;
  File _imageFile;

  @override
  void initState() {
    super.initState();
    TweetNotifier tweetNotifier =
        Provider.of<TweetNotifier>(context, listen: false);

    if (tweetNotifier.currentTweet != null) {
      _currentTweet = tweetNotifier.currentTweet;
    } else {
      _currentTweet = Tweets();
    }
    _imageUrl = _currentTweet.image;
  }

  _showImage() {
    if (_imageFile == null && _imageUrl == null) {
      return Text(
        "image placeholder",
        style: TwitterTextStyle.heading6,
      );
    } else if (_imageFile != null) {
      print('showing image from local file');

      return Stack(
        alignment: AlignmentDirectional.bottomCenter,
        children: <Widget>[
          Image.file(
            _imageFile,
            fit: BoxFit.cover,
            height: 250,
          ),
          FlatButton(
            padding: EdgeInsets.all(16),
            color: Colors.black54,
            child: Text(
              'Change Image',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.w400),
            ),
            onPressed: () => _getLocalImage(),
          )
        ],
      );
    } else if (_imageUrl != null) {
      print('showing image from url');

      return Stack(
        alignment: AlignmentDirectional.bottomCenter,
        children: <Widget>[
          Image.network(
            _imageUrl,
            width: MediaQuery.of(context).size.width,
            fit: BoxFit.cover,
            height: 250,
          ),
          FlatButton(
            padding: EdgeInsets.all(16),
            color: Colors.black54,
            child: Text(
              'Change Image',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.w400),
            ),
            onPressed: () => _getLocalImage(),
          )
        ],
      );
    }
  }

  _getLocalImage() async {
    File imageFile = await ImagePicker.pickImage(
        source: ImageSource.gallery, imageQuality: 50, maxWidth: 400);

    if (imageFile != null) {
      setState(() {
        _imageFile = imageFile;
      });
    }
  }

  _onTweetUploaded(Tweets tweets) {
    TweetNotifier tweetNotifier =
        Provider.of<TweetNotifier>(context, listen: false);
    tweetNotifier.addTweet(tweets);
    Navigator.pop(context);
  }

  _saveTweet() {
    print('save Tweet Called');
    if (!_formKey.currentState.validate()) {
      return;
    }

    _formKey.currentState.save();

    print('form saved');

    uploadTweetAndImage(
        _currentTweet, widget.isUpdating, _imageFile, _onTweetUploaded);

    print("description: ${_currentTweet.description}");
    print("_imageFile ${_imageFile.toString()}");
    print("_imageUrl $_imageUrl");
  }

  Widget get createTweetField => TextFormField(
        decoration: InputDecoration(
            labelText: 'What\'s happening?',
            labelStyle: TwitterTextStyle.heading5),
        initialValue: _currentTweet.description,
        keyboardType: TextInputType.text,
        maxLength: 280,
        maxLines: 5,
        style: TextStyle(fontSize: 20, color: white),
        onSaved: (String value) {
          _currentTweet.description = value;
        },
      );

  @override
  Widget build(BuildContext context) {
    final appBar = AppBar(
      backgroundColor: Colors.transparent,
      brightness: Brightness.light,
      elevation: 1,
      title: Text(widget.isUpdating ? "Edit Tweet" : "Create Tweet"),
      actions: [
        Container(
          margin: EdgeInsets.all(10),
          child: ButtonTheme(
            child: RaisedButton(
              onPressed: () {
                FocusScope.of(context).requestFocus(new FocusNode());
                _saveTweet();
              },
              child: Text(
                'Save',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        )
      ],
    );

    final floatingActionButton = _imageFile == null && _imageUrl == null
        ? ButtonTheme(
            child: RaisedButton(
              onPressed: () => _getLocalImage(),
              child: Icon(Icons.photo, color: white),
            ),
          )
        : SizedBox(height: 0);

    final body = SingleChildScrollView(
      padding: EdgeInsets.all(20),
      child: Form(
        key: _formKey,
        autovalidate: true,
        child: Column(
          children: [
            SizedBox(height: 16),
            createTweetField,
            SizedBox(height: 60),
            _showImage(),
          ],
        ),
      ),
    );

    return Scaffold(
      backgroundColor: Colors.grey[800],
      key: _scaffoldKey,
      appBar: appBar,
      body: body,
      floatingActionButton: floatingActionButton,
    );
  }
}
