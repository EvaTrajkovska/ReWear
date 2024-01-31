import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:rewear/model/user.dart' as model;

class AuthenticationMethods {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Fetches user details from Firestore
  Future<model.User> getUserDetails() async {
    User currentUser = _auth.currentUser!;
    DocumentSnapshot snap =
        await _firestore.collection('users').doc(currentUser.uid).get();
    return model.User.fromSnap(snap);
  }

  // Signs up a user and adds them to Firestore, including isPremium status
  Future<String> signUpUser({
    required String name,
    required String surname,
    required String username,
    required String email,
    required String password,
    bool isPremium = false, // Default isPremium to false for new signups
  }) async {
    String res = "Some error Occurred";
    try {
      if (name.isNotEmpty &&
          surname.isNotEmpty &&
          username.isNotEmpty &&
          email.isNotEmpty &&
          password.isNotEmpty) {
        UserCredential cred = await _auth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );

        // Create a new user object with isPremium status
        model.User user = model.User(
          name: name,
          surname: surname,
          username: username,
          email: email,
          password: password, // Ensure secure handling of passwords
          uid: cred.user!.uid,
          followers: [],
          following: [],
          rating: [],
          likes: [],
          isPremium: isPremium,
        );

        // Add the user to Firestore
        await _firestore
            .collection("users")
            .doc(cred.user!.uid)
            .set(user.toJson());

        res = "success";
      } else {
        res = "Please enter all the fields";
      }
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  // Logs in a user with email and password
  Future<String> loginUser({
    required String email,
    required String password,
  }) async {
    String res = "Error";
    try {
      if (email.isNotEmpty && password.isNotEmpty) {
        await _auth.signInWithEmailAndPassword(
          email: email,
          password: password,
        );
        res = "success";
      } else {
        res = "Please enter all the fields";
      }
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  // Signs out the current user
  Future<void> signOut() async {
    await _auth.signOut();
  }
}
