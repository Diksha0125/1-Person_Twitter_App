import 'package:flutter/material.dart';

class CustomRaisedButton extends StatelessWidget {
  String text;
  VoidCallback onPressed;
  Color bgColor, textColor;
  double fontSize;
  CustomRaisedButton(
      {this.text, this.onPressed, this.bgColor, this.textColor, this.fontSize});

  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      padding: EdgeInsets.symmetric(vertical: 6, horizontal: 30),
      color: bgColor,
      onPressed: onPressed,
      child: Text(
        text,
        style: TextStyle(
          fontSize: fontSize,
          color: textColor,
        ),
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
    );
  }
}
