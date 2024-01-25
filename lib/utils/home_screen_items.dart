import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:rewear/screens/add_post_screen.dart';
import 'package:rewear/screens/feed_screen.dart';
import 'package:rewear/screens/profile_screen.dart';

final homeScreenItems = [
  FeedScreen(),
  Text('messages'),
  AddPostScreen(),
  Text('saved'),
  Text('notifications'),
  ProfileScreen(
    uid: FirebaseAuth.instance.currentUser!.uid,
  ),
];
