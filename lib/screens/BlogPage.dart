// ignore_for_file: file_names, prefer_const_constructors

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class BlogPage extends StatefulWidget {
  const BlogPage({Key? key}) : super(key: key);

  @override
  _BlogPageState createState() => _BlogPageState();
}

class _BlogPageState extends State<BlogPage> {
  TextEditingController imageurlController = TextEditingController();
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  void saveDataToDatabase() {
    print(imageurlController.text);
    print(titleController.text);
    print(descriptionController.text);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
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
      appBar: AppBar(
        title:
            Center(child: Text("Blogs", style: TextStyle(color: Colors.white))),
        backgroundColor: Colors.deepPurple,
      ),
      body: ListView.builder(
        itemCount: 10,
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
                          height: 300,
                          width: MediaQuery.of(context).size.width,
                          color: Colors.red,
                        ),
                        Divider(
                          height: 20,
                        ),
                        Text(
                          "Aman gets no1 in react developer and flutter,PM also appreacite it",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 25),
                        ),
                        Divider(
                          height: 20,
                        ),
                        Text(
                          "Aman gets no1 in react developer and flutter,PM also appreacite itAman gets no1 in react developer and flutter,PM also appreacite itAman gets no1 in react developer and flutter,PM also appreacite it",
                          style: TextStyle(fontSize: 20),
                        ),
                        Divider(
                          height: 190,
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
