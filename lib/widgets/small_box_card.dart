import 'package:flutter/material.dart';
import 'package:rewear/screens/product_screen.dart';

Widget buildPostCard(BuildContext context, Map<String, dynamic> post) {
  return Card(
    clipBehavior: Clip.antiAlias,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10.0),
    ),
    child: Stack(
      alignment: Alignment.bottomCenter,
      children: [
        Image.network(
          post['postUrl'],
          fit: BoxFit.fill,
          width: double.infinity,
          height: double.infinity,
        ),
        GestureDetector(
          onTap: () {
            // This delays the navigation by 1 second as per your existing code
            Future.delayed(Duration(seconds: 1), () async {
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProductScreen(
                    snap: post, // Ensure 'post' is not null here
                  ),
                ),
              );
            });
          },
        ),
        Container(
          width: double.infinity,
          color: Colors.white.withOpacity(0.7),
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                post['title'] ?? '',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                '${post['price'] ?? '0'} МКД',
                style: const TextStyle(
                  color: Colors.black,
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}
