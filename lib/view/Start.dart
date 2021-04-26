import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:twitter_one_person_app/colors.dart';
import 'package:twitter_one_person_app/custom_messages.dart';
import 'package:twitter_one_person_app/styles.dart';
import 'package:twitter_one_person_app/widgets/custom_raised_button.dart';

class Start extends StatefulWidget {
  @override
  _StartState createState() => _StartState();
}

class _StartState extends State<Start> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<UserCredential> googleSignIn() async {
    GoogleSignIn googleSignIn = GoogleSignIn();
    GoogleSignInAccount googleUser = await googleSignIn.signIn();
    if (googleUser != null) {
      GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      if (googleAuth.idToken != null && googleAuth.accessToken != null) {
        final AuthCredential credential = GoogleAuthProvider.credential(
            accessToken: googleAuth.accessToken, idToken: googleAuth.idToken);

        final UserCredential user =
            await _auth.signInWithCredential(credential);

        await Navigator.pushReplacementNamed(context, "/");

        return user;
      } else {
        throw StateError('Missing Google Auth Token');
      }
    } else
      throw StateError('Sign in Aborted');
  }

  navigateToLogin() async {
    Navigator.pushReplacementNamed(context, "Login");
  }

  navigateToRegister() async {
    Navigator.pushReplacementNamed(context, "SignUp");
  }

  Widget get body => Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(CustomMessages.twitterDemo, style: TwitterTextStyle.heading),
            SizedBox(height: 40),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                CustomRaisedButton(
                  text: CustomMessages.login,
                  fontSize: 20,
                  bgColor: primaryColor,
                  textColor: white,
                  onPressed: navigateToLogin,
                ),
                SizedBox(width: 20.0),
                CustomRaisedButton(
                  text: CustomMessages.register,
                  fontSize: 20,
                  bgColor: primaryColor,
                  textColor: white,
                  onPressed: navigateToRegister,
                ),
              ],
            ),
            SizedBox(height: 20.0),
            SignInButton(Buttons.Google,
                text: CustomMessages.signUpWithGoogle, onPressed: googleSignIn)
          ],
        ),
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: body,
    );
  }
}
