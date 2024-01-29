import 'package:flutter/material.dart';
import 'package:rewear/resources/database_method.dart';

class SavedPostsScreen extends StatefulWidget {
  final String userId;

  const SavedPostsScreen({super.key, required this.userId});

  @override
  _SavedPostsScreenState createState() => _SavedPostsScreenState();
}

class _SavedPostsScreenState extends State<SavedPostsScreen> {
  List<Map<String, dynamic>> savedPosts = [];

  @override
  void initState() {
    super.initState();
    // Load the saved posts for the logged-in user when the screen is created
    loadSavedPosts();
  }

  Future<void> loadSavedPosts() async {
    List<Map<String, dynamic>> posts = await FireStoreMethods().getSavedPosts(widget.userId);
    setState(() {
      savedPosts = posts;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Мои Омилени'),
      ),
      body: savedPosts.isEmpty
          ? Center(
        child: Text('Немате омилени парчиња'),
      )
          : ListView.builder(
        itemCount: savedPosts.length,
        itemBuilder: (context, index) {
          return buildPostCard(savedPosts[index]);
        },
      ),
    );
  }

  Widget buildPostCard(Map<String, dynamic> post) {
    // Customize this method to build your post card widget
    return Card(
      child: Column(
        children: [
          // Display the post image
          Image.network(
            post['postUrl'].toString(), // Replace 'imageUrl' with the actual field in your data
            width: double.infinity,
            height: 200, // Adjust the height based on your design preferences
            fit: BoxFit.cover,
          ),
          ListTile(
            title: Text(post['title']),
            subtitle: Text(post['description']),
            // Add other details as needed
          ),
        ],
      ),
    );
  }
}

