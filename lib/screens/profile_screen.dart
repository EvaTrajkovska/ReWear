import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:rewear/providers/user_provider.dart';
import 'package:rewear/resources/authentication_metods.dart';
import 'package:rewear/screens/chat_screen.dart';
import 'package:rewear/screens/login_screen.dart';
import 'package:rewear/utils/colors.dart';
import 'package:rewear/resources/database_method.dart';
import 'package:rewear/utils/colors.dart';
import 'package:rewear/model/user.dart' as model;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:rewear/utils/dimensions.dart';
import 'package:rewear/widgets/rate_button.dart';
import '../utils/imagePickerAndSnackBar.dart';
import 'package:rewear/resources/database_method.dart';

class ProfileScreen extends StatefulWidget {
  final String uid;
  const ProfileScreen({Key? key, required this.uid}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  var userData = {};
  int postLen = 0;
  int followers = 0;
  int following = 0;
  int ratingUsers = 0;
  bool isFollowing = false;
  bool isLoading = false;
  String ratedUid = '';

  @override
  void initState() {
    super.initState();
    getData();
  }

  getData() async {
    setState(() {
      isLoading = true;
    });
    try {
      var userSnap = await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.uid)
          .get();

      // posts
      var postSnap = await FirebaseFirestore.instance
          .collection('posts')
          .where('uid', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
          .get();

      userData = userSnap.data()!;

      setState(() {
        isLoading = true;
        averageRating = calculateAverageRating(userData['ratings'] ?? []);
      });
    } catch (e) {
      showSnackBar(
        context,
        e.toString(),
      );
    }
    setState(() {
      isLoading = false;
    });
  }

  double calculateAverageRating(List<dynamic> ratings) {
    if (ratings.isEmpty) return 0.0;

    double totalRating = 0.0;
    for (var ratingMap in ratings) {
      totalRating += ratingMap['rating'];
    }
    return totalRating / ratings.length;
  }

  void showRaters(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Raters'),
          content: SizedBox(
            width: double.maxFinite,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: userData['ratings']?.length ?? 0,
              itemBuilder: (context, index) {
                var rater = userData['ratings'][index];
                return ListTile(
                  title: FutureBuilder<DocumentSnapshot>(
                    future: FirebaseFirestore.instance
                        .collection('users')
                        .doc(rater['raterUid'])
                        .get(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.done &&
                          snapshot.data != null) {
                        var raterData =
                            snapshot.data!.data() as Map<String, dynamic>;
                        return Text(raterData['username'] ?? 'Unknown User');
                      } else if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      } else {
                        return CircularProgressIndicator();
                      }
                    },
                  ),
                  trailing: Text('${rater['rating']} Stars'),
                );
              },
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Close'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void showRatingDialog(BuildContext context) {
    final firestoreMethods = FireStoreMethods();
    int selectedRating = 0;
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Оцени продавач!'),
          content: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: List.generate(5, (index) {
              return IconButton(
                icon: Icon(
                  selectedRating > index ? Icons.star : Icons.star_border,
                  color: selectedRating > index ? greenColor : Colors.grey,
                ),
                onPressed: () {
                  String ratedUid = widget.uid;

                  Navigator.of(context).pop(index + 1);
                },
              );
            }),
          ),
        );
      },
    ).then((rating) async {
      if (rating != null) {
        String raterUid = FirebaseAuth.instance.currentUser?.uid ?? '';
        String ratedUid = widget.uid;

        String result =
            await FireStoreMethods().addRating(raterUid, ratedUid, rating);

        if (result == 'success') {
          setState(() {
            List<dynamic> updatedRatingsList =
                List.from(userData['ratings'] ?? []);
            updatedRatingsList.add({'raterUid': raterUid, 'rating': rating});

            userData['ratings'] = updatedRatingsList;

            averageRating = calculateAverageRating(updatedRatingsList);
          });
        } else {
          result = 'rating fai';
        }
      }
    });
  }

  double averageRating = 0;
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    averageRating = calculateAverageRating(userData['ratings'] as List? ?? []);

    List<Widget> buildStarIcons(double averageRating) {
      List<Widget> starIcons = [];
      int fullStars = averageRating.floor();
      bool hasHalfStar = (averageRating - fullStars) >= 0.5;

      for (int i = 0; i < fullStars; i++) {
        starIcons.add(Icon(Icons.star, color: greenColor));
      }

      if (hasHalfStar) {
        starIcons.add(Icon(Icons.star_half, color: greenColor));
      }

      for (int i = fullStars + (hasHalfStar ? 1 : 0); i < 5; i++) {
        starIcons.add(Icon(Icons.star_border, color: greenColor));
      }

      return starIcons;
    }

    // print('Total Rating: $totalRating');
    // print('Number of Ratings: $numberOfRatings');
    print('Average Rating: $averageRating');

    String username = userData["username"] ?? 'No Name';
    String initial = userData["username"] != null
        ? userData["username"][0].toUpperCase()
        : '?';
    int ratingLength = 0;
    if (userData != null && userData['rating'] != null) {
      List<dynamic> ratings = userData['rating'];
      ratingLength = ratings.length;
    }
    String ratingCount = ratingLength.toString();

    return isLoading
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : Scaffold(
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
            body: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  Divider(),
                  Padding(
                    padding: const EdgeInsets.only(left: 16.0, top: 8.0),
                    child: Text(
                      username,
                      style: TextStyle(
                        fontSize: 24.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Divider(),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16.0, vertical: 8.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        CircleAvatar(
                          backgroundColor: blueGrey,
                          radius: 70.0,
                          child: Text(
                            initial,
                            style: TextStyle(fontSize: 40, color: Colors.white),
                          ),
                        ),
                        Expanded(
                          child: Column(
                            children: <Widget>[
                              ListTile(
                                title: Text(
                                  'Продадени производи',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                  textAlign: TextAlign.center,
                                ),
                                subtitle: Text(
                                  ratingCount,
                                  style: TextStyle(
                                    fontSize: 30,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              ListTile(
                                title: Text(
                                  'Оцена',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20),
                                  textAlign: TextAlign.center,
                                ),
                                subtitle: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: buildStarIcons(averageRating),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      FirebaseAuth.instance.currentUser!.uid == widget.uid
                          ? RateButton(
                              text: 'Види оцени',
                              function: () async {
                                showRaters(context);
                              },
                            )
                          : RateButton(
                              text: 'Оцени',
                              function: () async {
                                showRatingDialog(context);
                              },
                            )
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      FirebaseAuth.instance.currentUser!.uid == widget.uid
                          ? RateButton(
                              text: 'Одјави се',
                              function: () async {
                                await AuthenticationMetods().signOut();
                                if (context.mounted) {
                                  Navigator.of(context).pushReplacement(
                                    MaterialPageRoute(
                                      builder: (context) => const LoginScreen(),
                                    ),
                                  );
                                }
                              },
                            )
                          : RateButton(
                              text: 'Контактирај продавач',
                              function: () async {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        ChatScreen(userId: widget.uid),
                                  ),
                                );
                              },
                            ),
                    ],
                  ),
                  Divider(),
                  FutureBuilder(
                    future: FirebaseFirestore.instance
                        .collection('posts')
                        .where('uid', isEqualTo: widget.uid)
                        .get(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }

                      return GridView.builder(
                        shrinkWrap: true,
                        itemCount: (snapshot.data! as dynamic).docs.length,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          crossAxisSpacing: 5,
                          mainAxisSpacing: 1.5,
                          childAspectRatio: 1,
                        ),
                        itemBuilder: (context, index) {
                          DocumentSnapshot snap =
                              (snapshot.data! as dynamic).docs[index];

                          return SizedBox(
                            child: Image(
                              image: NetworkImage(snap['postUrl']),
                              fit: BoxFit.cover,
                            ),
                          );
                        },
                      );
                    },
                  )
                ],
              ),
            ));
  }
}
