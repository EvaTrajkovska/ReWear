import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rewear/providers/firebase_provider.dart';
import 'package:rewear/utils/colors.dart';
import 'package:rewear/utils/dimensions.dart';
import '../widgets/chat_messages.dart';
import '../widgets/chat_text_field.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key, required this.userId});

  final String userId;

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  @override
  void initState() {
    Provider.of<FirebaseProvider>(context, listen: false)
      ..getUserById(widget.userId)
      ..getMessages(widget.userId);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: _buildAppBar(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ChatMessages(receiverId: widget.userId),
            ChatTextField(receiverId: widget.userId)
          ],
        ),
      ),
    );
  }

  AppBar _buildAppBar() => AppBar(
        elevation: 0,
        foregroundColor: Colors.black,
        backgroundColor: Colors.transparent,
        title: Consumer<FirebaseProvider>(
          builder: (context, firebaseProvider, child) {
            if (firebaseProvider.user != null &&
                firebaseProvider.user!.name.isNotEmpty) {
              String initial = firebaseProvider.user!.name[0].toUpperCase();
              return Row(
                children: [
                  CircleAvatar(
                    radius: 20,
                    child: Text(
                      initial,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    backgroundColor: greenColor,
                  ),
                  const SizedBox(width: 10),
                  Text(
                    firebaseProvider.user!.name,
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              );

            } else {
              return const SizedBox(); // Return an empty widget if the user is null or name is empty
            }
          },
        ),
      );
}
