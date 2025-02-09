import 'package:flutter/material.dart';
import 'package:tmsui/apis/userapi.dart';
import 'package:tmsui/reusable/theme.dart';
import 'package:tmsui/reusable/reftectinput.dart';
import 'package:tmsui/reusable/reftechbuttons.dart';
import 'package:tmsui/pages/page.dart';

class RegisterationWidget extends StatefulWidget {
  const RegisterationWidget({super.key});

  @override
  State<RegisterationWidget> createState() => _RegisterationWidgetState();
}

class _RegisterationWidgetState extends State<RegisterationWidget> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  void _register() async {
    try {
      await UserAPI.register(usernameController.text, emailController.text,
          passwordController.text);

      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Registration Successful!")));
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => const PageWidget()));
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Registration Failed!")));
      print("Encountered exception when registration in $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
              style: TextStyle(color: AppTheme.primaryColor),
              "REFTECH Solution"),
          centerTitle: true,
        ),
        body: Padding(
          padding: const EdgeInsets.only(top: 50, left: 16, right: 16),
          child: Column(
            children: [
              ReftechInputWidget(
                  hintText: "Username", controller: usernameController),
              const SizedBox(
                height: 15,
              ),
              ReftechInputWidget(
                  hintText: "Email", controller: emailController),
              const SizedBox(
                height: 15,
              ),
              ReftechInputWidget(
                  hintText: "Password", controller: passwordController),
              const SizedBox(
                height: 15,
              ),
              RefTechButton(
                  text: "Register", onPressed: _register, isPrimary: true)
            ],
          ),
        ));
  }
}
