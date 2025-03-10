import 'package:flutter/material.dart';
import 'package:tmsui/pages/driver.dart';
import 'package:tmsui/pages/vehicle.dart';
import 'package:tmsui/pages/welcome.dart';
import 'package:tmsui/reusable/theme.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  runApp(ProviderScope(child: MainApp()));
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      // home: WelcomeWidget(),
      home: VehicleManagement(),
      theme: AppTheme.lightTheme,
    );
  }
}
