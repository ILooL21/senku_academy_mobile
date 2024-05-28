import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:senku_academy_mobile/styles.dart';
import 'package:senku_academy_mobile/widget/custom_textfield.dart';
import 'package:senku_academy_mobile/widget/custom_navbar.dart';
import 'package:senku_academy_mobile/controllers/token_controller.dart';
import 'package:senku_academy_mobile/controllers/profile_controller.dart';
import 'package:go_router/go_router.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String newEmail = '';
  String email = '';
  String newUsername = '';
  String username = '';
  String oldPassword = '';
  String newPassword = '';
  String confirmPassword = '';

  final emailController = TextEditingController();
  final usernameController = TextEditingController();
  final oldpasswordController = TextEditingController();
  final newpasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  bool isObscureText1 = true;
  bool isObscureText2 = true;
  bool isObscureText3 = true;

  updateProfile() {
    if (oldPassword.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Password lama tidak boleh kosong'),
        ),
      );
      return;
    }

    if (newPassword != confirmPassword) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Password tidak sama'),
        ),
      );
      return;
    }
    ProfileController.updateProfile(
            newEmail, newUsername, oldPassword, newPassword)
        .then((response) {
      String responsemsg = response.body; // Define the variable parsedJson
      Map<String, dynamic> responseMap = jsonDecode(responsemsg);
      String msg = responseMap['msg'];
      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Profile berhasil diupdate"),
          ),
        );
        context.go('/home');
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(msg),
          ),
        );
      }
    });
  }

  @override
  void initState() {
    super.initState();
    TokenController.getToken().then((token) {
      if (token != null) {
        var tokenJson = token;
        var tokenMap = jsonDecode(tokenJson);
        var user = tokenMap['user'];
        setState(() {
          email = user['email'];
          username = user['username'];
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'PROFILE',
          style: TextStyles.title,
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      drawer: const Navbar(),
      body: SingleChildScrollView(
          child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Profile Details',
              style: TextStyles.title.copyWith(fontSize: 20.0),
            ),
            const SizedBox(height: 30.0),
            Text(
              'Username',
              style: TextStyles.title.copyWith(fontSize: 20.0),
            ),
            const SizedBox(height: 5.0),
            CustomTextField(
                controller: usernameController,
                textInputType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
                hint: username),
            const SizedBox(height: 16.0),
            Text(
              'Email',
              style: TextStyles.title.copyWith(fontSize: 20.0),
            ),
            const SizedBox(height: 5.0),
            CustomTextField(
                controller: emailController,
                textInputType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
                readOnly: true,
                hint: email),
            const SizedBox(height: 16.0),
            Text(
              'Password',
              style: TextStyles.title.copyWith(fontSize: 20.0),
            ),
            const SizedBox(height: 5.0),
            CustomTextField(
              controller: oldpasswordController,
              textInputType: TextInputType.visiblePassword,
              textInputAction: TextInputAction.next,
              hint: 'Old Password',
              isObscureText: isObscureText1,
              hasSuffixIcon: true,
              onPressed: () {
                setState(() {
                  isObscureText1 = !isObscureText1;
                });
              },
            ),
            const SizedBox(height: 5.0),
            CustomTextField(
              controller: newpasswordController,
              textInputType: TextInputType.visiblePassword,
              textInputAction: TextInputAction.next,
              hint: 'New Password',
              isObscureText: isObscureText2,
              hasSuffixIcon: true,
              onPressed: () {
                setState(() {
                  isObscureText2 = !isObscureText2;
                });
              },
            ),
            const SizedBox(height: 5.0),
            CustomTextField(
              controller: confirmPasswordController,
              textInputType: TextInputType.visiblePassword,
              textInputAction: TextInputAction.done,
              hint: 'Confirm Password',
              isObscureText: isObscureText3,
              hasSuffixIcon: true,
              onPressed: () {
                setState(() {
                  isObscureText3 = !isObscureText3;
                });
              },
            ),
            const SizedBox(height: 30.0),
            ElevatedButton(
              onPressed: () {
                newUsername = usernameController.text;
                newEmail = email;
                oldPassword = oldpasswordController.text;
                newPassword = newpasswordController.text;
                confirmPassword = confirmPasswordController.text;
                updateProfile();
              },
              style: ButtonStyle(
                backgroundColor:
                    MaterialStateProperty.all(const Color(0xff87c0cd)),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: Text(
                  'Simpan Perubahan',
                  style: TextStyles.title
                      .copyWith(fontSize: 20.0, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      )),
    );
  }
}
