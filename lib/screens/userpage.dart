import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:job/Auth/log_in.dart';
import 'package:job/Auth/user_provider.dart';
import 'package:provider/provider.dart';

class UserPage extends StatefulWidget {
  @override
  _UserPageState createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  FirebaseAuth _auth = FirebaseAuth.instance;
  User? currentUser = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<UserProvider>(context);
    provider.checkAdmin(userEmail: currentUser!.email);
    return SafeArea(
      child: Scaffold(
        body: StreamBuilder<User?>(
          stream: _auth.authStateChanges(),
          builder: (context, user) {
            if (user.data != null) {
              return Column(children: [
                CircleAvatar(
                    radius: 30.0,
                    backgroundImage: (user.data!.photoURL.toString().isEmpty)
                        ? NetworkImage(user.data!.photoURL.toString())
                        : null),
                Text('${user.data!.displayName}'),
                Text('${provider.getIsAdmin()}'),
                TextButton(
                  child: Text('Sign Out'),
                  onPressed: () {
                    if (provider.checkUserType()) {
                      provider.logout();
                    } else {
                      _auth.signOut();
                    }
                  },
                ),
              ]);
            } else {
              return TextButton(
                child: Text('Sign In'),
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => LogIn()));
                },
              );
            }
          },
        ),
      ),
    );
  }
}
