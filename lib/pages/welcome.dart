import 'package:flutter/material.dart';
import 'package:tmsui/reusable/reftechbuttons.dart';
import 'package:tmsui/reusable/theme.dart';
import 'package:tmsui/pages/login.dart';
import 'package:tmsui/pages/register.dart';

class WelcomeWidget extends StatelessWidget {
  const WelcomeWidget({super.key});

  @override
  Widget build(BuildContext context) {
    void goToLogin() {
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => const LoginWidget()));
    }

    void goToRegistration() {
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => const RegisterationWidget()));
    }

    return Scaffold(
      backgroundColor: AppTheme.secondaryColor,
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(bottom: 120, right: 39, left: 39),
        child: Row(
          children: [
            Expanded(
                child: RefTechButton(
                    text: "Login", isPrimary: true, onPressed: goToLogin)),
            SizedBox(
              width: 30,
            ),
            Expanded(
                child: SizedBox(
              height: 60,
              child: RefTechButton(
                  text: "Register",
                  isPrimary: false,
                  onPressed: goToRegistration),
            ))
          ],
        ),
      ),
      appBar: AppBar(
        title: Text(
            style: TextStyle(color: AppTheme.primaryColor), "REFTECH Solution"),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Image.asset("assets/images/reftech.png"),
          ),
          Text(
            "Tracking Solution \nby RefTech",
            style: TextStyle(
              fontSize: 35,
              color: AppTheme.primaryColor,
            ),
            textAlign: TextAlign.center,
          )
        ],
      ),
    );
  }
}
