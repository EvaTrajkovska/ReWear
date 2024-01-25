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
import 'package:rewear/model/user.dart' as model;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../utils/imagePickerAndSnackBar.dart';

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

  @override
  Widget build(BuildContext context) {
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
            appBar: AppBar(
              backgroundColor: Colors.white,
              title: SvgPicture.asset(
                'assets/ReWear.svg',
                height: 100,
              ),
            ),
            body: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  Divider(), // Divider below the AppBar
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
                  Divider(), // Divider below the username
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16.0, vertical: 8.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        CircleAvatar(
                          backgroundColor: const Color.fromARGB(255, 1, 25, 45),
                          radius: 50.0,
                          child: Text(
                            initial,
                            style: TextStyle(fontSize: 30, color: Colors.white),
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
                                  ratingCount, // TODO change this
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
                                  // TODO change this
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: List.generate(5, (index) {
                                    return Icon(
                                      index < 4
                                          ? Icons.star
                                          : Icons.star_border,
                                      color: greenColor,
                                    );
                                  }),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  //TODO make a dynamic button that changes depending of who is watching
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Container(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          // TODO: handle button press
                        },
                        child: Text('Види оцени'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: greenColor,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25.0),
                          ),
                        ),
                      ),
                    ),
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
