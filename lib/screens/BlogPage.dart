// ignore_for_file: file_names, prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:job/Auth/user_provider.dart';
import 'package:provider/provider.dart';

class BlogPage extends StatefulWidget {
  const BlogPage({Key? key}) : super(key: key);

  @override
  _BlogPageState createState() => _BlogPageState();
}

class _BlogPageState extends State<BlogPage> {
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  TextEditingController imageurlController = TextEditingController();
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  List<DocumentSnapshot> _blogs = [];
  CollectionReference collection_path =
      FirebaseFirestore.instance.collection('Blog');

  void saveDataToDatabase() {
    Map<String, String?> data = {
      'imgurl': imageurlController.text,
      'title': titleController.text,
      'description': descriptionController.text
    };
    _firestore.collection('Blogs').add(data);
    // print(imageurlController.text);
    // print(titleController.text);
    // print(descriptionController.text);
  }

  _getBlogData() async {
    //fetching data from firebase

    Query q = _firestore.collection("Blogs");
    QuerySnapshot querySnapshot = await q.get();
    setState(() {
      _blogs = querySnapshot.docs;
    });
    print(_blogs[0]["imgurl"]);
  }

  void initialize() async {
    await _getBlogData();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initialize();
  }

  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<UserProvider>(context);
    return Scaffold(
      floatingActionButton: Visibility(
        visible: provider.getIsAdmin(),
        child: FloatingActionButton(
          onPressed: () {
            showModalBottomSheet<void>(
              isScrollControlled: true,
              context: context,
              builder: (BuildContext context) {
                return Container(
                  // height: 1000,
                  color: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.all(18.0),
                    child: ListView(
                      children: <Widget>[
                        Divider(
                          height: 100,
                        ),
                        TextField(
                          controller: imageurlController,
                          decoration:
                              InputDecoration(hintText: "Enter Image Url"),
                        ),
                        TextField(
                          controller: titleController,
                          decoration: InputDecoration(hintText: "Enter Title"),
                        ),
                        TextField(
                          controller: descriptionController,
                          decoration:
                              InputDecoration(hintText: "Enter Description"),
                        ),
                        Divider(
                          height: 20,
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width,
                          child: ElevatedButton(
                            child: const Text('Save data in Db'),
                            onPressed: () {
                              saveDataToDatabase();
                              Navigator.pop(context);
                            },
                          ),
                        )
                      ],
                    ),
                  ),
                );
              },
            );
          },
          child: Icon(Icons.add),
        ),
      ),
      appBar: AppBar(
        title:
            Center(child: Text("Blogs", style: TextStyle(color: Colors.white))),
        backgroundColor: Colors.deepPurple,
      ),
      body: ListView.builder(
        itemCount: _blogs.length,
        itemBuilder: (context, index) {
          return Stack(
            fit: StackFit.loose,
            children: [
              Card(
                  elevation: 4,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width,
                          child: Image(
                            image: NetworkImage(_blogs[index]["imgurl"]),
                          ),
                        ),
                        Divider(
                          height: 20,
                        ),
                        Text(
                          _blogs[index]["title"],
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 25),
                        ),
                        Divider(
                          height: 20,
                        ),
                        Text(
                          _blogs[index]["description"],
                          style: TextStyle(fontSize: 20),
                        ),
                        Divider(
                          height: 40,
                        ),
                        Divider(
                          height: 5,
                          thickness: 2,
                        )
                      ],
                    ),
                  ))
            ],
          );
        },
      ),
    );
  }
}
