import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:rewear/model/user.dart' as UserModel;
import 'package:rewear/screens/user_item.dart';
import 'package:rewear/service/firebase_firestore_service.dart';
import 'package:rewear/utils/colors.dart';

import '../providers/firebase_provider.dart';

class ChatsScreen extends StatefulWidget {
  const ChatsScreen({super.key});

  @override
  State<ChatsScreen> createState() => _ChatsScreenState();
}

class _ChatsScreenState extends State<ChatsScreen> {
  // with WidgetsBindingObserver
  // final notificationService = NotificationsService();
  @override
  void initState() {
    super.initState();
    Provider.of<FirebaseProvider>(context, listen: false).getAllUsers();
  }

  // @override
  // void didChangeAppLifecycleState(AppLifecycleState state) {
  //   super.didChangeAppLifecycleState(state);

  //   switch (state) {
  //     case AppLifecycleState.resumed:
  //       FirebaseFirestoreService.updateUserData({
  //         'lastActive': DateTime.now(),
  //         'isOnline': true,
  //       });
  //       break;

  //     case AppLifecycleState.inactive:
  //     case AppLifecycleState.paused:
  //     case AppLifecycleState.detached:
  //       FirebaseFirestoreService.updateUserData({'isOnline': false});
  //       break;
  //   }
  // }

  @override
  void dispose() {
    // WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: coolGrey,
        title: SvgPicture.asset(
          'assets/ReWear.svg',
          height: 100,
        ),
      ),
      body: Consumer<FirebaseProvider>(builder: (context, value, child) {
        return ListView.separated(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          itemCount: value.users.length,
          separatorBuilder: (context, index) => const SizedBox(height: 10),
          physics: const BouncingScrollPhysics(),
          itemBuilder: (context, index) =>
              value.users[index].uid != FirebaseAuth.instance.currentUser?.uid
                  ? UserItem(user: value.users[index])
                  : const SizedBox(),
        );
      }),
    );
  }
}
