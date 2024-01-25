import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:rewear/providers/user_provider.dart';
import 'package:rewear/resources/authentication_metods.dart';
//import 'package:rewear/resources/firestore_methods.dart';
import 'package:rewear/screens/login_screen.dart';
import 'package:rewear/utils/colors.dart';
//import 'package:rewear/widgets/follow_button.dart';
import 'package:rewear/resources/database_method.dart';
import 'package:rewear/utils/colors.dart';
import 'package:rewear/utils/imagePickerAndSnackBar.dart';
import 'package:rewear/model/user.dart' as model;
import 'package:rewear/widgets/single_user_profile_header.dart';
import 'package:rewear/widgets/user_profile_header.dart';

class ProfileScreen extends StatefulWidget {
  // final String uid;
   const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {

  // var userData = {};
  // int postLen = 0;
  // int followers = 0;
  // int following = 0;
  // bool isFollowing = false;
  // bool isLoading = false;
  //
  // @override
  // void initState() {
  //   super.initState();
  //   getData();
  // }
  //
  // getData() async {
  //   setState(() {
  //     isLoading = true;
  //   });
  //   try {
  //     var userSnap = await FirebaseFirestore.instance
  //         .collection('users')
  //         .doc(widget.uid)
  //         .get();
  //
  //     // get post lENGTH
  //     var postSnap = await FirebaseFirestore.instance
  //         .collection('posts')
  //         .where('uid', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
  //         .get();
  //
  //     postLen = postSnap.docs.length;
  //     userData = userSnap.data()!;
  //     followers = userSnap.data()!['followers'].length;
  //     following = userSnap.data()!['following'].length;
  //     isFollowing = userSnap
  //         .data()!['followers']
  //         .contains(FirebaseAuth.instance.currentUser!.uid);
  //     setState(() {});
  //   } catch (e) {
  //     showSnackBar(context, e.toString(),);
  //   }
  //   setState(() {
  //     isLoading = false;
  //   });

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final model.User user = userProvider.getUser;
    String username = user.username ?? 'No Name';

    return Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          backgroundColor: Color.fromARGB(0, 245, 234, 234),
          title: SvgPicture.asset(
            'assets/ReWear.svg',
            height: 100,
          ),
        ),
    body: Padding(
    padding: const EdgeInsets.all(18.0),
    child: Column(
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      const Divider(),
    SingleUserProfileHeader(username: username),
    const Divider(),
      ],
    )
    )
    );
  }
}