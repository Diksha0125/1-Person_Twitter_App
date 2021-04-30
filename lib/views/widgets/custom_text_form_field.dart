import 'package:flutter/material.dart';
import 'package:twitter_one_person_app/colors.dart';

class CustomTextField extends StatelessWidget {
  String labelText;
  IconData prefixIcon;
  TextInputType keyboard;
  bool obscureTrue;
  TextStyle lableTextStyle;
  TextStyle textStyle;
  TextEditingController controller;
  FormFieldValidator<String> validator;
  Function(String) onSaved;

  CustomTextField(
      {this.labelText,
      this.prefixIcon,
      this.validator,
      this.keyboard,
      this.onSaved,
      this.controller,
      this.lableTextStyle,
      this.textStyle,
      this.obscureTrue = false});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: TextFormField(
        obscureText: obscureTrue,
        validator: validator,
        style: textStyle,
        controller: controller,
        keyboardType: keyboard,
        decoration: InputDecoration(
            labelText: labelText,
            border: OutlineInputBorder(
              borderSide: BorderSide(color: white),
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
            prefixIcon: Icon(prefixIcon),
            labelStyle: lableTextStyle),
        onSaved: onSaved,
      ),
    );
  }
}
