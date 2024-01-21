import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:rewear/model/user.dart' as model;

class AuthenticationMetods {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  // sign up
  Future<String> signUpUser({
    required String name,
    required String surname,
    required String username,
    required String email,
    required String password,
    //required Uint8List file,
  }) async {
    String res = "Some error Occurred";
    try {
      if (name.isNotEmpty ||
          surname.isNotEmpty ||
          username.isNotEmpty ||
          email.isNotEmpty ||
          password.isNotEmpty) {
        // registering user in auth with email and password
        UserCredential cred = await _auth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );
        print(cred.user!.uid);

        // add user in database
        model.User user = model.User(
            name: name,
            surname: surname,
            username: username,
            email: email,
            password: password,
            uid: cred.user!.uid,
            rating: [],
            likes: [],
            following: [],
            followers: []
        );
        await _firestore.collection("users").doc(cred.user!.uid).set(user.toJson());

        res = "success";
        print(res);
      } else {
        res = "Please enter all the fields";
      }
    } catch (err) {
      return err.toString();
    }
    return res;
  }

  // logging in user
  Future<String> loginUser({
    required String email,
    required String password,
  }) async {
    String res = "Error";
    try {
      if (email.isNotEmpty || password.isNotEmpty) {
        // logging in user with email and password
        await _auth.signInWithEmailAndPassword(
          email: email,
          password: password,
        );
        res = "success";
      } else {
        res = "Please enter all the fields";
      }
    } catch (err) {
      return err.toString();
    }
    print(res);
    return res;
  }
}
