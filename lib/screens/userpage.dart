import 'package:flutter/material.dart';
import 'package:job/Auth/log_in.dart';

class UserPage extends StatefulWidget {
  @override
  _UserPageState createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: TextButton(
          child: Text('Sign In'),
          onPressed: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => LogIn()));
          },
        ),
      ),
    );
  }
}
