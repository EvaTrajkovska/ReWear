import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:rewear/resources/database_method.dart';
import 'package:rewear/utils/colors.dart';
import 'package:rewear/utils/dimensions.dart';
import 'package:rewear/widgets/small_box_card.dart';

class SavedPostsScreen extends StatefulWidget {
  final String userId;
  const SavedPostsScreen({Key? key, required this.userId}) : super(key: key);
  @override
  _SavedPostsScreenState createState() => _SavedPostsScreenState();
}

class _SavedPostsScreenState extends State<SavedPostsScreen> {
  List<Map<String, dynamic>> savedPosts = [];

  @override
  void initState() {
    super.initState();
    loadSavedPosts();
  }

  Future<void> loadSavedPosts() async {
    List<Map<String, dynamic>> posts =
        await FireStoreMethods().getSavedPosts(widget.userId);
    setState(() {
      savedPosts = posts;
    });
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final bool isWeb = width > webScreenSize;
    final int crossAxisCount = width > 1500
        ? 5
        : width > 1200
            ? 4
            : width > 800
                ? 3
                : 2;
    final double childAspectRatio = isWeb ? 1 : 0.7;
    final double crossAxisSpacing = isWeb ? 20 : 8;
    final double mainAxisSpacing = isWeb ? 20 : 10;

    return Scaffold(
      backgroundColor: width > webScreenSize ? coolGrey : mobileBackgroundColor,
      appBar: width > webScreenSize
          ? null
          : AppBar(
              backgroundColor: Color.fromARGB(0, 245, 234, 234),
              title: SvgPicture.asset(
                'assets/ReWear.svg',
                height: 100,
              ),
            ),
      body: savedPosts.isEmpty
          ? Center(
              child: Text('Немате омилени парчиња'),
            )
          : Column(children: [
              Divider(),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 16.0),
                child: Text(
                  'Мои Омилени',
                  style: TextStyle(
                    fontSize: 25.0,
                  ),
                ),
              ),
              Divider(),
              SizedBox(
                height: 30,
              ),
              Expanded(
                child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: crossAxisCount,
                    crossAxisSpacing: crossAxisSpacing,
                    mainAxisSpacing: mainAxisSpacing,
                    childAspectRatio: childAspectRatio,
                  ),
                  itemCount: savedPosts.length,
                  itemBuilder: (context, index) {
                    return buildPostCard(context, savedPosts[index]);
                  },
                ),
              ),
            ]),
    );
  }
}
