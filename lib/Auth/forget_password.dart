import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:job/Reusable%20Components/reusableTextField.dart';

class ForgetPassword extends StatelessWidget {
  late String _email;
  FirebaseAuth _auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Forget Password'),
          backgroundColor: Colors.deepPurple,
        ),
        body: Container(
          child: Column(children: [
            Padding(
                padding: EdgeInsets.symmetric(vertical: 40.0, horizontal: 20.0),
                child: TextField(
                  onChanged: (value) {
                    _email = value;
                  },
                  decoration: InputDecoration(
                      fillColor: Colors.white,
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                            color: Colors.deepPurple, width: 2.0),
                        borderRadius: BorderRadius.circular(25.0),
                      ),
                      labelText: 'Email',
                      labelStyle: TextStyle(color: Colors.black),
                      prefixIcon: Icon(
                        Icons.email,
                        color: Colors.deepPurple,
                      )),
                )),
            ElevatedButton(
              onPressed: () {
                _auth.sendPasswordResetEmail(email: _email);
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text('Note'),
                        content: Text(
                            'A Password reset link has been sent to your Email if not received make sure you have entered a correct Email'),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: Text('Ok'),
                          ),
                        ],
                      );
                    });
              },
              child: Text(
                'send',
                style: TextStyle(fontSize: 20.0),
              ),
              style: ButtonStyle(
                  shape: MaterialStateProperty.all(RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0))),
                  padding: MaterialStateProperty.all(
                      EdgeInsets.symmetric(vertical: 10.0, horizontal: 40.0)),
                  backgroundColor:
                      MaterialStateProperty.all(Colors.deepPurple)),
            )
          ]),
        ),
      ),
    );
  }
}
