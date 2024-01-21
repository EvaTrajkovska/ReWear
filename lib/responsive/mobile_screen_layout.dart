import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rewear/utils/colors.dart';
// import 'package:provider/provider.dart';
// import 'package:rewear/providers/user_provider.dart';
// import 'package:rewear/utils/colors.dart';
// import 'package:rewear/model/user.dart' as model;
import 'package:rewear/utils/home_screen_items.dart';

class MobileScreenLayout extends StatefulWidget {
  const MobileScreenLayout({Key? key}) : super(key: key);

  @override
  State<MobileScreenLayout> createState() => _MobileScreenLayoutState();
}

class _MobileScreenLayoutState extends State<MobileScreenLayout> {
  // String username = "";
  //  @override
  //   void initState(){
  //    super.initState();
  //    getUsername();
  //  }
  //
  //  void getUsername() async{R
  //   DocumentSnapshot snap = await FirebaseFirestore.instance
  //       .collection('users')
  //       .doc(FirebaseAuth.instance.currentUser!.uid)
  //       .get();
  //   print(snap.data());
  //   setState(() {
  //     username = (snap.data() as Map<String,dynamic>)['username'];
  //
  //   });
  //
  //  }
  int _page = 0;
  late PageController pageController;
  @override
  void initState() {
    super.initState();
    pageController = PageController();
  }

  @override
  void dispose() {
    super.dispose();
    pageController.dispose();
  }

  void onPageChanged(int page) {
    setState(() {
      _page = page;
    });
  }

  void navigationTapped(int page) {
    pageController.jumpToPage(page);
  }

  @override
  Widget build(BuildContext context) {
    // model.User user = Provider.of<UserProvider>(context).getUser;
    return Scaffold(
        body: PageView(
          controller: pageController,
          onPageChanged: onPageChanged,
          physics: NeverScrollableScrollPhysics(),
          children: [
            Text('feed/home'),
            Text('messages'),
            Text('add post'),
            Text('saved'),
            Text('notifications'),
            Text('profile'),
          ],
        ),
        bottomNavigationBar: CupertinoTabBar(
          backgroundColor: secondaryColor,
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.home, color: _page == 0 ? blueGrey : warmGrey),
              // label: '',
              backgroundColor: warmGrey,
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.message_outlined,
                  color: _page == 1 ? blueGrey : warmGrey),
              //label: '',
              backgroundColor: warmGrey,
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.add_circle_outline,
                  color: _page == 2 ? blueGrey : warmGrey),
              // label: '',
              backgroundColor: warmGrey,
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.bookmark_border,
                  color: _page == 3 ? blueGrey : warmGrey),
              //label: '',
              backgroundColor: warmGrey,
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.favorite_border_rounded,
                  color: _page == 4 ? blueGrey : warmGrey),
              // label: '',
              backgroundColor: warmGrey,
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person, color: _page == 5 ? blueGrey : warmGrey),
              //label: '',
              backgroundColor: warmGrey,
            ),
          ],
          onTap: navigationTapped,
        ));
  }
}
