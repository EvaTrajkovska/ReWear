import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:rewear/providers/user_provider.dart';
import 'package:rewear/resources/database_method.dart';
import 'package:rewear/screens/chat_screen.dart';
import 'package:rewear/screens/comments_screen.dart';
import 'package:rewear/screens/profile_screen.dart';
import 'package:rewear/utils/colors.dart';
import 'package:rewear/utils/dimensions.dart';
import 'package:rewear/model/user.dart' as model;
import 'package:rewear/widgets/rate_button.dart';
import 'package:rewear/widgets/like_animation.dart';

class ProductScreen extends StatefulWidget {
  final Map<String, dynamic>? snap;
  final postId;
  const ProductScreen({Key? key, this.snap, this.postId}) : super(key: key);
  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  Map<String, dynamic>? postData;
  int commentLen = 0;
  bool isLikeAnimating = false;
  List<Map<String, dynamic>> savedPosts = [];

  @override
  void initState() {
    super.initState();
    if (widget.snap != null) {
      //fetchCommentLen();
      fetchPostData();
      //loadSavedPosts();
    }
  }

  Future<void> fetchPostData() async {
    try {
      String postId = widget.snap?['postId'];
      if (postId != null) {
        DocumentSnapshot<Map<String, dynamic>> snapshot =
            await FirebaseFirestore.instance
                .collection('posts')
                .doc(postId)
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
    setState(() async {
      isLikeAnimating = true;
      await FireStoreMethods().likePost(widget.snap!['postId'].toString(),
          widget.snap!['uid'].toString(), widget.snap?['likes']);
    });

    // Add delay to show animation
    await Future.delayed(const Duration(seconds: 4));
    setState(() {
      isLikeAnimating = false;
    });
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
              leading: IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: () => Navigator.of(context).pop(),
              ),
              title: width > webScreenSize
                  ? null
                  : SvgPicture.asset(
                      'assets/ReWear.svg',
                      height: 100,
                    ),
            ),
      body: postData == null
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Container(
                margin: EdgeInsets.symmetric(
                  horizontal: width > webScreenSize ? width * 0.3 : 0,
                  vertical: width > webScreenSize ? 15 : 0,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GestureDetector(
                      onDoubleTap: () {
                        FireStoreMethods().likePost(
                          widget.snap!['postId'].toString(),
                          user.uid,
                          widget.snap?['likes'],
                        );
                        setState(() {
                          isLikeAnimating = true;
                        });
                      },
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.35,
                            width: double.infinity,
                            child: Image.network(
                              postData!['postUrl'].toString(),
                              fit: BoxFit.cover,
                            ),
                          ),
                          AnimatedOpacity(
                            duration: const Duration(milliseconds: 200),
                            opacity: isLikeAnimating ? 1 : 0,
                            child: LikeAnimation(
                              isAnimating: isLikeAnimating,
                              duration: const Duration(
                                milliseconds: 400,
                              ),
                              onEnd: () {
                                setState(() {
                                  isLikeAnimating = false;
                                });
                              },
                              child: const Icon(
                                Icons.favorite,
                                color: Colors.white,
                                size: 100,
                              ),
                            ),
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
                            isAnimating:
                                widget.snap?['likes'].contains(user.uid),
                            smallLike: true,
                            child: IconButton(
                                icon: widget.snap?['likes'].contains(user.uid)
                                    ? const Icon(
                                        Icons.favorite,
                                        // color: Colors.red,
                                      )
                                    : const Icon(
                                        Icons.favorite_border,
                                      ),
                                onPressed: () async {
                                  await FireStoreMethods().likePost(
                                    widget.snap!['postId'].toString(),
                                    user.uid,
                                    widget.snap?['likes'],
                                  );
                                  setState(() {
                                    widget.snap!['likes'].contains(user.uid)
                                        ? widget.snap!['likes'].remove(user.uid)
                                        : widget.snap!['likes'].add(user.uid);
                                    fetchPostData();
                                  });
                                }),
                          ),
                          IconButton(
                            icon: const Icon(Icons.comment_outlined),
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
                            icon: user.uid == widget.snap!['uid']
                                ? const Icon(
                                    Icons.delete,
                                    // color: Colors.red,
                                  )
                                : widget.snap!['saves'].contains(user.uid)
                                    ? const Icon(
                                        Icons.bookmark,
                                        color: Colors.black,
                                      )
                                    : const Icon(
                                        Icons.bookmark_border,
                                      ),
                            onPressed: () async {
                              if (user.uid == widget.snap!['uid']) {
                                await FireStoreMethods().deletePost(
                                    widget.snap!['postId'].toString());
                                Navigator.of(context).pop();
                              } else {
                                await FireStoreMethods().savePost(
                                  widget.snap!['postId'].toString(),
                                  user.uid,
                                  widget.snap!['saves'],
                                );
                                setState(() {
                                  widget.snap!['saves'].contains(user.uid)
                                      ? widget.snap!['saves'].remove(user.uid)
                                      : widget.snap!['saves'].add(user.uid);
                                });
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                    // Your Text widgets with Padding
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        DateFormat('dd MMMM yyyy', 'en_US')
                            .format(postData?['datePublished'].toDate()),
                        style: TextStyle(fontSize: 14),
                      ),
                    ),
                    SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        '${postData?['likes'].length} likes',
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        postData?['title'] ?? 'Loading...',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 28,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        postData?['description'] ?? '',
                        style: const TextStyle(fontSize: 18),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        '${postData?['price']} MKD',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 35,
                          color: greenColor,
                        ),
                      ),
                    ),
                    const SizedBox(height: 50),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        FirebaseAuth.instance.currentUser!.uid ==
                                widget.snap!['uid']
                            ? RateButton(
                                text: postData != null &&
                                        postData!.containsKey('sold') &&
                                        postData!['sold'] == true
                                    ? 'Огласи повторно'
                                    : 'Продаден производ',
                                function: () async {
                                  if (postData != null &&
                                      postData!.containsKey('postId')) {
                                    await FireStoreMethods()
                                        .markProductAsSold(postData!['postId']);
                                    Navigator.pop(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => ProfileScreen(
                                            uid: postData!['uid'].toString()),
                                      ),
                                    );
                                  }
                                })
                            : RateButton(
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
            ),
    );
  }
}
