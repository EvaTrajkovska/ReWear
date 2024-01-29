import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:rewear/screens/add_post_screen.dart';
import 'package:rewear/screens/chat_screen.dart';
import 'package:rewear/screens/chats_screen.dart';
import 'package:rewear/screens/favorites_screen.dart';
import 'package:rewear/screens/feed_screen.dart';
import 'package:rewear/screens/profile_screen.dart';
import 'package:rewear/widgets/chat_messages.dart';

final homeScreenItems = [
  FeedScreen(),
  ChatsScreen(),
  AddPostScreen(),
  SavedPostsScreen(userId: FirebaseAuth.instance.currentUser!.uid,),
  Text('notifications'),
  ProfileScreen(
    uid: FirebaseAuth.instance.currentUser!.uid,
  ),
];
