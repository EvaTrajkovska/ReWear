import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rewear/utils/colors.dart';

class MobileScreenLayout extends StatelessWidget {
  const MobileScreenLayout({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('This is mobile'),
      ),
    );
  }
}

