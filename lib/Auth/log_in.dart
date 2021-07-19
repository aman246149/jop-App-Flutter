import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:job/Auth/forget_password.dart';
import 'package:job/Auth/sing_up.dart';
import 'package:job/Auth/user_provider.dart';
import 'package:provider/provider.dart';

import '../Reusable Components/reusableTextField.dart';

class LogIn extends StatefulWidget {
  const LogIn({Key? key}) : super(key: key);

  @override
  _LogInState createState() => _LogInState();
}

class _LogInState extends State<LogIn> {
  final googleSignIn = GoogleSignIn();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  late String _email;
  late String _password;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  login() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
    }
    try {
      UserCredential userCred = await _auth.signInWithEmailAndPassword(
          email: _email, password: _password);
      User? currentUser = userCred.user;
      if (currentUser != null) {
        var provider = Provider.of<UserProvider>(context, listen: false);
        provider.checkAdmin(userEmail: currentUser.email);

        Navigator.pop(context);
      }
    } catch (e) {
      showError(e.toString());
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
                        text: 'Sing In',
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
                    key: _formKey,
                    child: Column(
                      children: [
                        SizedBox(
                          height: 50.0,
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
                          height: 10.0,
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 20.0),
                          child: Row(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              ForgetPassword()));
                                },
                                child: Text('Forget password ?'),
                              ),
                            ],
                          ),
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
                              login();
                            },
                            child: Text(
                              'Sign In',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.bold),
                            )),
                        SizedBox(height: 10.0),
                        Text(
                          'or',
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            color: Colors.black,
                            fontSize: 22.0,
                          ),
                        ),
                        SizedBox(height: 15.0),
                        SignInButton(Buttons.Google,
                            elevation: 6.00,
                            text: 'Sign up with Google ', onPressed: () async {
                          await Provider.of<UserProvider>(context,
                                  listen: false)
                              .login();
                          Navigator.pop(context);
                        }),
                        SizedBox(height: 40.0),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Don\'t have an Account',
                                style: TextStyle(color: Colors.black),
                              ),
                              GestureDetector(
                                onTap: () {
                                  Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => SignUp()));
                                },
                                child: Text(
                                  ' Create',
                                  style: TextStyle(
                                      fontSize: 15.0,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.blue),
                                ),
                              ),
                            ]),
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
