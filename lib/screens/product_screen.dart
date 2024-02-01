import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:rewear/providers/user_provider.dart';
import 'package:rewear/resources/database_method.dart';
import 'package:rewear/screens/chat_screen.dart';
import 'package:rewear/screens/comments_screen.dart';
import 'package:rewear/utils/colors.dart';
import 'package:rewear/utils/dimensions.dart';
import 'package:rewear/model/user.dart' as model;
import 'package:rewear/utils/imagePickerAndSnackBar.dart';
import 'package:rewear/widgets/rate_button.dart';
import 'package:rewear/widgets/user_profile_header.dart';
import 'package:rewear/widgets/like_animation.dart';

class ProductScreen extends StatefulWidget {
  final Map<String, dynamic>? snap;
  const ProductScreen({Key? key, this.snap}) : super(key: key);
  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  Map<String, dynamic>? postData;
  int commentLen = 0;
  bool isLikeAnimating = false;

  @override
  void initState() {
    super.initState();
    if (widget.snap != null) {
      fetchCommentLen();
      fetchPostData();
    }
  }

  fetchCommentLen() async {
    try {
      // Check if `widget.snap` is not null and contains the 'postId' key
      final postId = widget.snap?['postId'];
      if (postId != null) {
        QuerySnapshot snap = await FirebaseFirestore.instance
            .collection('posts')
            .doc(postId) // Use the postId safely
            .collection('comments')
            .get();
        commentLen = snap.docs.length;
      } else {
        // Handle the case where snap is null or does not contain 'postId'
        print('snap is null or does not contain a valid postId');
      }
    } catch (err) {
      showSnackBar(
        context,
        err.toString(),
      );
    }
    setState(() {});
  }

  deletePost(String postId) async {
    try {
      await FireStoreMethods().deletePost(postId);
    } catch (err) {
      showSnackBar(
        context,
        err.toString(),
      );
    }
  }

  Future<void> fetchPostData() async {
    try {
      String postId = widget.snap?['postId']; // Get postId from the snap map
      if (postId != null) {
        DocumentSnapshot<Map<String, dynamic>> snapshot =
            await FirebaseFirestore.instance
                .collection('posts')
                .doc(postId) // Use the postId to fetch the correct document
                .get();

        if (snapshot.exists) {
          setState(() {
            postData = snapshot.data();
          });
        } else {
          print('Post with postId $postId does not exist.');
        }
      } else {
        print('PostId is null');
      }
    } catch (error) {
      print('Error fetching post data: $error');
    }
  }

  void likePost() async {
    setState(() {
      isLikeAnimating = true;
    });

    // Add delay to show animation
    await Future.delayed(Duration(seconds: 2));
    setState(() {
      isLikeAnimating = false;
    });
  }

  void savePost() async {
    // Your logic to handle save action
  }

  @override
  Widget build(BuildContext context) {
    final model.User user = Provider.of<UserProvider>(context).getUser;
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: width > webScreenSize
          ? null
          : AppBar(
              backgroundColor: coolGrey,
              title: SvgPicture.asset(
                'assets/ReWear.svg',
                height: 100,
              ),
            ),
      body: postData == null
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.35,
                    width: double.infinity,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        UserProfileHeader(username: user.username),
                        const Divider(height: 15, thickness: 2),
                        Image.network(
                          postData!['postUrl'].toString(),
                          fit: BoxFit.fitWidth, //TODO: adjust here
                        ),
                      ],
                    ),
                  ),
                  Divider(),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        LikeAnimation(
                          isAnimating: isLikeAnimating,
                          smallLike: true,
                          child: IconButton(
                            icon: Icon(isLikeAnimating
                                ? Icons.favorite
                                : Icons.favorite_border),
                            onPressed: likePost,
                          ),
                        ),
                        IconButton(
                          icon: Icon(Icons.comment_outlined),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => CommentsScreen(
                                  postId: postData?['postId'].toString(),
                                ),
                              ),
                            );
                          },
                        ),
                        IconButton(
                            icon: widget.snap!['saves'].contains(user.uid)
                                ? const Icon(
                                    Icons.bookmark,
                                    color: Colors.black,
                                  )
                                : const Icon(
                                    Icons.bookmark_border,
                                  ),
                            onPressed: () => FireStoreMethods().savePost(
                                  widget.snap!['postId'].toString(),
                                  user.uid,
                                  widget.snap!['saves'],
                                )),
                      ],
                    ),
                  ),
                  Text(
                    DateFormat('dd MMMM yyyy', 'en_US')
                        .format(postData?['datePublished'].toDate()),
                    style: TextStyle(fontSize: 14),
                  ),
                  SizedBox(height: 10),
                  Text(
                    '${postData?['likes'].length} likes',
                    style: TextStyle(fontSize: 16),
                  ),
                  Text(
                    postData?['title'] ?? 'Loading...',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 28,
                      fontFamily:
                          'YourFontFamily', // Replace with your font family
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    postData?['description'] ?? '',
                    style: TextStyle(fontSize: 18),
                  ),
                  SizedBox(height: 10),
                  Text(
                    '${postData?['price']} MKD',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 35,
                      color:
                          greenColor, // Make sure this is defined in your 'colors.dart' or replace with a Color value
                    ),
                  ),
                  SizedBox(height: 50),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      RateButton(
                        text: 'Контактирај продавач',
                        function: () async {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  ChatScreen(userId: postData?['uid']),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
    );
  }
}
