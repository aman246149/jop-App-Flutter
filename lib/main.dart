import 'package:flutter/material.dart';
import 'package:job/screens/BlogPage.dart';
import 'package:job/screens/HomeScreen.dart';
import 'package:job/screens/userpage.dart';

// Import the firebase_core plugin
import 'package:firebase_core/firebase_core.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyBottomBarDemo(),
    );
  }
}

// ignore: use_key_in_widget_constructors
class MyBottomBarDemo extends StatefulWidget {
  @override
  _MyBottomBarDemoState createState() => _MyBottomBarDemoState();
}

class _MyBottomBarDemoState extends State<MyBottomBarDemo> {
  // Set default `_initialized` and `_error` state to false
  bool _initialized = false;
  bool _error = false;

  // Define an async function to initialize FlutterFire
  void initializeFlutterFire() async {
    try {
      // Wait for Firebase to initialize and set `_initialized` state to true
      await Firebase.initializeApp();
      setState(() {
        _initialized = true;
      });
    } catch (e) {
      // Set `_error` state to true if Firebase initialization fails
      setState(() {
        _error = true;
      });
    }
  }

  int _pageIndex = 0;
  PageController? _pageController;

  List<Widget> tabPages = [
    HomeScreen(),
    BlogPage(),
    UserPage(),
  ];

  @override
  void initState() {
    initializeFlutterFire(); //initiazlize flutter app function
    super.initState();
    _pageController = PageController(initialPage: _pageIndex);
  }

  @override
  void dispose() {
    _pageController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_error) {  //if error comes 
      return Center(child: Text("SomeThing Went Wrong"));
    } else if (!_initialized) { //when firebase time to load
      return Center(
        child: Text("Loading..."),
      );
    } else {   //wheneverything gone right than we render widget
      return Scaffold(
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _pageIndex,
          onTap: onTabTapped,
          backgroundColor: Colors.white,
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(
                Icons.home,
                color: Colors.deepPurple,
              ),
              label: "Home",
            ),
            BottomNavigationBarItem(
                icon: Icon(Icons.mail, color: Colors.deepPurple),
                label: "Blog"),
            BottomNavigationBarItem(
                icon: Icon(Icons.person, color: Colors.deepPurple),
                label: "Profile"),
          ],
        ),
        body: PageView(
          children: tabPages,
          onPageChanged: onPageChanged,
          controller: _pageController,
        ),
      );
    }
  }

  void onPageChanged(int page) {
    setState(() {
      this._pageIndex = page;
    });
  }

  void onTabTapped(int index) {
    this._pageController!.animateToPage(index,
        duration: const Duration(milliseconds: 500), curve: Curves.easeInOut);
  }
}
