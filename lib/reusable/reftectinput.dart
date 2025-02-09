import 'package:flutter/material.dart';
import 'package:tmsui/reusable/theme.dart';

class ReftechInputWidget extends StatelessWidget {
  final String hintText;
  final TextEditingController controller;
  final bool isPassword;

  const ReftechInputWidget({
    super.key,
    required this.hintText,
    required this.controller,
    this.isPassword = false,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      style: TextStyle(color: AppTheme.secondaryTextColor),
      controller: controller,
      obscureText: isPassword,
      decoration: InputDecoration(
        hintText: hintText,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
      ),
    );
  }
}
