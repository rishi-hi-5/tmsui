import 'package:flutter/material.dart';
import 'package:tmsui/apis/userapi.dart';
import 'package:tmsui/pages/page.dart';
import 'package:tmsui/reusable/reftechbuttons.dart';
import 'package:tmsui/reusable/reftectinput.dart';
import 'package:tmsui/reusable/theme.dart';

class LoginWidget extends StatefulWidget {
  const LoginWidget({super.key});

  @override
  State<LoginWidget> createState() => _LoginWidgetState();
}

class _LoginWidgetState extends State<LoginWidget> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  void _login() async {
    try {
      final response =
          await UserAPI.login(emailController.text, passwordController.text);

      if (response.containsKey("accessToken")) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("Login Successful!")));
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const PageWidget()));
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("Login Failed!")));
        print("Login Failed with message ${response['message']}");
      }
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Login Failed!")));
      print("Encountered exception when logging in $e");
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
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Image.asset("assets/images/reftech.png"),
              ),
              ReftechInputWidget(
                  hintText: "Email", controller: emailController),
              const SizedBox(
                height: 15,
              ),
              ReftechInputWidget(
                  hintText: "Password", controller: passwordController),
              const SizedBox(
                height: 20,
              ),
              RefTechButton(text: "Login", onPressed: _login, isPrimary: true)
            ],
          ),
        ));
  }
}
