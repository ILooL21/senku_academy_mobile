// ignore_for_file: use_build_context_synchronously
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:senku_academy_mobile/controllers/login_controller.dart';
import 'package:senku_academy_mobile/controllers/token_controller.dart';
import 'package:go_router/go_router.dart';

class Navbar extends StatefulWidget {
  const Navbar({super.key});

  @override
  State<Navbar> createState() => _NavbarState();
}

class _NavbarState extends State<Navbar> {
  String email = '';
  String username = '';

  //ambil token, lalu decode json token, lalu ambil data user
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

  logoutPressed() async {
    var response = await LoginController.logout();

    if (response.statusCode == 200) {
      context.go('/');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Gagal logout'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.white,
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          UserAccountsDrawerHeader(
            accountName: Text(username),
            accountEmail: Text(email),
            decoration: const BoxDecoration(
              color: Color(0xff87c0cd),
            ),
          ),
          ListTile(
            title: const Text('Home'),
            onTap: () {
              context.go('/home');
            },
          ),
          ListTile(
            title: const Text('Profile'),
            onTap: () {
              context.go('/profile');
            },
          ),
          ListTile(
            title: const Text('Logout'),
            onTap: () {
              logoutPressed();
            },
          ),
        ],
      ),
    );
  }
}
