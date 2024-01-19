import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:rewear/widgets/text_field_input.dart';

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
  final TextEditingController _usernamewordController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _nameController.dispose();
    _surnameController.dispose();
    _usernamewordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Flexible(child: Container(), flex: 1,),
              SvgPicture.asset('assets/ReWear-_2_.svg', height: 90),
              const SizedBox(height: 20),
              const Text('Креирај Профил',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 40,
                  fontFamily: 'Helvetica',
                  color: Color.fromRGBO(24, 29, 49,1),),),
              const SizedBox(height: 50),
              TextFieldInput(
                hintText: 'Внеси име',
                textInputType: TextInputType.text,
                textEditingController: _passwordController,
              ),
              const SizedBox(
                height: 20,
              ),
              TextFieldInput(
                hintText: 'Внеси Презиме',
                textInputType: TextInputType.text,
                textEditingController: _surnameController,
              ),
              const SizedBox(
                height: 20,
              ),
              TextFieldInput(
                hintText: 'Внеси корисничко име',
                textInputType: TextInputType.text,
                textEditingController: _usernamewordController,
              ),
              const SizedBox(
                height: 20,
              ),
              TextFieldInput(
                hintText: 'Внеси email',
                textInputType: TextInputType.emailAddress,
                textEditingController: _emailController,
              ),
              const SizedBox(
                height: 20,
              ),
              TextFieldInput(
                hintText: 'Внеси лозинка',
                textInputType: TextInputType.text,
                textEditingController: _passwordController,
                isPass: true,
              ),
              const SizedBox(
                height: 20,
              ),

              InkWell(
                  child: Container(
                    width: double.infinity,
                    alignment: Alignment.center,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    decoration: const ShapeDecoration(shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(4),
                      ),
                    ),
                        color: Color.fromRGBO(24, 29, 49,1)                ),
                    child: const Text('Креирај', style: TextStyle(color: Color.fromRGBO(241, 239, 239,1)),),
                  )),
              const SizedBox(
                height: 50,
              ),
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.center,
              //   children: [
              //     Container(
              //       child: Text("Don't have an account?"),
              //       padding: const EdgeInsets.symmetric(
              //         vertical: 8,
              //       ),
              //     ),
              //     GestureDetector(
              //         onTap: (){},
              //         child: Container(
              //           child: Text("Sing up?", style: TextStyle( fontWeight: FontWeight.bold),),
              //           padding: const EdgeInsets.symmetric(
              //             vertical: 8,
              //           ),
              //         )
              //     )
              //   ],
              // )
            ],
          ),
        ),
      ),
    );
  }
}
