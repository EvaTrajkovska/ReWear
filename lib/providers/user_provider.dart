import 'package:flutter/material.dart';
import 'package:rewear/model/user.dart';
import 'package:rewear/resources/authentication_metods.dart';

class UserProvider with ChangeNotifier {
  User? _user;
  final AuthenticationMetods _authMethods = AuthenticationMetods();

  User get getUser => _user!;

  Future<void> refreshUser() async {
    User user = await _authMethods.getUserDetails();
    _user = user;
    notifyListeners();
  }
}