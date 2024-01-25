import 'dart:typed_data';

import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:rewear/providers/user_provider.dart';
import 'package:rewear/model/user.dart';
import 'package:rewear/resources/database_method.dart';
import 'package:rewear/screens/home_screen.dart';
import 'package:rewear/screens/login_screen.dart';
import 'package:rewear/utils/colors.dart';
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
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  void _showPriceDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Enter Price"),
          content: TextField(
            controller: _priceController,
            keyboardType: TextInputType.numberWithOptions(decimal: false),
            inputFormatters: <TextInputFormatter>[
              FilteringTextInputFormatter.digitsOnly,
            ],
            decoration: InputDecoration(
              hintText: 'Enter the price here',
            ),
          ),
          actions: <Widget>[
            ElevatedButton(
              child: Text("OK"),
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
            SimpleDialogOption(
              child: const Text("Cancel"),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  void _showDescription(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Внеси опис"),
          content: TextField(
            controller: _descriptionController,
          ),
          actions: <Widget>[
            ElevatedButton(
              child: Text("OK"),
              onPressed: () async {
                setState(() {
                  _decription = _descriptionController.text;
                });

                Navigator.of(context).pop();
              },
            ),
            SimpleDialogOption(
              padding: const EdgeInsets.all(20),
              child: const Text("Откажи"),
              onPressed: () {
                Navigator.pop(context);
              },
            )
          ],
        );
      },
    );
  }

  void _showTitle(BuildContext context) {
    final EdgeInsets viewInsets = MediaQuery.of(context).viewInsets;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Align(
          alignment: Alignment.center,
          child: Padding(
            padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.05),
            child: Dialog(
              child: AlertDialog(
                title: Text("Внеси наслов"),
                content: SingleChildScrollView(
                  child: TextField(
                    controller: _titleController,
                    decoration: InputDecoration(
                      hintText: 'Внеси го твојот наслов тука',
                    ),
                  ),
                ),
                actions: <Widget>[
                  ElevatedButton(
                    child: Text("OK"),
                    onPressed: () {
                      setState(() {
                        _title = _titleController.text;
                      });
                      Navigator.of(context).pop();
                    },
                  ),
                  TextButton(
                    child: Text("Откажи"),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  _selectImage(BuildContext parentContext) async {
    return showDialog(
      context: parentContext,
      builder: (BuildContext context) {
        return SimpleDialog(
          title: const Text('Create a Post'),
          children: <Widget>[
            SimpleDialogOption(
                padding: const EdgeInsets.all(20),
                child: const Text('Употреби камера'),
                onPressed: () async {
                  Navigator.pop(context);
                  Uint8List file = await pickImage(ImageSource.camera);
                  setState(() {
                    _file = file;
                  });
                }),
            SimpleDialogOption(
                padding: const EdgeInsets.all(20),
                child: const Text('Избери слика од галерија'),
                onPressed: () async {
                  Navigator.of(context).pop();
                  Uint8List file = await pickImage(ImageSource.gallery);
                  setState(() {
                    _file = file;
                  });
                }),
            SimpleDialogOption(
              padding: const EdgeInsets.all(20),
              child: const Text("Откажи"),
              onPressed: () {
                Navigator.pop(context);
              },
            )
          ],
        );
      },
    );
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

    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        backgroundColor: Color.fromARGB(0, 245, 234, 234),
        title: SvgPicture.asset(
          'assets/ReWear.svg',
          height: 100,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Divider(height: 15,thickness: 2,),
            UserProfileHeader(username: username),
            const Divider(height: 15,thickness: 2,),
            SizedBox(height: 15,),
            _file == null
                ? Padding(
                    padding: EdgeInsets.symmetric(vertical: 16),
                    child: ElevatedButton.icon(
                      icon: Icon(Icons.add),
                      label: Text('Додај Слика'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: greenColor,
                        foregroundColor:secondaryColor,
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
                        foregroundColor:secondaryColor,
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
                        foregroundColor:secondaryColor,
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
                        foregroundColor:secondaryColor,
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
                        foregroundColor:secondaryColor,
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
                        foregroundColor:secondaryColor,
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
                        foregroundColor:secondaryColor,
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
                        foregroundColor:secondaryColor,
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
        setState(() {});
        if (context.mounted) {
          showSnackBar(
            context,
            'Posted!',
          );
        }
      } else {
        if (context.mounted) {
          showSnackBar(context, res);
        }
      }
    } catch (err) {
      showSnackBar(
        context,
        err.toString(),
      );
    }

    _titleController.clear();
    _descriptionController.clear();
    _priceController.clear();
    setState(() {
      _file = null;
      _title = '';
      _decription = '';
      _price = 0;
    });
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(
          builder: (context) =>
              AddPostScreen()), // to do change it when home screen is ready
      (Route<dynamic> route) => false,
    );
  }
}
