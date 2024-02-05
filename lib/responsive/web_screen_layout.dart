import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:rewear/screens/feed.dart';
import 'package:rewear/screens/search_screen.dart';
import 'package:rewear/utils/colors.dart';
import 'package:rewear/utils/home_screen_items.dart';

class WebScreenLayout extends StatefulWidget {
  const WebScreenLayout({Key? key}) : super(key: key);

  @override
  State<WebScreenLayout> createState() => _WebScreenLayoutState();
}

class _WebScreenLayoutState extends State<WebScreenLayout> {
  int _page = 0;
  late PageController pageController; // for tabs animation

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
    //Animating Page
    pageController.jumpToPage(page);
    setState(() {
      _page = page;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: coolGrey,
        centerTitle: false,
        title: GestureDetector(
          onTap: () => navigationTapped(0),
          child: SvgPicture.asset(
            'assets/ReWear.svg',
            height: 100,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.home_outlined,
              color: _page == 0 ? blueGrey : warmGrey,
            ),
            onPressed: () => navigationTapped(0),
          ),
          IconButton(
            icon: const Icon(
              Icons.search,
              color: warmGrey,
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SearchScreen()),
              );
            },
          ),
          IconButton(
            icon: Icon(
              Icons.message_outlined,
              color: _page == 1 ? blueGrey : warmGrey,
            ),
            onPressed: () => navigationTapped(1),
          ),
          IconButton(
            icon: Icon(
              Icons.add_circle_outline,
              color: _page == 2 ? blueGrey : warmGrey,
            ),
            onPressed: () => navigationTapped(2),
          ),
          IconButton(
            icon: Icon(
              Icons.bookmark_border_rounded,
              color: _page == 3 ? blueGrey : warmGrey,
            ),
            onPressed: () => navigationTapped(3),
          ),
          IconButton(
            icon: Icon(
              Icons.person_outline,
              color: _page == 4 ? blueGrey : warmGrey,
            ),
            onPressed: () => navigationTapped(5),
          ),
        ],
      ),
      body: PageView(
        physics: const NeverScrollableScrollPhysics(),
        controller: pageController,
        onPageChanged: onPageChanged,
        children: homeScreenItems,
      ),
    );
  }
}
