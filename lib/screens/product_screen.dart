import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:rewear/providers/user_provider.dart';
import 'package:rewear/screens/chat_screen.dart';
import 'package:rewear/utils/colors.dart';
import 'package:rewear/utils/dimensions.dart';
import 'package:rewear/model/user.dart' as model;
import 'package:rewear/widgets/rate_button.dart';

class ProductScreen extends StatefulWidget {
  final postId;
  const ProductScreen({super.key, required this.postId});

  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  Map<String, dynamic>? postData;

  @override
  void initState() {
    super.initState();
    fetchPostData();
  }

  Future<void> fetchPostData() async {
    try {
      DocumentSnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
          .instance
          .collection('posts')
          .doc(widget.postId)
          .get();

      if (snapshot.exists) {
        setState(() {
          postData = snapshot.data();
        });
      } else {
        print('Post with postId ${widget.postId} does not exist.');
      }
    } catch (error) {
      print('Error fetching post data: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    final model.User user = Provider.of<UserProvider>(context).getUser;
    String initial =
        user.username.isNotEmpty ? user.username[0].toUpperCase() : '?';

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
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(alignment: Alignment.center, children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.35,
              width: double.infinity,
              child: Image.network(
                postData!['postUrl'].toString(),
                fit: BoxFit.cover,
              ),
            ),
          ]),
          // Display product details here
          SizedBox(height: 10, width: 10,),

          Text(
            DateFormat('  dd MMMM yyyy', 'en_US')
                .format(postData?['datePublished'].toDate()), style: TextStyle(fontSize: 14),
          ),
          SizedBox(height: 10, width: 10,),
          Text('  ${postData?['likes'].length} likes ', style: TextStyle(fontSize: 16),),
          Text(
            " ${postData?['title'] ?? 'Loading...'}",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 28, fontFamily: AutofillHints.familyName),
          ),
          SizedBox(height: 10,),
          Text('  ${postData?['description']}', style: TextStyle(fontSize: 18),),
          SizedBox(height: 10,),
          Text('  ${postData?['price']} MKD', style: TextStyle(fontWeight: FontWeight.bold, fontSize:35, color: greenColor )),
          SizedBox(height: 50,),
          Text(postData?['username']),

          // Add other details as needed
          Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
            RateButton(
              text: 'Контактирај продавач',
              function: () async {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ChatScreen(userId: postData?['uid']),
                  ),
                );
              },
            ),
          ])
        ],
      ),
    );
  }
}
