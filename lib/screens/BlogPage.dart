// ignore: file_names
import 'package:flutter/material.dart';

class BlogPage extends StatefulWidget {
  const BlogPage({Key? key}) : super(key: key);

  @override
  _BlogPageState createState() => _BlogPageState();
}

class _BlogPageState extends State<BlogPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
            child: Text("Blogs", style: TextStyle(color: Colors.white))),
        backgroundColor: Colors.deepPurple,
      ),
    );
  }
}
