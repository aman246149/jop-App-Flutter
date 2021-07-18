import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:job/Auth/verify.dart';

import 'reusableTextField.dart';

class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignUp> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  late String _email, _password, _name;

  signUp() async {
    if (_formkey.currentState!.validate()) {
      _formkey.currentState!.save();
      try {
        UserCredential userCred = await _auth.createUserWithEmailAndPassword(
            email: _email, password: _password);
        User? user = userCred.user;
        if (user != null) {
          await user.updateDisplayName(_name);
        }
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => Verify(),
          ),
        );
      } catch (e) {
        showError(e.toString());
      }
    }
  }

  showError(String error) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text(error),
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.deepPurple,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(top: 20.0, left: 20.0),
              child: Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      radius: 20.0,
                      backgroundImage: AssetImage('images/jobs.jpg'),
                    ),
                    SizedBox(height: 20.0),
                    Text(
                      'Welcome',
                      style: TextStyle(color: Colors.white60, fontSize: 15.0),
                    ),
                    SizedBox(height: 10.0),
                    RichText(
                      text: TextSpan(
                        text: 'Sing Up',
                        style: TextStyle(
                            fontSize: 28.0, fontWeight: FontWeight.w700),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 30.0),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30.0),
                        topRight: Radius.circular(30.0))),
                child: Container(
                  child: Form(
                    key: _formkey,
                    child: Column(
                      children: [
                        SizedBox(
                          height: 50.0,
                        ),
                        ReusableTextField(
                            validator: (input) {
                              if (input!.isEmpty) {
                                return 'Enter Name';
                              }
                            },
                            onSaved: (input) => _name = input!,
                            lableText: 'Name',
                            icon: Icon(
                              Icons.assignment_ind_rounded,
                              color: Colors.deepPurple,
                            ),
                            obscureText: false),
                        SizedBox(
                          height: 10.0,
                        ),
                        ReusableTextField(
                            validator: (input) {
                              if (input!.isEmpty) {
                                return 'Enter Email';
                              }
                            },
                            lableText: 'Email',
                            icon: Icon(
                              Icons.email,
                              color: Colors.deepPurple,
                            ),
                            onSaved: (input) => _email = input!,
                            obscureText: false),
                        SizedBox(height: 10.0),
                        ReusableTextField(
                          validator: (input) {
                            if (input!.length < 6) {
                              return 'Password Should be at least 6 Character long ';
                            }
                          },
                          onSaved: (input) => _password = input!,
                          lableText: 'Password',
                          icon: Icon(Icons.lock, color: Colors.deepPurple),
                          obscureText: true,
                        ),
                        SizedBox(
                          height: 50.0,
                        ),
                        ElevatedButton(
                            style: ButtonStyle(
                              padding: MaterialStateProperty.all(
                                EdgeInsets.fromLTRB(70.0, 10.0, 70.0, 10.0),
                              ),
                              backgroundColor:
                                  MaterialStateProperty.all(Colors.deepPurple),
                              shape: MaterialStateProperty.all(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20.0),
                                ),
                              ),
                            ),
                            onPressed: () {
                              signUp();
                            },
                            child: Text(
                              'Sign Up',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.bold),
                            ))
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}