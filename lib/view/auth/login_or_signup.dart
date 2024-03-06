import 'package:dressr/view/auth/login_screen.dart';
import 'package:dressr/view/auth/signup_screen.dart';
import 'package:flutter/material.dart';

class LoginOrSignupScreen extends StatefulWidget {
  const LoginOrSignupScreen({super.key});

  @override
  State<LoginOrSignupScreen> createState() => LoginOrSignupScreenState();
}

class LoginOrSignupScreenState extends State<LoginOrSignupScreen> {
  bool showLogin = true;
  @override
  Widget build(BuildContext context) {
    return showLogin
        ? LoginScreen(
            onPressed: () {
              setState(() {
                showLogin = false;
              });
            },
          )
        : SignupScreen(
            onPressed: () {
              setState(() {
                showLogin = true;
              });
            },
          );
  }
}
