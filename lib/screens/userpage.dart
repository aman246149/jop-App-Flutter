// ignore: file_names
import 'package:flutter/material.dart';
import 'package:job/Auth/Auth.dart';

class UserPage extends StatefulWidget {
  const UserPage({Key? key}) : super(key: key);

  @override
  _UserPageState createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Center(
            child: Text(
              "UserScreen",
              style: TextStyle(color: Colors.white),
            ),
          ),
          backgroundColor: Colors.deepPurple,
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              color: Colors.red,
              width: MediaQuery.of(context).size.width,
              child: TextButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Auth(),
                      ));
                },
                child: Text(
                  "Sign In",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
