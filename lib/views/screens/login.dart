import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:twitter_one_person_app/api/auth_notifier.dart';
import 'package:twitter_one_person_app/api/tweet_api.dart';
import 'package:twitter_one_person_app/custom_messages.dart';
import 'package:twitter_one_person_app/model/user.dart';
import 'package:twitter_one_person_app/styles.dart';
import 'package:twitter_one_person_app/views/widgets/custom_text_form_field.dart';

enum AuthMode { Signup, Login }

class Login extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _LoginState();
  }
}

class _LoginState extends State<Login> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _passwordController = new TextEditingController();
  AuthMode _authMode = AuthMode.Login;

  User _user = User();

  @override
  void initState() {
    AuthNotifier authNotifier =
        Provider.of<AuthNotifier>(context, listen: false);
    initializeCurrentUser(authNotifier);
    super.initState();
  }

  void _submitForm() {
    if (!_formKey.currentState.validate()) {
      return;
    }

    _formKey.currentState.save();

    AuthNotifier authNotifier =
        Provider.of<AuthNotifier>(context, listen: false);

    if (_authMode == AuthMode.Login) {
      login(_user, authNotifier);
    } else {
      signup(_user, authNotifier);
    }
  }

  Widget get textFieldName => CustomTextField(
        labelText: CustomMessages.name,
        textStyle: TwitterTextStyle.heading,
        keyboard: TextInputType.text,
        lableTextStyle: TwitterTextStyle.heading1,
        validator: (String value) {
          if (value.isEmpty) {
            return 'Display Name is required';
          }
          if (value.length < 5 || value.length > 12) {
            return 'Display Name must be betweem 5 and 12 characters';
          }
          return null;
        },
        onSaved: (String value) {
          _user.displayName = value;
        },
      );

  Widget get textFieldEmail => CustomTextField(
        labelText: CustomMessages.email,
        textStyle: TwitterTextStyle.heading,
        keyboard: TextInputType.emailAddress,
        lableTextStyle: TwitterTextStyle.heading1,
        validator: (String value) {
          if (value.isEmpty) {
            return 'Email is required';
          }
          if (!RegExp(
                  r"[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?")
              .hasMatch(value)) {
            return 'Please enter a valid email address';
          }
          return null;
        },
        onSaved: (String value) {
          _user.email = value;
        },
      );

  Widget get testFieldPassword => CustomTextField(
        labelText: CustomMessages.password,
        textStyle: TwitterTextStyle.heading,
        keyboard: TextInputType.text,
        obscureTrue: true,
        controller: _passwordController,
        lableTextStyle: TwitterTextStyle.heading1,
        validator: (String value) {
          if (value.isEmpty) {
            return 'Password is required';
          }
          if (value.length < 5 || value.length > 20) {
            return 'Password must be betweem 5 and 20 characters';
          }
          return null;
        },
        onSaved: (String value) {
          _user.password = value;
        },
      );

  Widget get testFieldConfirmPassword => CustomTextField(
        labelText: CustomMessages.confirmPassword,
        textStyle: TwitterTextStyle.heading,
        obscureTrue: true,
        lableTextStyle: TwitterTextStyle.heading1,
        validator: (String value) {
          if (_passwordController.text != value) {
            return 'Passwords do not match';
          }
          return null;
        },
      );

  Widget get body => Container(
        constraints: BoxConstraints.expand(
          height: MediaQuery.of(context).size.height,
        ),
        child: Form(
          autovalidate: true,
          key: _formKey,
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.fromLTRB(20, 120, 20, 0),
              child: Column(
                children: <Widget>[
                  Text(
                    CustomMessages.twitterDemo,
                    style: TwitterTextStyle.heading,
                  ),
                  SizedBox(height: 32),
                  _authMode == AuthMode.Signup ? textFieldName : Container(),
                  SizedBox(height: 8),
                  textFieldEmail,
                  SizedBox(height: 8),
                  testFieldPassword,
                  SizedBox(height: 8),
                  _authMode == AuthMode.Signup
                      ? testFieldConfirmPassword
                      : Container(),
                  SizedBox(height: 32),
                  ButtonTheme(
                    minWidth: 200,
                    child: RaisedButton(
                      padding: EdgeInsets.all(10.0),
                      child: Text(
                        '${_authMode == AuthMode.Login ? 'Signup' : 'Login'}',
                        style: TextStyle(fontSize: 20, color: Colors.white),
                      ),
                      onPressed: () {
                        setState(() {
                          _authMode = _authMode == AuthMode.Login
                              ? AuthMode.Signup
                              : AuthMode.Login;
                        });
                      },
                    ),
                  ),
                  SizedBox(height: 16),
                  ButtonTheme(
                    minWidth: 200,
                    child: RaisedButton(
                      padding: EdgeInsets.all(10.0),
                      onPressed: () => _submitForm(),
                      child: Text(
                        _authMode == AuthMode.Login ? 'Login' : 'Signup',
                        style: TextStyle(fontSize: 20, color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[800],
      body: body,
    );
  }
}
