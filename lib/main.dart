import 'package:flutter/material.dart';
import 'package:tmsui/pages/welcome.dart';
import 'package:tmsui/reusable/theme.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: WelcomeWidget(),
      theme: AppTheme.lightTheme,
    );
  }
}
