// ignore: file_names
import 'package:cloud_firestore/cloud_firestore.dart';
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

  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<DocumentSnapshot> _products = [];
  List<DocumentSnapshot> reversedList = [];
  bool _loadingProducts = true;

  _getcompanyData() async {
    //fetching data from firebase

    var time = Timestamp.now();

    Query q = _firestore.collection("companyData").orderBy("timeStamp",
        descending: true); //calling according to timestamp
    setState(() {
      _loadingProducts = true;
    });
    QuerySnapshot querySnapshot = await q.get();

    _products = querySnapshot.docs;
    setState(() {
      _loadingProducts = false;
    });
    print(_products[0]["company_name"]);
    print(_products.length);
  }

  //revese the data

  reverseSort() {
    reversedList = new List.from(_products.reversed);

    setState(() {
      _products = reversedList;
    });
  }

  void _delete_Data(product) async {
    var dataId = "";
    await _firestore
        .collection("companyData")
        .where("company_name", isEqualTo: product)
        .get()
        .then((QuerySnapshot snapshot) {
      snapshot.docs.forEach((f) {
        print("documentId " + f.reference.id);
        dataId = f.reference.id;
      });
    });

    await _firestore
        .collection("companyData")
        .doc(dataId)
        .delete()
        .then((value) => _getcompanyData())
        .catchError((error) => print("error"));
  }

  @override
  void initState() {
    super.initState();

    _getcompanyData();
  }

  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;

    var provider = Provider.of<UserProvider>(context);
    provider.kSetScreenHeight(screenHeight);

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
        leading: Visibility(
          visible: provider.getIsAdmin(),
          child: InkWell(
              onTap: () {
                reverseSort();
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Icon(Icons.sort_by_alpha_outlined),
                  Text(
                    "${_products.length}",
                    style: kmediumTextStyle,
                  )
                ],
              )),
        ),
      ),
      body: _products.length == 0
          ? Center(
              child: Text("Loading"),
            )
          : RefreshIndicator(
              onRefresh: () async {
                return await _getcompanyData();
              },
              child: ListView.builder(
                itemCount: _products.length,
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
                                _products[index]["company_name"],
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
                                  "Degree:: ${_products[index]["degree_required"]}",
                                  style: kmediumTextStyle,
                                ),
                              ),
                              ListTile(
                                leading: Icon(
                                  Icons.account_box,
                                  color: Colors.deepPurple,
                                ),
                                title: Text(
                                  "Position::  ${_products[index]["position"]}",
                                  style: kmediumTextStyle,
                                ),
                              ),
                              ListTile(
                                leading: Icon(
                                  Icons.post_add,
                                  color: Colors.deepPurple,
                                ),
                                title: Text(
                                  "Posted On::  ${_products[index]["time"]}",
                                  style: kmediumTextStyle,
                                ),
                              ),
                              ListTile(
                                leading: Icon(
                                  Icons.source,
                                  color: Colors.deepPurple,
                                ),
                                title: Text(
                                  "Source::  ${_products[index]["source"]}",
                                  style: kmediumTextStyle,
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(16, 8, 16, 8),
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
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(10))),
                                ),
                              ),
                              Visibility(
                                visible: provider.getIsAdmin(),
                                child: Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(16, 8, 16, 8),
                                  child: FlatButton(
                                    minWidth: MediaQuery.of(context).size.width,
                                    onPressed: () {
                                      _delete_Data(
                                          _products[index]["company_name"]);
                                    },
                                    child: Text(
                                      "Delete",
                                      style: TextStyle(
                                          fontFamily: 'OpenSans-Regular',
                                          color: Colors.white,
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          letterSpacing: 1),
                                    ),
                                    color: Colors.red,
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10))),
                                  ),
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
            ),
    );
  }
}
