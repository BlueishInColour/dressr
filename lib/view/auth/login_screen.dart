import 'package:dressr/main.dart';
import 'package:dressr/view/utils/middle.dart';
import 'package:dressr/view/auth/auth_service.dart';
import 'package:dressr/view/utils/loading.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key, required this.onPressed});
  final void Function()? onPressed;
  @override
  State<LoginScreen> createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool isLoading = false;
  bool isGuestLoading = false;
  bool seePassword = true;

  login() async {
    setState(() {
      isLoading = true;
    });
    try {
      await AuthService().login(emailController.text, passwordController.text);
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      return ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('wrong email or password'),
        showCloseIcon: true,
      ));
    }
  }

  guestLogin() async {
    setState(() {
      isGuestLoading = true;
    });

    try {
      await FirebaseAuth.instance.signInAnonymously();
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      return ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('wrong email or password'),
        showCloseIcon: true,
      ));
    }
  }

  googleSignIn() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user;

    final GoogleSignIn googleSignIn = GoogleSignIn();

    final GoogleSignInAccount? googleSignInAccount =
        await googleSignIn.signIn();

    if (googleSignInAccount != null) {
      final GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );

      try {
        final UserCredential userCredential =
            await auth.signInWithCredential(credential);

        user = userCredential.user;
      } on FirebaseAuthException catch (e) {
        if (e.code == 'account-exists-with-different-credential') {
          // handle the error here
        } else if (e.code == 'invalid-credential') {
          // handle the error here
        }
      } catch (e) {
        // handle the error here
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Middle(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25.0),
          child: Center(
              child: ListView(
                  // mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                SizedBox(height: 100),
                Text(
                  'login',
                  style: GoogleFonts.montserrat(
                      fontSize: 60, fontWeight: FontWeight.w900),
                ),
                SizedBox(
                  height: 60,
                  child: TextFormField(
                    controller: emailController,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter an email address';
                      } else if (!RegExp(
                              r'^[\w-]+(\.[\w-]+)*@[\w-]+(\.[\w-]+)+$')
                          .hasMatch(value)) {
                        return 'Please enter a valid email address';
                      }
                      return null; // Return null if the input is valid
                    },
                    decoration: InputDecoration(
                      hintText: 'email',
                    ),
                  ),
                ),

                SizedBox(height: 15),
                SizedBox(
                  height: 60,
                  child: TextField(
                    controller: passwordController,
                    obscureText: seePassword,
                    decoration: InputDecoration(
                      hintText: 'password',
                      suffix: IconButton(
                        onPressed: () {
                          setState(() {
                            seePassword = !seePassword;
                          });
                        },
                        icon: Icon(
                          Icons.remove_red_eye,
                          color: !seePassword ? Colors.blue : Colors.black,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 15),
                //loginbutton
                !isLoading
                    ? GestureDetector(
                        onTap: () async {
                          await login();
                        },
                        child: Container(
                          decoration: BoxDecoration(
                              border:
                                  Border.all(color: Colors.black45, width: 2),
                              borderRadius: BorderRadius.circular(15),
                              color: const Color.fromRGBO(0, 0, 0, 1)),
                          height: 50,
                          child: Center(
                              child: Text('login',
                                  style: TextStyle(color: Colors.white))),
                        ),
                      )
                    : Container(
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.black45, width: 2),
                            borderRadius: BorderRadius.circular(15),
                            color: const Color.fromRGBO(0, 0, 0, 1)),
                        height: 60,
                        child: Center(child: Loading())),

                SizedBox(height: 15),
                Text('you don`t have an account?'),
                Row(
                  children: [
                    !isGuestLoading
                        ? Expanded(
                            child: GestureDetector(
                              onTap: () async {
                                await guestLogin();
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        color: Colors.black45, width: 2),
                                    borderRadius: BorderRadius.circular(15),
                                    color: const Color.fromRGBO(0, 0, 0, 1)),
                                height: 50,
                                child: Center(
                                    child: Text('guest',
                                        style: TextStyle(color: Colors.white))),
                              ),
                            ),
                          )
                        : Expanded(
                            child: Container(
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        color: Colors.black45, width: 2),
                                    borderRadius: BorderRadius.circular(15),
                                    color: const Color.fromRGBO(0, 0, 0, 1)),
                                height: 50,
                                child: Center(child: Loading())),
                          ),
                    SizedBox(width: 20),
                    Expanded(
                      child: GestureDetector(
                        onTap: widget.onPressed,
                        child: Container(
                          decoration: BoxDecoration(
                              border:
                                  Border.all(color: Colors.black45, width: 2),
                              borderRadius: BorderRadius.circular(15),
                              color: const Color.fromRGBO(0, 0, 0, 1)),
                          height: 50,
                          child: Center(
                              child: Text('register',
                                  style: TextStyle(color: Colors.white))),
                        ),
                      ),
                    )
                  ],
                ),

                //guests

                // Center(
                //   child: Text('or'),
                // ),
                // GestureDetector(
                //   onTap: googleSignIn,
                //   child: Container(
                //     decoration: BoxDecoration(
                //         border: Border.all(color: Colors.black45, width: 2),
                //         borderRadius: BorderRadius.circular(15),
                //         color: const Color.fromRGBO(0, 0, 0, 1)),
                //     height: 60,
                //     child: Center(
                //         child: Text('google',
                //             style: TextStyle(color: Colors.white))),
                //   ),
                // )
              ])),
        ),
      ),
    );
  }
}


//blueishincolour@gmail.com