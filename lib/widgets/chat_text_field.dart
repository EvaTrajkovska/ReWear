import 'dart:typed_data';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:rewear/service/firebase_firestore_service.dart';
import 'package:rewear/service/location_service.dart';
import 'package:rewear/service/notification_service.dart';
import 'package:rewear/utils/colors.dart';

import 'package:rewear/service/firebase_storage_service.dart';
import 'package:rewear/service/media_service.dart';

import 'custom_text_form_field.dart';

class ChatTextField extends StatefulWidget {
  const ChatTextField({super.key, required this.receiverId});

  final String receiverId;

  @override
  State<ChatTextField> createState() => _ChatTextFieldState();
}

class _ChatTextFieldState extends State<ChatTextField> {
  final controller = TextEditingController();
  final notificationsService = NotificationsService();

  Uint8List? file;

  @override
  void initState() {
    notificationsService.getReceiverToken(widget.receiverId);
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Row(
        children: [
          Expanded(
            child: CustomTextFormField(
              controller: controller,
              hintText: 'Add Message...',
            ),
          ),
          const SizedBox(width: 5),
          CircleAvatar(
            backgroundColor: greenColor,
            radius: 20,
            child: IconButton(
              icon: const Icon(Icons.send, color: Colors.white),
              onPressed: () => _sendText(context),
            ),
          ),
          const SizedBox(width: 5),
          CircleAvatar(
            backgroundColor: greenColor,
            radius: 20,
            child: IconButton(
              icon: const Icon(Icons.camera_alt, color: Colors.white),
              onPressed: _sendImage,
            ),
          ),
          const SizedBox(width: 5),
          CircleAvatar(
            backgroundColor: greenColor,
            radius: 20,
            child: IconButton(
              icon: const Icon(Icons.location_on, color: Colors.white),
              onPressed: () => _sendLocation(context),
            ),
          ),
        ],
      );

  Future<void> _sendText(BuildContext context) async {
    if (controller.text.isNotEmpty) {
      await FirebaseFirestoreService.addTextMessage(
        receiverId: widget.receiverId,
        content: controller.text,
      );
      await notificationsService.sendNotification(
        body: controller.text,
        senderId: FirebaseAuth.instance.currentUser!.uid,
      );
      controller.clear();
      FocusScope.of(context).unfocus();
    }
    FocusScope.of(context).unfocus();
  }

  Future<void> _sendImage() async {
    final pickedImage = await MediaService.pickImage();
    setState(() => file = pickedImage);
    if (file != null) {
      await FirebaseFirestoreService.addImageMessage(
        receiverId: widget.receiverId,
        file: file!,
      );
      await notificationsService.sendNotification(
        body: 'image........',
        senderId: FirebaseAuth.instance.currentUser!.uid,
      );
    }
  }

  Future<void> _sendLocation(BuildContext context) async {
    try {
      final position = await LocationService().getCurrentLocation();
      final String locationUrl =
          "https://www.google.com/maps/search/?api=1&query=${position.latitude},${position.longitude}";

      // Assuming you have a method addLocationMessage which sets the messageType to location
      await FirebaseFirestoreService.addLocationMessage(
        receiverId: widget.receiverId,
        content: locationUrl,
      );
      await notificationsService.sendNotification(
        body: 'My location: $locationUrl',
        senderId: FirebaseAuth.instance.currentUser!.uid,
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to get location: ${e.toString()}'),
        ),
      );
    }
  }
}
