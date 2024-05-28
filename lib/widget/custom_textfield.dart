import 'package:flutter/material.dart';
import 'package:senku_academy_mobile/styles.dart';

class CustomTextField extends StatelessWidget {
  const CustomTextField({
    required this.controller,
    required this.textInputType,
    required this.textInputAction,
    required this.hint,
    this.isObscureText = false,
    this.hasSuffixIcon = false,
    this.readOnly = false,
    this.onPressed,
    super.key,
  });

  final TextEditingController controller;
  final TextInputType textInputType;
  final TextInputAction textInputAction;
  final String hint;
  final bool readOnly;
  final bool isObscureText;
  final bool hasSuffixIcon;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType: textInputType,
      textInputAction: textInputAction,
      obscureText: isObscureText,
      readOnly: readOnly,
      //buat jika readOnly true maka background color akan berubah
      decoration: InputDecoration(
        filled: readOnly,
        fillColor: readOnly ? Colors.grey[400] : null,
        suffixIcon: hasSuffixIcon
            ? IconButton(
                onPressed: onPressed,
                icon: Icon(
                  isObscureText ? Icons.visibility : Icons.visibility_off,
                ),
              )
            : null,
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(
            width: 1.0,
            color: AppColors.darkGrey,
          ),
          borderRadius: BorderRadius.circular(5.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(
            width: 1.0,
            color: AppColors.darkGrey,
          ),
          borderRadius: BorderRadius.circular(5.0),
        ),
        hintText: hint,
      ),
    );
  }
}
