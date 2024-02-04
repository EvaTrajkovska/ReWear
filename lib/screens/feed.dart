import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rewear/utils/dimensions.dart';
import 'package:rewear/screens/search_screen.dart';
import 'package:rewear/utils/colors.dart';
import 'package:rewear/widgets/small_box_card.dart';

class FeedScreen extends StatefulWidget {
  const FeedScreen({super.key});

  @override
  State<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  Map<String, Future<bool>> userPremiumStatusCache = {};
  final ScrollController regularPostsController = ScrollController();
  final ScrollController premiumPostsController = ScrollController();

  @override
  void dispose() {
    regularPostsController.dispose();
    premiumPostsController.dispose();
    super.dispose();
  }

  Future<bool> _checkIfUserIsPremium(String userId) async {
    if (!userPremiumStatusCache.containsKey(userId)) {
      userPremiumStatusCache[userId] = FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get()
          .then((doc) => doc.data()?['isPremium'] ?? false);
    }
    return userPremiumStatusCache[userId]!;
  }

  Future<void> _populatePostLists(
    List<DocumentSnapshot<Map<String, dynamic>>> allPosts,
    List<DocumentSnapshot<Map<String, dynamic>>> premiumPosts,
    List<DocumentSnapshot<Map<String, dynamic>>> regularPosts,
  ) async {
    for (var post in allPosts) {
      var isPremium = await _checkIfUserIsPremium(post['uid']);
      var isSold = post['sold'] ?? false;
      if(!isSold){
      if (isPremium) {
        premiumPosts.add(post);
      } else {
        regularPosts.add(post);
    }
     }
    }
  }

  Widget _buildPostGrid(List<DocumentSnapshot> posts, bool isPremiumList,
      BuildContext context, ScrollController controller, String headerText) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.all(8.0),
          child: Center(
            child: Text(
              headerText,
              style: TextStyle(
                  fontSize: 24, color: greenColor, fontWeight: FontWeight.bold),
            ),
          ),
        ),
        Expanded(
          child: CustomScrollView(
            controller: controller,
            slivers: [
              SliverGrid(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  childAspectRatio: 0.7,
                ),
                delegate: SliverChildBuilderDelegate(
                  (BuildContext context, int index) {
                    return FutureBuilder<bool>(
                      future: _checkIfUserIsPremium(posts[index]['uid']),
                      builder: (context, AsyncSnapshot<bool> snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Container();
                        }
                        var data = posts[index].data() as Map<String, dynamic>?;
                        if (snapshot.data == isPremiumList && data != null) {
                          return buildPostCard(context, data);
                        } else {
                          return Container();
                        }
                      },
                    );
                  },
                  childCount: posts.length,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: width > webScreenSize ? coolGrey : mobileBackgroundColor,
      appBar: width > webScreenSize
          ? null
          : AppBar(
              backgroundColor: mobileBackgroundColor,
              title: SvgPicture.asset(
                'assets/ReWear.svg',
                height: 100,
              ),
              actions: [
                IconButton(
                  icon: const Icon(
                    Icons.search,
                    color: greenColor,
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => SearchScreen()),
                    );
                  },
                ),
              ],
            ),
      body: Container(
        margin: EdgeInsets.symmetric(
          horizontal: width > webScreenSize ? width * 0.15 : 0,
          vertical: width > webScreenSize ? 15 : 0,
        ),
        child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
          stream: FirebaseFirestore.instance.collection('posts').snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (!snapshot.hasData) {
              return const Text('No data available');
            }

            var allPosts = snapshot.data!.docs;
            List<DocumentSnapshot<Map<String, dynamic>>> premiumPosts = [];
            List<DocumentSnapshot<Map<String, dynamic>>> regularPosts = [];

            return FutureBuilder(
              future: _populatePostLists(allPosts, premiumPosts, regularPosts),
              builder: (context, AsyncSnapshot<void> postListSnapshot) {
                if (postListSnapshot.connectionState ==
                    ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                return Column(
                  children: [
                    Expanded(
                      child: _buildPostGrid(regularPosts, false, context,
                          regularPostsController, 'Избрани за тебе'),
                    ),
                    Expanded(
                      child: _buildPostGrid(premiumPosts, true, context,
                          premiumPostsController, 'Наш избор '),
                    ),
                  ],
                );
              },
            );
          },
        ),
      ),
    );
  }
}
