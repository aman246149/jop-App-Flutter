import 'package:flutter/material.dart';
import 'package:job/screens/BlogPage.dart';
import 'package:job/screens/HomeScreen.dart';
import 'package:job/screens/userpage.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

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
  int _pageIndex = 0;
  PageController? _pageController;

  List<Widget> tabPages = [
    HomeScreen(),
    BlogPage(),
    UserPage(),
  ];

  @override
  void initState() {
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
              icon: Icon(Icons.mail, color: Colors.deepPurple), label: "Blog"),
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
