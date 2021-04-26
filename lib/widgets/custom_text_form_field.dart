import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  String labelText;
  IconData prefixIcon;
  bool obscureTrue;
  TextEditingController controller;
  FormFieldValidator<String> validator;
  Function(String) onSaved;

  CustomTextField(
      {this.labelText,
      this.prefixIcon,
      this.validator,
      this.onSaved,
      this.controller,
      this.obscureTrue = false});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: TextFormField(
        obscureText: obscureTrue,
        validator: validator,
        controller: controller,
        decoration:
            InputDecoration(labelText: labelText, prefixIcon: Icon(prefixIcon)),
        onSaved: onSaved,
      ),
    );
  }
}
