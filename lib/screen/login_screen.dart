// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:senku_academy_mobile/styles.dart';
import 'package:senku_academy_mobile/widget/custom_textfield.dart';
import 'package:senku_academy_mobile/controllers/login_controller.dart';
import 'package:senku_academy_mobile/controllers/token_controller.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String email = '';
  String password = '';
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool isObscureText = true;

  @override
  void initState() {
    super.initState();
    TokenController.getToken().then((token) {
      if (token != null) {
        context.go('/home');
      }
    });
  }

  Future<void> loginPressed(BuildContext context) async {
    email = emailController.text;
    password = passwordController.text;
    if (email.isNotEmpty && password.isNotEmpty) {
      var response = await LoginController.login(email, password);
      String responsemsg = response.body;
      Map<String, dynamic> responseMap = jsonDecode(responsemsg);
      String msg = responseMap['msg'];

      if (response.statusCode == 200) {
        GoRouter.of(context).go('/home');
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
          'Login',
          style: TextStyles.title,
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
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
              'Login Details',
              style: TextStyles.title.copyWith(fontSize: 20.0),
            ),
            const SizedBox(height: 16.0),
            CustomTextField(
              controller: emailController,
              textInputType: TextInputType.emailAddress,
              textInputAction: TextInputAction.next,
              hint: 'Email',
            ),
            const SizedBox(height: 16.0),
            CustomTextField(
              controller: passwordController,
              textInputType: TextInputType.visiblePassword,
              textInputAction: TextInputAction.done,
              hint: 'Password',
              isObscureText: isObscureText,
              hasSuffixIcon: true,
              onPressed: () {
                setState(() {
                  isObscureText = !isObscureText;
                });
              },
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () => loginPressed(context),
              style: ButtonStyle(
                backgroundColor:
                    MaterialStateProperty.all(const Color(0xff87c0cd)),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: Text(
                  'Login',
                  style: TextStyles.title
                      .copyWith(fontSize: 20.0, color: Colors.white),
                ),
              ),
            ),
            const SizedBox(height: 16.0),
            Text(
              'Don\'t have an account?',
              style: TextStyles.subtitle
                  .copyWith(fontSize: 18.0, color: Colors.black)
                  .copyWith(fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            GestureDetector(
              onTap: () => context.go('/register'),
              child: Text(
                'Register here',
                style: TextStyles.subtitle
                    .copyWith(fontSize: 18.0, color: Colors.blue)
                    .copyWith(fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
