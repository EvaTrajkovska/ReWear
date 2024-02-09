import 'package:flutter/material.dart';
import 'package:rewear/model/user.dart';
import 'package:rewear/resources/authentication_metods.dart';

class UserProvider with ChangeNotifier {
  User? _user;
  final AuthenticationMethods _authMethods = AuthenticationMethods();

  User get getUser => _user!;

  Future<void> refreshUser() async {
    User user = await _authMethods.getUserDetails();
    _user = user;
    notifyListeners();
  }

  void clearUser() {
    _user = null;
    notifyListeners();
  }
}
