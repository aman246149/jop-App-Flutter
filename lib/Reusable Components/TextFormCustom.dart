import 'package:flutter/material.dart';

class TextFormCustom extends StatelessWidget {
  final TextEditingController controller;
  final String lablename;

  const TextFormCustom(
      {Key? key, required this.controller, required this.lablename})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(18.0),
      child: TextFormField(
        controller: controller,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return "please enter some data";
          }
          return null;
        },
        decoration: InputDecoration(
          labelText: lablename,
        ),
      ),
    );
  }
}
