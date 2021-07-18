// ignore: file_names
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:job/Auth/user_provider.dart';
import 'package:job/constant/constant.dart';
import 'package:job/screens/FormPage.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  FirebaseAuth _auth = FirebaseAuth.instance;
  User? currentUser = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<UserProvider>(context);
    if (currentUser != null) {
      provider.checkAdmin(userEmail: currentUser!.email);
    } else {
      provider.checkAdmin(userEmail: 'false');
    }
    return Scaffold(
      floatingActionButton: Visibility(
        visible: provider.getIsAdmin(),
        child: FloatingActionButton(
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => FormPage(),
                ));
          },
          backgroundColor: Colors.deepPurple,
          child: Icon(
            Icons.add,
            size: 25,
          ),
        ),
      ),
      backgroundColor: Color(0XFFFDF6F0),
      appBar: AppBar(
        title: Center(
          child: Text(
            "Jobs For You",
            style: kAppBarStyle,
          ),
        ),
        backgroundColor: Colors.deepPurple,
      ),
      body: ListView.builder(
        itemCount: 20,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Card(
              color: Color(0xFFF1F1F1),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20))),
              elevation: 3,
              shadowColor: Colors.grey,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  child: Column(
                    children: [
                      Text(
                        "Company Name",
                        style: TextStyle(
                            fontSize: largeFontSize,
                            fontWeight: FontWeight.w900,
                            fontFamily: 'OpenSans-Regular'),
                      ),
                      Divider(),
                      ListTile(
                        leading: Icon(
                          Icons.cast_for_education,
                          color: Colors.deepPurple,
                        ),
                        title: Text(
                          "Degree:: BSc MCA Btech",
                          style: kmediumTextStyle,
                        ),
                      ),
                      ListTile(
                        leading: Icon(
                          Icons.account_box,
                          color: Colors.deepPurple,
                        ),
                        title: Text(
                          "Position:: SD1",
                          style: kmediumTextStyle,
                        ),
                      ),
                      ListTile(
                        leading: Icon(
                          Icons.post_add,
                          color: Colors.deepPurple,
                        ),
                        title: Text(
                          "Posted On:: 2 june 2020",
                          style: kmediumTextStyle,
                        ),
                      ),
                      ListTile(
                        leading: Icon(
                          Icons.source,
                          color: Colors.deepPurple,
                        ),
                        title: Text(
                          "Source:: Linkedin",
                          style: kmediumTextStyle,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                        child: FlatButton(
                          minWidth: MediaQuery.of(context).size.width,
                          onPressed: () {},
                          child: Text(
                            "Apply",
                            style: TextStyle(
                                fontFamily: 'OpenSans-Regular',
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1),
                          ),
                          color: Colors.green,
                          shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10))),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
