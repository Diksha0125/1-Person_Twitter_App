import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart' as path;
import 'package:twitter_one_person_app/api/auth_notifier.dart';
import 'package:twitter_one_person_app/api/tweet_notifier.dart';
import 'package:twitter_one_person_app/model/tweets.dart';
import 'package:twitter_one_person_app/model/user.dart';
import 'package:uuid/uuid.dart';

login(User user, AuthNotifier authNotifier) async {
  AuthResult authResult = await FirebaseAuth.instance
      .signInWithEmailAndPassword(email: user.email, password: user.password)
      .catchError((error) => print(error.code));

  if (authResult != null) {
    FirebaseUser firebaseUser = authResult.user;
    if (firebaseUser != null) {
      print("Log In: $firebaseUser");
      authNotifier.setUser(firebaseUser);
    }
  }
}

signup(User user, AuthNotifier authNotifier) async {
  AuthResult authResult = await FirebaseAuth.instance
      .createUserWithEmailAndPassword(
          email: user.email, password: user.password)
      .catchError((error) => print(error.code));

  if (authResult != null) {
    UserUpdateInfo updateInfo = UserUpdateInfo();
    updateInfo.displayName = user.displayName;
    FirebaseUser firebaseUser = authResult.user;
    if (firebaseUser != null) {
      await firebaseUser.updateProfile(updateInfo);

      await firebaseUser.reload();

      print("Sign up: $firebaseUser");

      FirebaseUser currentUser = await FirebaseAuth.instance.currentUser();
      authNotifier.setUser(currentUser);
    }
  }
}

signout(AuthNotifier authNotifier) async {
  await FirebaseAuth.instance
      .signOut()
      .catchError((error) => print(error.code));
  authNotifier.setUser(null);
}

initializeCurrentUser(AuthNotifier authNotifier) async {
  FirebaseUser firebaseUser = await FirebaseAuth.instance.currentUser();
  if (firebaseUser != null) {
    print(firebaseUser);
    authNotifier.setUser(firebaseUser);
  }
}

gettweetss(TweetNotifier tweetsNotifier) async {
  QuerySnapshot snapshot = await Firestore.instance
      .collection('posts')
      .orderBy("createdAt", descending: true)
      .getDocuments();
  List<Tweets> _tweetsList = [];

  snapshot.documents.forEach((document) {
    Tweets tweets = Tweets.fromMap(document.data);
    _tweetsList.add(tweets);
  });

  tweetsNotifier.tweetList = _tweetsList;
}

uploadTweetAndImage(Tweets tweets, bool isUpdating, File localFile,
    Function foodUploaded) async {
  if (localFile != null) {
    print("uploading image");

    var fileExtension = path.extension(localFile.path);
    print(fileExtension);

    var uuid = Uuid().v4();

    final StorageReference firebaseStorageRef = FirebaseStorage.instance
        .ref()
        .child('tweeta/images/$uuid$fileExtension');

    await firebaseStorageRef
        .putFile(localFile)
        .onComplete
        .catchError((onError) {
      print(onError);
      return false;
    });

    String url = await firebaseStorageRef.getDownloadURL();
    print("download url: $url");
    _uploadtweets(tweets, isUpdating, foodUploaded, imageUrl: url);
  } else {
    print('...skipping image upload');
    _uploadtweets(tweets, isUpdating, foodUploaded);
  }
}

_uploadtweets(Tweets tweets, bool isUpdating, Function tweetsUploaded,
    {String imageUrl}) async {
  CollectionReference tweetsRef = Firestore.instance.collection('posts');

  if (isUpdating) {
    tweets.updatedAt = Timestamp.now();

    await tweetsRef.document(tweets.id).updateData(tweets.toMap());

    tweetsUploaded(tweets);
    print('updated tweets with id: ${tweets.id}');
  } else {
    tweets.createdAt = Timestamp.now();

    DocumentReference documentRef = await tweetsRef.add(tweets.toMap());

    tweets.id = documentRef.documentID;

    print('uploaded tweets successfully: ${tweets.toString()}');

    await documentRef.setData(tweets.toMap(), merge: true);

    tweetsUploaded(tweets);
  }
}

deleteTweet(Tweets tweets, Function tweetsDeleted) async {
  if (tweets.image != null) {
    StorageReference storageReference =
        await FirebaseStorage.instance.getReferenceFromUrl(tweets.image);

    print(storageReference.path);

    await storageReference.delete();

    print('image deleted');
  }
  await Firestore.instance.collection('posts').document(tweets.id).delete();
  tweetsDeleted(tweets);
}
