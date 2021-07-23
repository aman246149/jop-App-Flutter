// ignore: file_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:job/Auth/user_provider.dart';
import 'package:job/constant/constant.dart';
import 'package:job/screens/FormPage.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  FirebaseAuth _auth = FirebaseAuth.instance;
  User? currentUser = FirebaseAuth.instance.currentUser;
  late FToast fToast;
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<DocumentSnapshot> _products = [];
  List<DocumentSnapshot> reversedList = [];
  List<bool> isBookmarked = [];
  bool _loadingProducts = true;
  bool isBookmarkScreen = false;

  getIsBookmarked() async {
    List<bool> result = [];
    for (int i = 0; i < _products.length; i++) {
      await _firestore
          .collection('BookMarks')
          .doc(_auth.currentUser!.uid.toString())
          .collection('user_bookmarks')
          .where('docRef', isEqualTo: _products[i].id.toString())
          .get()
          .then((value) => (value.size != 0)
              ? result.insert(i, true)
              : result.insert(i, false));
    }
    print(result);
    setState(() {
      isBookmarked = result;
    });
  }

  getBoomarks() async {
    List<DocumentSnapshot> _bookMarks = [];
    bool checkFound = false;
    await _firestore
        .collection('BookMarks')
        .doc(_auth.currentUser!.uid.toString())
        .collection('user_bookmarks')
        .get()
        .then((value) => value.docs.forEach((f) async {
              checkFound = false;
              for (int i = 0; i < _products.length; i++) {
                if (_products[i].id.toString() == f.get('docRef')) {
                  _bookMarks.add(_products[i]);
                  checkFound = true;
                }
              }
              if (checkFound == false) {
                deleteBookMark(f.get('docRef'));
              }
            }));

    print(_bookMarks.length);
    setState(() {
      _products = _bookMarks;
    });
  }

  toogleScreen() async {
    if (isBookmarkScreen) {
      await getBoomarks();
      getIsBookmarked();
    } else {
      await _getcompanyData();
      getIsBookmarked();
    }
  }

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
        .where("timeStamp", isEqualTo: product)
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
    deleteBookMark(product);
    getIsBookmarked();
  }

  //implementing share job functionality
  void shareJobInfo(product) async {
    await Share.share(
        'check out your friends send you this job link ${product}');
    ;
    print("Called");
  }

  deleteBookMark(var productId) async {
    var dataId;
    await _firestore
        .collection('BookMarks')
        .doc(_auth.currentUser!.uid.toString())
        .collection('user_bookmarks')
        .where('docRef', isEqualTo: productId)
        .get()
        .then((value) => value.docs.forEach((f) {
              print("documentId " + f.reference.id);
              dataId = f.reference.id;
            }));

    await _firestore
        .collection('BookMarks')
        .doc(_auth.currentUser!.uid.toString())
        .collection('user_bookmarks')
        .doc(dataId)
        .delete()
        .then((value) => getIsBookmarked());
  }

  void initialize() async {
    await _getcompanyData();
    if (_auth.currentUser != null) {
      Provider.of<UserProvider>(context, listen: false).setIsloogedIn(true);
      getIsBookmarked();
    } else {
      fToast = FToast();
      fToast.init(context);
    }
  }

  @override
  void initState() {
    super.initState();
    initialize();
  }

  _showToast() {
    Widget toast = Container(
      padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 12.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25.0),
        color: Colors.redAccent,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.check),
          SizedBox(
            width: 12.0,
          ),
          Text(
            "Please Sign Up to bookmark your Preference",
            style: TextStyle(fontSize: 16.0, color: Colors.white),
          ),
        ],
      ),
    );

    fToast.showToast(
      child: toast,
      gravity: ToastGravity.TOP_RIGHT,
      toastDuration: Duration(seconds: 2),
    );
  }

  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<UserProvider>(context);
    var screenHeight = MediaQuery.of(context).size.height;
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
            ),
          ),
        ),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 20),
            child: IconButton(
              onPressed: () {
                provider.isLogedIn
                    ? {
                        setState(() {
                          (isBookmarkScreen)
                              ? isBookmarkScreen = false
                              : isBookmarkScreen = true;
                        }),
                        toogleScreen()
                      }
                    : {_showToast()};
              },
              icon: Icon(isBookmarkScreen ? Icons.home : Icons.bookmark_add),
            ),
          )
        ],
      ),
      body: _products.length == 0
          ? Center(
              child: Text("Loading"),
            )
          : RefreshIndicator(
              onRefresh: () async {
                await _getcompanyData();
                if (provider.isLogedIn) {
                  await getIsBookmarked();
                }
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
                              Visibility(
                                visible: (provider.isLogedIn),
                                child: ListTile(
                                  leading: GestureDetector(
                                    onTap: () async {
                                      (isBookmarked[index])
                                          ? {
                                              deleteBookMark(_products[index]
                                                  .id
                                                  .toString())
                                            }
                                          : {
                                              await _firestore
                                                  .collection("BookMarks")
                                                  .doc(_auth.currentUser!.uid
                                                      .toString())
                                                  .collection('user_bookmarks')
                                                  .add({
                                                'docRef': _products[index]
                                                    .id
                                                    .toString(),
                                              }),
                                              getIsBookmarked()
                                            };
                                    },
                                    child: Icon(Icons.bookmark_add_rounded,
                                        color: isBookmarked.length ==
                                                _products.length
                                            ? isBookmarked[index]
                                                ? Colors.deepPurpleAccent
                                                : Colors.blueGrey[200]
                                            : Colors.white54),
                                  ),
                                  title: Text(
                                    _products[index]["company_name"],
                                    style: TextStyle(
                                        fontSize: largeFontSize,
                                        fontWeight: FontWeight.w900,
                                        fontFamily: 'OpenSans-Regular'),
                                  ),
                                  trailing: IconButton(
                                    icon: Icon(Icons.share),
                                    onPressed: () {
                                      shareJobInfo(_products[index]["joburl"]);
                                    },
                                  ),
                                ),
                              ),
                              // Divider(),
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
                                  onPressed: () async {
                                    await canLaunch(_products[index]["joburl"])
                                        ? await launch(
                                            _products[index]["joburl"])
                                        : throw 'Could not launch url';
                                  },
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
                                      print(_products[index]["timeStamp"]);
                                      _delete_Data(
                                          _products[index]["timeStamp"]);
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
