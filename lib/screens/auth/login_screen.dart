import 'package:dressr/middle.dart';
import 'package:dressr/screens/auth/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

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

  googleSignIn() async {
    //    final GoogleSignIn googleSignIn = GoogleSignIn();
    // final GoogleSignInAccount googleSignInAccount = await googleSignIn.signIn();
    // if (googleSignInAccount != null) {
    //   final GoogleSignInAuthentication googleSignInAuthentication =
    //       await googleSignInAccount.authentication;
    //   final AuthCredential authCredential = GoogleAuthProvider.credential(
    //       idToken: googleSignInAuthentication.idToken,
    //       accessToken: googleSignInAuthentication.accessToken);

    // var auth = FirebaseAuth.instance;
    // UserCredential result = await auth.signInWithCredential(authCredential);
    // // User user = result.user;

    // // if (result != null) {
    // //   Navigator.pushReplacement(
    // //       context, MaterialPageRoute(builder: (context) => HomePage()));
    // // } //
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
                SizedBox(
                  height: 50,
                  child: TextField(
                    controller: emailController,
                    decoration: InputDecoration(
                      hintText: 'email',
                    ),
                  ),
                ),

                SizedBox(height: 15),
                SizedBox(
                  height: 50,
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
                          height: 60,
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
                        child: Center(child: CircularProgressIndicator())),

                SizedBox(height: 15),
                Row(
                  children: [
                    Text('you dont have an account?'),
                    TextButton(
                        onPressed: widget.onPressed,
                        child: Text('register now'))
                  ],
                ),

                Text('or'),
                GestureDetector(
                  onTap: googleSignIn,
                  child: Container(
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.black45, width: 2),
                        borderRadius: BorderRadius.circular(15),
                        color: const Color.fromRGBO(0, 0, 0, 1)),
                    height: 60,
                    child: Center(
                        child: Text('google',
                            style: TextStyle(color: Colors.white))),
                  ),
                )
              ])),
        ),
      ),
    );
  }
}
