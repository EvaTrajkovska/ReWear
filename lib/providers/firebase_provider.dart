import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../model/message.dart';
import '../model/user.dart' as UserModel;
import '../service/firebase_firestore_service.dart';

class FirebaseProvider extends ChangeNotifier {
  ScrollController scrollController = ScrollController();

  List<UserModel.User> users = [];
  UserModel.User? user;
  List<Message> messages = [];
  List<UserModel.User> search = [];
  List<UserModel.User> chatUsers = [];

  List<UserModel.User> getAllUsers() {
    FirebaseFirestore.instance
        .collection('users')
        .snapshots(includeMetadataChanges: true)
        .listen((users) {
      this.users =
          users.docs.map((doc) => UserModel.User.fromJson(doc.data())).toList();
      //print(users);
      notifyListeners();
    });
    return users;
  }

  UserModel.User? getUserById(String userId) {
    FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .snapshots(includeMetadataChanges: true)
        .listen((user) {
      this.user = UserModel.User.fromJson(user.data()!);
      notifyListeners();
    });
    return user;
  }

  List<Message> getMessages(String receiverId) {
    FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('chat')
        .doc(receiverId)
        .collection('messages')
        .orderBy('sentTime', descending: false)
        .snapshots(includeMetadataChanges: true)
        .listen((messages) {
      this.messages =
          messages.docs.map((doc) => Message.fromJson(doc.data())).toList();
      notifyListeners();

      scrollDown();
    });
    return messages;
  }

  void scrollDown() => WidgetsBinding.instance.addPostFrameCallback((_) {
        if (scrollController.hasClients) {
          scrollController.jumpTo(scrollController.position.maxScrollExtent);
        }
      });

  // void getChatUsers() async {
  //   try {
  //     String currentUserId = FirebaseAuth.instance.currentUser!.uid;
  //     var chatQuerySnapshot = await FirebaseFirestore.instance
  //         .collection('users')
  //         .doc(currentUserId)
  //         .collection('chat')
  //         .get();

  //     List<String> userIds = [];
  //     for (var doc in chatQuerySnapshot.docs) {
  //       userIds.add(doc.id);
  //     }

  //     List<UserModel.User> fetchedUsers = [];
  //     for (var userId in userIds) {
  //       var userSnapshot = await FirebaseFirestore.instance
  //           .collection('users')
  //           .doc(userId)
  //           .get();

  //       if (userSnapshot.exists) {
  //         fetchedUsers.add(UserModel.User.fromJson(userSnapshot.data()!));
  //       }
  //     }

  //     chatUsers = fetchedUsers;
  //     notifyListeners();
  //   } catch (e) {
  //     print('Error fetching chat users: $e');
  //   }
  // }
}
