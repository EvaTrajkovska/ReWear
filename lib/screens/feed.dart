import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rewear/utils/dimensions.dart';
import 'package:rewear/widgets/post_card.dart';
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
      if (isPremium) {
        premiumPosts.add(post);
      } else {
        regularPosts.add(post);
      }
    }
  }

  Widget _buildPostGrid(
      List<DocumentSnapshot> posts, bool isPremiumList, BuildContext context) {
    return SliverGrid(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: 0.7,
      ),
      delegate: SliverChildBuilderDelegate(
        (BuildContext context, int index) {
          return FutureBuilder<bool>(
            future: _checkIfUserIsPremium(posts[index]['uid']),
            builder: (context, AsyncSnapshot<bool> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
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
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
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
              if (postListSnapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              return CustomScrollView(
                slivers: [
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Center(
                        child: Text(
                          'Избрани за тебе',
                          style: TextStyle(
                              fontSize: 24,
                              color: greenColor,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
                  _buildPostGrid(regularPosts, false, context),
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      child: Center(
                        child: Text('Наш избор',
                            style: TextStyle(
                                fontSize: 24,
                                color: greenColor,
                                fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Center(
                        child: Text('Артикли на денот',
                            style: TextStyle(fontSize: 15)),
                      ),
                    ),
                  ),
                  _buildPostGrid(premiumPosts, true, context),
                ],
              );
            },
          );
        },
      ),
    );
  }
}
