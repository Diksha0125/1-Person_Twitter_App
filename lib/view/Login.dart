import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:twitter_one_person_app/colors.dart';
import 'package:twitter_one_person_app/custom_messages.dart';
import 'package:twitter_one_person_app/widgets/custom_raised_button.dart';
import 'package:twitter_one_person_app/widgets/custom_text_form_field.dart';

import 'SignUp.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String _email, _password;

  checkAuthentification() async {
    _auth.authStateChanges().listen((user) {
      if (user != null) {
        print(user);

        Navigator.pushReplacementNamed(context, "/");
      }
    });
  }

  @override
  void initState() {
    super.initState();
    this.checkAuthentification();
  }

  login() async {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();

      try {
        await _auth.signInWithEmailAndPassword(
            email: _email, password: _password);
      } catch (e) {
        showError(e.message);
        print(e);
      }
    }
  }

  showError(String errormessage) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('ERROR'),
            content: Text(errormessage),
            actions: <Widget>[
              FlatButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('OK'))
            ],
          );
        });
  }

  navigateToSignUp() async {
    Navigator.push(context, MaterialPageRoute(builder: (context) => SignUp()));
  }

  Widget get body => Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              child: Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    CustomTextField(
                      labelText: CustomMessages.email,
                      prefixIcon: Icons.email,
                      validator: (input) {
                        if (input.isEmpty) return 'Enter Email';
                      },
                      onSaved: (input) => _email = input,
                    ),
                    CustomTextField(
                      labelText: CustomMessages.password,
                      prefixIcon: Icons.lock,
                      validator: (input) {
                        if (input.length < 6)
                          return 'Provide Minimum 6 Character';
                      },
                      onSaved: (input) => _password = input,
                    ),
                    SizedBox(height: 20),
                    CustomRaisedButton(
                      text: CustomMessages.login,
                      fontSize: 20,
                      bgColor: primaryColor,
                      textColor: white,
                      onPressed: login,
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),
            GestureDetector(
              child: Text(CustomMessages.createAccount),
              onTap: navigateToSignUp,
            )
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
