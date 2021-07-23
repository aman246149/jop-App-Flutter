import 'package:flutter/material.dart';
import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:job/Auth/sing_up.dart';
import 'package:job/Auth/user_provider.dart';
import 'package:provider/provider.dart';

class Verify extends StatefulWidget {
  @override
  _VerifyState createState() => _VerifyState();
}

class _VerifyState extends State<Verify> {
  final _auth = FirebaseAuth.instance;
  late User? user;
  late Timer timer;
  @override
  void initState() {
    user = _auth.currentUser;
    user!.sendEmailVerification();
    timer = Timer.periodic(Duration(seconds: 5), (timer) {
      checkEmailVerified();
    });
    super.initState();
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Padding(
            padding: EdgeInsets.only(left: 20.0, right: 20.0),
            child: Text(
              'An Email has been sent to ${user!.email} please Verify and if no email is received make sure you have entered a right email  ',
              style: TextStyle(),
            ),
          ),
          SizedBox(height: 30.0),
          TextButton(
            onPressed: () {
              Navigator.pushReplacement(
                  context, MaterialPageRoute(builder: (context) => SignUp()));
            },
            child: Text('go back'),
          )
        ]),
      ),
    );
  }

  Future<void> checkEmailVerified() async {
    user = _auth.currentUser;
    await user!.reload();
    if (user!.emailVerified) {
      Provider.of<UserProvider>(context).setIsloogedIn(true);
      timer.cancel();
      Navigator.pop(context);
    }
  }
}
