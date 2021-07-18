import 'package:flutter/cupertino.dart';

class UserProvider extends ChangeNotifier {
  List<String> admin = [
    'goswamiajay300@gmail.com',
    'amanthapliyal14@gmail.com'
  ];
  bool isAdmin = false;
  Future<bool> checkAdmin({required String userEmail}) async {
    if (admin.contains(userEmail)) {
      isAdmin = true;
      return isAdmin;
    } else {
      return isAdmin;
    }
  }
}
