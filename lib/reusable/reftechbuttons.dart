import 'package:flutter/material.dart';
import 'package:tmsui/reusable/theme.dart';

class RefTechButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final bool isPrimary;

  const RefTechButton({
    super.key,
    required this.text,
    required this.onPressed,
    required this.isPrimary,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 60,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          elevation: 0,
          backgroundColor:
              isPrimary ? AppTheme.primaryColor : AppTheme.secondaryColor,
        ),
        child: Text(
          text,
          style: TextStyle(
            color: isPrimary
                ? AppTheme.primaryTextColor
                : AppTheme.secondaryTextColor,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
