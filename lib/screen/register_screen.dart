// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:senku_academy_mobile/styles.dart';
import 'package:senku_academy_mobile/widget/custom_textfield.dart';
import 'package:senku_academy_mobile/controllers/token_controller.dart';
import 'package:senku_academy_mobile/controllers/register_controller.dart';
import 'package:go_router/go_router.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  String username = '';
  String email = '';
  String password = '';
  String confirmPassword = '';

  final usernameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  bool isObscureText1 = true;
  bool isObscureText2 = true;

  @override
  void initState() {
    super.initState();
    TokenController.getToken().then((token) {
      if (token != null) {
        context.go('/home');
      }
    });
  }

  registerPressed() async {
    if (username.isNotEmpty &&
        email.isNotEmpty &&
        password.isNotEmpty &&
        confirmPassword.isNotEmpty) {
      if (password == confirmPassword) {
        var response =
            await RegistrationController.register(username, email, password);
        //Message from the API
        String responsemsg = response.body; // Define the variable parsedJson
        Map<String, dynamic> responseMap = jsonDecode(responsemsg);
        String msg = responseMap['msg'];
        if (response.statusCode == 201) {
          context.go('/');
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(msg),
            ),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Password does not match!'),
          ),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill in all fields!'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            'Create Account',
            style: TextStyles.title,
          ),
          centerTitle: true,
          backgroundColor: Colors.white,
          elevation: 0,
        ),
        body: SingleChildScrollView(
            child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Image.asset(
                'assets/images/logo.png',
                width: 200,
                height: 200,
                alignment: Alignment.center,
              ),
              const SizedBox(height: 16.0),
              Text(
                'Register Details',
                style: TextStyles.title.copyWith(fontSize: 20.0),
              ),
              const SizedBox(height: 16.0),
              CustomTextField(
                  controller: usernameController,
                  textInputType: TextInputType.text,
                  textInputAction: TextInputAction.next,
                  hint: 'Username'),
              const SizedBox(height: 16.0),
              CustomTextField(
                  controller: emailController,
                  textInputType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  hint: 'Email'),
              const SizedBox(height: 16.0),
              CustomTextField(
                controller: passwordController,
                textInputType: TextInputType.visiblePassword,
                textInputAction: TextInputAction.next,
                hint: 'Password',
                isObscureText: isObscureText1,
                hasSuffixIcon: true,
                onPressed: () {
                  setState(() {
                    isObscureText1 = !isObscureText1;
                  });
                },
              ),
              const SizedBox(height: 16.0),
              CustomTextField(
                controller: confirmPasswordController,
                textInputType: TextInputType.visiblePassword,
                textInputAction: TextInputAction.done,
                hint: 'Confirm Password',
                isObscureText: isObscureText2,
                hasSuffixIcon: true,
                onPressed: () {
                  setState(() {
                    isObscureText2 = !isObscureText2;
                  });
                },
              ),
              const SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () {
                  username = usernameController.text;
                  email = emailController.text;
                  password = passwordController.text;
                  confirmPassword = confirmPasswordController.text;
                  registerPressed();
                },
                style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all(const Color(0xff87c0cd)),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: Text(
                    'Register',
                    style: TextStyles.title
                        .copyWith(fontSize: 20.0, color: Colors.white),
                  ),
                ),
              ),
              const SizedBox(height: 16.0),
              Text(
                'Already have an account?',
                style: TextStyles.subtitle
                    .copyWith(fontSize: 18.0, color: Colors.black)
                    .copyWith(fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              GestureDetector(
                onTap: () {
                  context.go('/');
                },
                child: Text(
                  'Login here',
                  style: TextStyles.subtitle
                      .copyWith(fontSize: 18.0, color: Colors.blue)
                      .copyWith(fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        )));
  }
}
