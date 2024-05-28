import 'package:flutter/material.dart';
import 'package:senku_academy_mobile/base_url.dart';

const String baseApiURL = '$baseURL/api';
const Map<String, String> headers = {
  'Content-Type': 'application/json',
  'Accept': 'application/json',
};

errorSnackBar(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message),
      backgroundColor: Colors.red,
      duration: const Duration(seconds: 3),
    ),
  );
}
