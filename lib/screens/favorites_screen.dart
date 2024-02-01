import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:rewear/resources/database_method.dart';
import 'package:rewear/screens/product_screen.dart';
import 'package:rewear/utils/colors.dart';
import 'package:rewear/utils/dimensions.dart';

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
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 16.0),
                child: Text(
                  'Мои Омилени',
                  style: TextStyle(
                    fontSize: 25.0,
                  ),
                ),
              ),
              Divider(),
              const SizedBox(
                height: 30,
              ),
              Expanded(
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3, // Three cards per row
                    crossAxisSpacing: 8.0, // Adjust as needed
                    mainAxisSpacing: 10.0, // Adjust as needed
                  ),
                  itemCount: savedPosts.length,
                  itemBuilder: (context, index) {
                    return buildPostCard(savedPosts[index]);
                  },
                ),
              ),
            ]),
    );
  }

  Widget buildPostCard(Map<String, dynamic> post) {
    return Card(
      child: Column(
        children: [
          Container(
            height: MediaQuery.of(context).size.width * 0.2,
            child: GestureDetector(
                onTap: () {
                  // This delays the navigation by 1 second as per your existing code
                  Future.delayed(Duration(seconds: 1), () async {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ProductScreen(
                          snap:
                              post, // Passing the entire post Map<String, dynamic> to ProductScreen
                        ),
                      ),
                    );
                  });
                },
                child: Image.network(
                  post['postUrl'].toString(),
                  width: double.infinity,
                  height: 100,
                  fit: BoxFit.cover,
                )),
          ),
          ListTile(
            title: Text(post['title']),
            subtitle: Text('${post['price'].toString()} MKD'),
          ),
        ],
      ),
    );
  }
}
