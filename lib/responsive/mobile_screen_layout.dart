import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rewear/utils/colors.dart';
import 'package:rewear/utils/home_screen_items.dart';

class MobileScreenLayout extends StatefulWidget {
  const MobileScreenLayout({Key? key}) : super(key: key);

  @override
  State<MobileScreenLayout> createState() => _MobileScreenLayoutState();
}

class _MobileScreenLayoutState extends State<MobileScreenLayout> {

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
    return Scaffold(
        body: PageView(
          controller: pageController,
          onPageChanged: onPageChanged,
          physics: const NeverScrollableScrollPhysics(),
          children: homeScreenItems,
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
              backgroundColor: blueGrey,
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
              icon: Icon(Icons.person, color: _page == 4 ? blueGrey : warmGrey),
              //label: '',
              backgroundColor: warmGrey,
            ),
          ],
          onTap: navigationTapped,
        ));
  }
}
