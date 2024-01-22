import 'package:flutter/material.dart';

class UserProfileHeader extends StatelessWidget {
  final String username;

  UserProfileHeader({required this.username});

  @override
  Widget build(BuildContext context) {
    String initial = username.isNotEmpty ? username[0].toUpperCase() : '?';
    return Row(
      //  mainAxisSize: MainAxisSize.min,
      children: [
        CircleAvatar(
          backgroundColor:
              const Color.fromARGB(255, 1, 25, 45), // Use your preferred color
          child: Text(initial, style: TextStyle(color: Colors.white)),
        ),
        SizedBox(width: 8), // Adjust spacing as needed
        Text(username, style: TextStyle(fontSize: 20)),
      ],
    );
  }
}
