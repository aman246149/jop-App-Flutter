import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_sign_in/google_sign_in.dart';

class UserProvider extends ChangeNotifier {
  List<String?> admin = [
    'goswamiajay300@gmail.com',
    'amanthapliyal14@gmail.com'
  ];
  var googleSignIn = GoogleSignIn();
  FirebaseAuth _auth = FirebaseAuth.instance;
  bool isLogedIn = false;

  void setIsloogedIn(bool state) {
    isLogedIn = state;
    notifyListeners();
  }

  bool _isGoogleUser = false;
  Future login() async {
    try {
      final user = await googleSignIn.signIn();
      if (user != null) {
        final googleAuth = await user.authentication;
        final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );
        UserCredential? userCred = await _auth.signInWithCredential(credential);
        _isGoogleUser = true;
        setIsloogedIn(true);
        User? currentUser = userCred.user;
        if (currentUser != null) {
          checkAdmin(userEmail: currentUser.email);
          currentUser.updateDisplayName(user.displayName);
          currentUser.updatePhotoURL(user.photoUrl);
        }
      }
    } catch (e) {
      print(e);
    }
  }

  bool checkUserType() {
    return _isGoogleUser;
  }

  void logout() async {
    await googleSignIn.disconnect();
    _auth.signOut();
    setIsloogedIn(false);
  }

  bool _isAdmin = false;
  void checkAdmin({required String? userEmail}) async {
    if (admin.contains(userEmail)) {
      _isAdmin = true;
    } else {
      _isAdmin = false;
    }
  }

  var _screenHeight;

  void kSetScreenHeight(var screenHeight) {
    _screenHeight = screenHeight;
  }

  kGetScreenHeight() {
    return _screenHeight;
  }

  bool getIsAdmin() => _isAdmin;
}
