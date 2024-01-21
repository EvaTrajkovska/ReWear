import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:rewear/resources/authentication_metods.dart';
import 'package:rewear/responsive/mobile_screen_layout.dart';
import 'package:rewear/responsive/responsive_layout.dart';
import 'package:rewear/responsive/web_screen_layout.dart';
import 'package:rewear/screens/login_screen.dart';
import 'package:rewear/utils/image_picker.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _surnameController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _nameController.dispose();
    _surnameController.dispose();
    _usernameController.dispose();
    super.dispose();
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    required TextInputType textInputType,
    bool isPass = false,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        hintText: hintText,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      ),
      keyboardType: textInputType,
      obscureText: isPass,
    );
  }

  void signUpUser() async {
    setState(() {
      _isLoading = true;
    });

    String res = await AuthenticationMetods().signUpUser(
        name: _nameController.text,
        surname: _surnameController.text,
        email: _emailController.text,
        password: _passwordController.text,
        username: _usernameController.text);

      if (res != "succes"){
        showSnackBar(context, res);
        setState(() {
          _isLoading = false;
        });
      }else{
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
              builder: (context) => ResponsiveLayout(
              mobileScreenLayout: MobileScreenLayout(),
                webScreenLayout: WebScreenLayout(),
    ),
        ),
        );
      }
    }

      void navigateToLogin() {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => const LoginScreen(),
          ),
        );
      }


  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: size.width * 0.08),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: size.height * 0.05),
              SvgPicture.asset('assets/ReWear-_2_.svg',
                  height: size.height * 0.1),
              SizedBox(height: size.height * 0.02),
              Text(
                'Креирај Профил',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: size.width * 0.1,
                  fontFamily: 'Helvetica',
                  color: Color.fromRGBO(24, 29, 49, 1),
                ),
              ),
              SizedBox(height: size.height * 0.05),
              _buildTextField(
                controller: _nameController,
                hintText: 'Внеси име',
                textInputType: TextInputType.text,
              ),
              SizedBox(height: size.height * 0.02),
              _buildTextField(
                controller: _surnameController,
                hintText: 'Внеси Презиме',
                textInputType: TextInputType.text,
              ),
              SizedBox(height: size.height * 0.02),
              _buildTextField(
                controller: _usernameController,
                hintText: 'Внеси корисничко име',
                textInputType: TextInputType.text,
              ),
              SizedBox(height: size.height * 0.02),
              _buildTextField(
                controller: _emailController,
                hintText: 'Внеси email',
                textInputType: TextInputType.emailAddress,
              ),
              SizedBox(height: size.height * 0.02),
              _buildTextField(
                controller: _passwordController,
                hintText: 'Внеси лозинка',
                textInputType: TextInputType.text,
                isPass: true,
              ),
              SizedBox(height: size.height * 0.05),
              InkWell(
                onTap: signUpUser,
                child: Container(
                  width: double.infinity,
                  alignment: Alignment.center,
                  padding: EdgeInsets.symmetric(vertical: size.height * 0.015),
                  decoration: ShapeDecoration(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(4)),
                    ),
                    color: Color.fromRGBO(24, 29, 49, 1),
                  ),
                  child: Text(
                    'Креирај',
                    style: TextStyle(color: Color.fromRGBO(241, 239, 239, 1)),
                  ),
                ),
              ),
              SizedBox(height: size.height * 0.05),
              GestureDetector(
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const LoginScreen(),
                  ),
                ),
                child: Text(
                  "Веќе имаш профил? Најави се",
                  style: TextStyle(
                    decoration: TextDecoration.underline,
                    color: Colors.blue,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
