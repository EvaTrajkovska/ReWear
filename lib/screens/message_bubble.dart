import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../model/message.dart';
import '../../utils/colors.dart';

class MessageBubble extends StatelessWidget {
  const MessageBubble({
    super.key,
    required this.isMe,
    required this.message,
  });

  final bool isMe;
  final Message message;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isMe ? Alignment.topRight : Alignment.topLeft,
      child: Container(
        decoration: BoxDecoration(
          color: isMe ? greenColor : Colors.grey[300],
          borderRadius: isMe
              ? const BorderRadius.only(
                  topLeft: Radius.circular(12),
                  bottomLeft: Radius.circular(12),
                  topRight: Radius.circular(12),
                )
              : const BorderRadius.only(
                  topRight: Radius.circular(12),
                  bottomRight: Radius.circular(12),
                  topLeft: Radius.circular(12),
                ),
        ),
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
        margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
        child: _buildMessageContent(context),
      ),
    );
  }

  Widget _buildMessageContent(BuildContext context) {
    switch (message.messageType) {
      case MessageType.text:
        // Text message
        return Text(
          message.content,
          style: TextStyle(color: isMe ? Colors.white : Colors.black87),
        );
      case MessageType.image:
        // Image message
        return Image.network(message.content);
      case MessageType.location:
        // Location message
        return InkWell(
          onTap: () => _launchURL(message.content),
          child: Container(
            padding: const EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              color: Colors.blueAccent,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: const [
                Icon(Icons.location_on, color: Colors.white),
                SizedBox(width: 8),
                Text(
                  'View Location',
                  style: TextStyle(
                    color: Colors.white,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ],
            ),
          ),
        );
      default:
        // Unknown message type
        return const SizedBox();
    }
  }

  Future<void> _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
