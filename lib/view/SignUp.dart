import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:twitter_one_person_app/colors.dart';
import 'package:twitter_one_person_app/custom_messages.dart';
import 'package:twitter_one_person_app/widgets/custom_raised_button.dart';
import 'package:twitter_one_person_app/widgets/custom_text_form_field.dart';

class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  FirebaseAuth _auth = FirebaseAuth.instance;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String _name, _email, _password;

  checkAuthentication() async {
    _auth.authStateChanges().listen((user) async {
      if (user != null) {
        Navigator.pushReplacementNamed(context, "/");
      }
    });
  }

  @override
  void initState() {
    super.initState();
    this.checkAuthentication();
  }

  signUp() async {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      try {
        UserCredential user = await _auth.createUserWithEmailAndPassword(
            email: _email, password: _password);
        if (user != null) {
          await _auth.currentUser.updateProfile(displayName: _name);
        }
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
                      labelText: CustomMessages.name,
                      prefixIcon: Icons.person,
                      validator: (input) {
                        if (input.isEmpty) return 'Enter Name';
                      },
                      onSaved: (input) => _name = input,
                    ),
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
                      obscureTrue: true,
                      validator: (input) {
                        if (input.length < 6)
                          return 'Provide Minimum 6 Character';
                      },
                      onSaved: (input) => _password = input,
                    ),
                    SizedBox(height: 20),
                    CustomRaisedButton(
                      text: CustomMessages.register,
                      fontSize: 20,
                      bgColor: primaryColor,
                      textColor: white,
                      onPressed: signUp,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: body);
  }
}
