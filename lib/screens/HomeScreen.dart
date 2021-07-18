// ignore: file_names
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
            child: Text("HomeScreen", style: TextStyle(color: Colors.white))),
        backgroundColor: Colors.deepPurple,
      ),
      body: Text("scaffold"),
    );
  }
}
