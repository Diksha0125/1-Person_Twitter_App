import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:twitter_one_person_app/colors.dart';
import 'package:twitter_one_person_app/custom_messages.dart';
import 'package:twitter_one_person_app/widgets/custom_app_bar.dart';
import 'package:twitter_one_person_app/widgets/custom_raised_button.dart';
import 'package:twitter_one_person_app/widgets/cutom_list_tile.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User user;
  final firestoreInstance = FirebaseFirestore.instance;
  final CollectionReference collectionReference =
      FirebaseFirestore.instance.collection('posts');
  TextEditingController textEditingController = TextEditingController();

  @override
  initState() {
    this.checkAuthentification();
    this.getUser();
    super.initState();
  }

  checkAuthentification() async {
    _auth.authStateChanges().listen((user) {
      if (user == null) {
        Navigator.of(context).pushReplacementNamed("start");
      }
    });
  }

  getUser() async {
    User firebaseUser = _auth.currentUser;
    await firebaseUser?.reload();
    firebaseUser = _auth.currentUser;
    if (firebaseUser != null) {
      setState(() {
        this.user = firebaseUser;
      });
    }
  }

  signOut() async {
    _auth.signOut();
    final googleSignIn = GoogleSignIn();
    await googleSignIn.signOut();
  }

  void deleteOrEditTweet(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return Container(
            child: Wrap(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                  child: InkWell(
                    onTap: () async {
                      await collectionReference
                          .doc('')
                          .update({'description': ' '}).then(
                              (value) => print('updated'));
                    },
                    child: Center(child: Text(CustomMessages.update)),
                  ),
                ),
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  child: CustomRaisedButton(
                    text: CustomMessages.delete,
                    onPressed: () async {
                      await collectionReference
                          .doc('')
                          .delete()
                          .then((value) => print('deleted'));
                    },
                    bgColor: Colors.red,
                    textColor: white,
                  ),
                )
              ],
            ),
          );
        });
  }

  Widget get appBar => header(
        context,
        networkImage: user.photoURL,
        title: user.displayName,
        subTitle: user.email,
        iconData: Icons.logout,
        onPress: signOut,
      );

  Widget floatingActionButton() {
    return FloatingActionButton(
      onPressed: () {
        showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                backgroundColor: lightGrey,
                content: Column(
                  children: [
                    TextFormField(
                      controller: textEditingController,
                      style: TextStyle(fontSize: 22, color: Colors.black),
                      maxLength: 280,
                      maxLines: 5,
                      maxLengthEnforced: true,
                      decoration: InputDecoration(
                        hintText: 'What\'s happening?',
                        hintStyle: TextStyle(fontSize: 22, color: Colors.black),
                      ),
                    ),
                    Spacer(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CustomRaisedButton(
                          text: CustomMessages.cancel,
                          fontSize: 18,
                          bgColor: lightGrey,
                          textColor: black,
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                        CustomRaisedButton(
                          text: CustomMessages.tweet,
                          fontSize: 18,
                          bgColor: primaryColor,
                          textColor: white,
                          onPressed: () async {
                            Navigator.pop(context);
                            await collectionReference.add({
                              'userName': user.displayName,
                              'description': textEditingController.text
                            }).then((value) => textEditingController.clear());
                          },
                        ),
                      ],
                    )
                  ],
                ),
              );
            });
      },
      child: Stack(
        children: [
          Icon(Icons.edit),
          Positioned(top: -8, left: -8, child: Icon(Icons.add)),
        ],
      ),
    );
  }

  Widget get body => Container(
        child: StreamBuilder<QuerySnapshot>(
            stream: collectionReference.snapshots(),
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasError) return Text('Error: ${snapshot.error}');
              switch (snapshot.connectionState) {
                case ConnectionState.waiting:
                  return Text('Loading...');
                default:
                  return ListView(
                    children:
                        snapshot.data.docs.map((DocumentSnapshot document) {
                      return CustomListTile(
                        onPress: () {
                          deleteOrEditTweet(context);
                        },
                        title: document['userName'],
                        description: document['description'],
                      );
                    }).toList(),
                  );
              }
            }),
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: black,
      appBar: appBar,
      body: body,
      floatingActionButton: floatingActionButton(),
    );
  }
}
