import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:rewear/resources/authentication_metods.dart';
import 'package:rewear/responsive/mobile_screen_layout.dart';
import 'package:rewear/responsive/responsive_layout.dart';
import 'package:rewear/responsive/web_screen_layout.dart';
import 'package:rewear/screens/signup_screen.dart';
import 'package:rewear/service/notification_service.dart';
import 'package:rewear/utils/dimensions.dart';
import 'package:rewear/utils/imagePickerAndSnackBar.dart';
import 'package:rewear/widgets/text_field_input.dart';

import '../utils/colors.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;
  final notifications = NotificationsService();
  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void loginUser() async {
    setState(() {
      _isLoading = true;
    });
    String res = await AuthenticationMethods().loginUser(
      email: _emailController.text,
      password: _passwordController.text,
    );
    await notifications.requestPermission();
    await notifications.getToken();

    if (res == "success") {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
            builder: (context) => const ResponsiveLayout(
                  mobileScreenLayout: MobileScreenLayout(),
                  webScreenLayout: WebScreenLayout(),
                )),
      );
    } else {
      //To do: implement exceptions
      setState(() {
        _isLoading = false;
      });
      print("error");
      showSnackBar(context, res);
    }
  }

  void navigateToSignup() async {
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const SignupScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: mobileBackgroundColor,
        title: SvgPicture.asset(
          'assets/ReWear.svg',
          height: 100,
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          // Wrap content in SingleChildScrollView
          child: Container(
            padding: MediaQuery.of(context).size.width > webScreenSize
                ? EdgeInsets.symmetric(
                    horizontal: MediaQuery.of(context).size.width / 3)
                : const EdgeInsets.symmetric(horizontal: 40),
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 60),
                const Text(
                  'LOG IN',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 40,
                    fontFamily: 'Helvetica',
                    color: Color.fromRGBO(24, 29, 49, 1),
                  ),
                ),
                const SizedBox(height: 80),
                TextFieldInput(
                  hintText: 'Enter your email',
                  textInputType: TextInputType.emailAddress,
                  textEditingController: _emailController,
                ),
                const SizedBox(height: 24),
                TextFieldInput(
                  hintText: 'Enter your password',
                  textInputType: TextInputType.text,
                  textEditingController: _passwordController,
                  isPass: true,
                ),
                SizedBox(height: 50),
                InkWell(
                  onTap: loginUser,
                  child: Container(
                    width: double.infinity,
                    alignment: Alignment.center,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    decoration: const ShapeDecoration(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(4)),
                      ),
                      color: Color.fromRGBO(24, 29, 49, 1),
                    ),
                    child: _isLoading
                        ? const CircularProgressIndicator(
                            color: Colors.white,
                          )
                        : const Text(
                            'Log in',
                            style: TextStyle(
                                color: Color.fromRGBO(241, 239, 239, 1)),
                          ),
                  ),
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.1),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Don't have an account?"),
                    GestureDetector(
                      onTap: navigateToSignup,
                      child: Text("Sign up?",
                          style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                  ],
                ),
                SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
