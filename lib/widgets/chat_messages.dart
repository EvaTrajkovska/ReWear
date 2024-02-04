import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rewear/providers/firebase_provider.dart';
import 'package:rewear/screens/message_bubble.dart';
import 'package:rewear/widgets/empty_widget.dart';
import '../../model/message.dart';

class ChatMessages extends StatelessWidget {
  ChatMessages({super.key, required this.receiverId});
  final String receiverId;

  @override
  Widget build(BuildContext context) => Consumer<FirebaseProvider>(
        builder: (context, value, child) => value.messages.isEmpty
            ? const Expanded(
                child: EmptyWidget(icon: Icons.waving_hand, text: 'Say Hello!'),
              )
            : Expanded(
                child: ListView.builder(
                  controller:
                      Provider.of<FirebaseProvider>(context, listen: false)
                          .scrollController,
                  itemCount: value.messages.length,
                  itemBuilder: (context, index) {
                    final isTextMessage =
                        value.messages[index].messageType == MessageType.text;
                    final isMe = receiverId != value.messages[index].senderId;

                    return isTextMessage
                        ? MessageBubble(
                            isMe: isMe,
                            message: value.messages[index],
                            // isImage: false,
                          )
                        : MessageBubble(
                            isMe: isMe,
                            message: value.messages[index],
                            // isImage: true,
                          );
                  },
                ),
              ),
      );
}
