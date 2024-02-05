import 'package:dressr/main.dart';
import 'package:dressr/screens/auth/login_or_signup.dart';
import 'package:dressr/screens/cart/index.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthGateTwo extends StatefulWidget {
  const AuthGateTwo({super.key});

  @override
  State<AuthGateTwo> createState() => AuthGateTwoState();
}

class AuthGateTwoState extends State<AuthGateTwo> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return MainIndex();
            } else {
              return LoginOrSignupScreen();
            }
          }),
    );
  }
}
