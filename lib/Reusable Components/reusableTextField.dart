import 'package:flutter/material.dart';

class ReusableTextField extends StatelessWidget {
  final FormFieldValidator<String>? validator;
  final FormFieldSetter<String>? onSaved;
  final String lableText;
  final Icon icon;
  final bool obscureText;

  ReusableTextField(
      {required this.validator,
      required this.onSaved,
      required this.lableText,
      required this.icon,
      required this.obscureText});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 20.0, right: 20.0),
      child: Container(
        child: TextFormField(
            validator: validator,
            decoration: InputDecoration(
                fillColor: Colors.white,
                focusedBorder: OutlineInputBorder(
                  borderSide:
                      const BorderSide(color: Colors.deepPurple, width: 2.0),
                  borderRadius: BorderRadius.circular(25.0),
                ),
                labelText: lableText,
                labelStyle: TextStyle(color: Colors.black),
                prefixIcon: icon),
            onSaved: onSaved,
            obscureText: obscureText),
      ),
    );
  }
}
