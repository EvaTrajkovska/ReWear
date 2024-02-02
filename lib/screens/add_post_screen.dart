import 'dart:typed_data';

import 'package:firebase_auth/firebase_auth.dart' as AuthUser;
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:rewear/providers/user_provider.dart';
import 'package:rewear/model/user.dart';
import 'package:rewear/resources/database_method.dart';
import 'package:rewear/screens/login_screen.dart';
import 'package:rewear/screens/profile_screen.dart';
import 'package:rewear/utils/colors.dart';
import 'package:rewear/utils/dimensions.dart';
import 'package:rewear/utils/imagePickerAndSnackBar.dart';
import 'package:rewear/widgets/user_profile_header.dart';

class AddPostScreen extends StatefulWidget {
  const AddPostScreen({super.key});

  @override
  State<AddPostScreen> createState() => _AddPostScreenState();
}

class _AddPostScreenState extends State<AddPostScreen> {
  Uint8List? _file;
  String _title = '';
  String _decription = '';
  int _price = 0;
  String currentuser = AuthUser.FirebaseAuth.instance.currentUser?.uid ?? '';
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  void _showPriceDialog(BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute<void>(
      fullscreenDialog: true,
      builder: (BuildContext context) {
        return Scaffold(
          appBar: AppBar(
            title: Text("Внеси цена"),
          ),
          body: Container(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                TextField(
                  controller: _priceController,
                  autofocus: true,
                  keyboardType: TextInputType.numberWithOptions(decimal: false),
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                  decoration: InputDecoration(
                    labelText: 'Цена',
                    border: OutlineInputBorder(),
                    hintText: 'Внеси цена тука!',
                  ),
                ),
                SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        child: Text('Откажи'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.grey,
                          padding: EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        onPressed: () {
                          _priceController.clear();
                          Navigator.of(context).pop();
                        },
                      ),
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      child: ElevatedButton(
                        child: Text('Зачувај'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: greenColor,
                          padding: EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        onPressed: () {
                          String priceText = _priceController.text;
                          int? enteredPrice = int.tryParse(priceText);
                          if (enteredPrice != null) {
                            setState(() {
                              _price = enteredPrice;
                            });
                            Navigator.of(context).pop();
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    ));
  }

  void _showDescription(BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute<void>(
      fullscreenDialog: true,
      builder: (BuildContext context) {
        return Scaffold(
          appBar: AppBar(
            title: Text("Внеси опис"),
          ),
          body: Container(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Expanded(
                  child: TextField(
                    controller: _descriptionController,
                    autofocus: true,
                    decoration: InputDecoration(
                      labelText: 'Опис',
                      border: OutlineInputBorder(),
                      hintText: 'Внесете го вашиот опис тука',
                    ),
                    maxLength: 200,
                    maxLines: null,
                    keyboardType: TextInputType.multiline,
                  ),
                ),
                SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        child: Text('Откажи'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.grey,
                          padding: EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        onPressed: () {
                          _descriptionController.clear();
                          Navigator.of(context).pop();
                        },
                      ),
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      child: ElevatedButton(
                        child: Text('Зачувај'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: greenColor,
                          padding: EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        onPressed: () {
                          setState(() {
                            _decription = _descriptionController.text;
                          });
                          Navigator.of(context).pop();
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    ));
  }

  void _showTitle(BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute<void>(
      fullscreenDialog: true,
      builder: (BuildContext context) {
        return Scaffold(
          appBar: AppBar(
            title: Text("Внеси наслов"),
          ),
          body: Container(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Expanded(
                  child: TextField(
                    controller: _titleController,
                    autofocus: true,
                    decoration: InputDecoration(
                      labelText: 'Наслов',
                      border: OutlineInputBorder(),
                      hintText: 'Внеси го твојот наслов тука!',
                    ),
                    maxLength: 20,
                    maxLines: null,
                    keyboardType: TextInputType.multiline,
                  ),
                ),
                SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        child: Text('Откажи'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.grey,
                          padding: EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        onPressed: () {
                          _titleController.clear();
                          Navigator.of(context).pop();
                        },
                      ),
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      child: ElevatedButton(
                        child: Text('Зачувај'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: greenColor,
                          padding: EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        onPressed: () {
                          setState(() {
                            _title = _titleController.text;
                          });
                          Navigator.of(context).pop();
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    ));
  }

  _selectImage(BuildContext parentContext) async {
    Navigator.of(parentContext).push(MaterialPageRoute<void>(
      fullscreenDialog: true,
      builder: (BuildContext context) {
        return Scaffold(
          appBar: AppBar(
            title: Text('Create a Post'),
            leading: IconButton(
              icon: Icon(Icons.close),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                ListTile(
                  leading: Icon(Icons.camera),
                  title: Text('Употреби камера'),
                  onTap: () async {
                    Navigator.pop(context);
                    Uint8List file = await pickImage(ImageSource.camera);
                    setState(() {
                      _file = file;
                    });
                  },
                ),
                ListTile(
                  leading: Icon(Icons.photo_library),
                  title: Text('Избери слика од галерија'),
                  onTap: () async {
                    Navigator.pop(context);
                    Uint8List file = await pickImage(ImageSource.gallery);
                    setState(() {
                      _file = file;
                    });
                  },
                ),
                ListTile(
                  leading: Icon(Icons.cancel),
                  title: Text('Откажи'),
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ),
        );
      },
    ));
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final User user = userProvider.getUser;
    String username = user.username ?? 'No Name';
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: width > webScreenSize
          ? null
          : AppBar(
              backgroundColor: Color.fromARGB(0, 245, 234, 234),
              title: SvgPicture.asset(
                'assets/ReWear.svg',
                height: 100,
              ),
            ),
      body: Padding(
        padding:
            EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Divider(
              height: 15,
              thickness: 2,
            ),
            UserProfileHeader(username: username),
            const Divider(
              height: 15,
              thickness: 2,
            ),
            SizedBox(
              height: 15,
            ),
            _file == null
                ? Padding(
                    padding: EdgeInsets.symmetric(vertical: 16),
                    child: ElevatedButton.icon(
                      icon: Icon(Icons.add),
                      label: Text('Додај Слика'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: greenColor,
                        foregroundColor: secondaryColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        padding:
                            EdgeInsets.symmetric(horizontal: 70, vertical: 20),
                        textStyle: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      onPressed: () => _selectImage(context),
                    ),
                  )
                : Padding(
                    padding: EdgeInsets.symmetric(vertical: 16),
                    child: ElevatedButton.icon(
                      icon: Icon(Icons.check),
                      label: Text(''),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: greenColor,
                        foregroundColor: secondaryColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        padding:
                            EdgeInsets.symmetric(horizontal: 70, vertical: 20),
                        textStyle: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      onPressed: () => _selectImage(context),
                    ),
                  ),
            SizedBox(height: 16),
            _title == ""
                ? Padding(
                    padding: EdgeInsets.symmetric(vertical: 16),
                    child: ElevatedButton.icon(
                      icon: Icon(Icons.add),
                      label: Text('Додај наслов'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: greenColor,
                        foregroundColor: secondaryColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        padding:
                            EdgeInsets.symmetric(horizontal: 70, vertical: 20),
                        textStyle: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      onPressed: () => _showTitle(context),
                    ),
                  )
                : Padding(
                    padding: EdgeInsets.symmetric(vertical: 16),
                    child: ElevatedButton.icon(
                      icon: Icon(Icons.check),
                      label: Text(''),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: greenColor,
                        foregroundColor: secondaryColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        padding:
                            EdgeInsets.symmetric(horizontal: 70, vertical: 20),
                        textStyle: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      onPressed: () => _showTitle(context),
                    ),
                  ),
            SizedBox(height: 16),
            _decription == ""
                ? Padding(
                    padding: EdgeInsets.symmetric(vertical: 16),
                    child: ElevatedButton.icon(
                      icon: Icon(Icons.add),
                      label: Text('Додај опис'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: greenColor,
                        foregroundColor: secondaryColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        padding:
                            EdgeInsets.symmetric(horizontal: 70, vertical: 20),
                        textStyle: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      onPressed: () => _showDescription(context),
                    ),
                  )
                : Padding(
                    padding: EdgeInsets.symmetric(vertical: 16),
                    child: ElevatedButton.icon(
                      icon: Icon(Icons.check),
                      label: Text(''),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: greenColor,
                        foregroundColor: secondaryColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        padding:
                            EdgeInsets.symmetric(horizontal: 70, vertical: 20),
                        textStyle: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      onPressed: () => _showDescription(context),
                    ),
                  ),
            SizedBox(height: 16),
            _price == 0
                ? Padding(
                    padding: EdgeInsets.symmetric(vertical: 16),
                    child: ElevatedButton.icon(
                      label: Text('Додај цена'),
                      icon: Icon(Icons.add),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: greenColor,
                        foregroundColor: secondaryColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        padding:
                            EdgeInsets.symmetric(horizontal: 70, vertical: 20),
                        textStyle: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      onPressed: () => _showPriceDialog(context),
                    ),
                  )
                : Padding(
                    padding: EdgeInsets.symmetric(vertical: 16),
                    child: ElevatedButton.icon(
                      icon: Icon(Icons.check),
                      label: Text(''),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: greenColor,
                        foregroundColor: secondaryColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        padding:
                            EdgeInsets.symmetric(horizontal: 70, vertical: 20),
                        textStyle: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      onPressed: () => _showPriceDialog(context),
                    ),
                  ),
            SizedBox(height: 16),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 16),
              child: ElevatedButton(
                child: Text('Објави оглас'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: blueColor,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(horizontal: 70, vertical: 20),
                  textStyle: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.zero,
                  ),
                ),
                onPressed: () {
                  _submitPost(
                      userProvider.getUser.uid, userProvider.getUser.username);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _submitPost(String uid, String username) async {
    if (_file == null) {
      showSnackBar(context, 'Please add an image for the post.');
      return;
    }
    if (_title.isEmpty) {
      showSnackBar(context, 'Please enter a title for the post.');
      return;
    }
    if (_decription.isEmpty) {
      showSnackBar(context, 'Please enter a description for the post.');
      return;
    }
    if (_price <= 0) {
      showSnackBar(context, 'Please enter a valid price for the post.');
      return;
    }
    try {
      String res = await FireStoreMethods().uploadPost(
        _titleController.text,
        _descriptionController.text,
        _price,
        _file!,
        uid,
        username,
      );
      if (res == "success") {
        // Clear the form
        _titleController.clear();
        _descriptionController.clear();
        _priceController.clear();
        setState(() {
          _file = null;
          _title = '';
          _decription = '';
          _price = 0;
        });

        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
              builder: (context) => ProfileScreen(uid: currentuser)),
        );
      } else {
        showSnackBar(context, res);
      }
    } catch (err) {
      showSnackBar(context, err.toString());
    }
  }
}
