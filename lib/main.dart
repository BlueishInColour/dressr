import 'dart:async';

// import 'package:dressr/screens/auth/auth_gate.dart';
import 'package:dressr/middle.dart';
import 'package:dressr/screens/auth/auth_gate_two.dart';
import 'package:dressr/screens/auth/login_or_signup.dart';
import 'package:dressr/screens/auth/signup_screen.dart';
import 'package:dressr/screens/save/index.dart';
import 'package:dressr/screens/chat/index.dart';
import 'package:dressr/screens/create_post/index.dart';
import 'package:dressr/screens/profile/index.dart';
import 'package:dressr/screens/search/index.dart';
import 'package:dressr/screens/search/post_search.dart';
// import 'package:dressr/screens/store/add_item.dart';
import 'package:dressr/screens/explore/index.dart';
import 'package:dressr/screens/tv/index.dart';
import 'package:dressr/utils/install_app_function.dart';
import 'package:dressr/utils/shared_pref.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hidable/hidable.dart';
import 'package:ionicons/ionicons.dart';
// dressr@gmail.com
// Oluwapelumide631$
import 'package:google_fonts/google_fonts.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:line_icons/line_icons.dart';
import 'firebase_options.dart';
import 'screens/auth/login_screen.dart';
// import 'package:window_manager/window_manager.dart';
import 'package:flutter_windowmanager/flutter_windowmanager.dart';

//to prevent screenshots in app
Future<void> secureScreen() async {
  await FlutterWindowManager.addFlags(FlutterWindowManager.FLAG_SECURE);
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  if (!kIsWeb) {
    secureScreen();
  }
  // await FirebaseAppCheck.instance.activate(
  //   // androidProvider: AndroidProvider.playIntegrity,
  //   webProvider:
  //       ReCaptchaV3Provider('6LfPKFIpAAAAAGPzlYpoSWP6keZI1ikn8aSLXj0H'),
  // );

  // olami@gmail.com

  await SharedPrefs().init();

  runApp(
    const MyApp(),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
          appBarTheme:
              AppBarTheme(backgroundColor: Colors.transparent, elevation: 0),
          outlinedButtonTheme: OutlinedButtonThemeData(
              style: ButtonStyle(
            shape: MaterialStatePropertyAll(
                StadiumBorder(side: BorderSide(color: Colors.blue.shade600))),
          )),
          elevatedButtonTheme: ElevatedButtonThemeData(
              style: ButtonStyle(
                  shape: MaterialStatePropertyAll(StadiumBorder()))),
          inputDecorationTheme: InputDecorationTheme(
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide(color: Colors.grey.shade200, width: 6),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide(color: Colors.blue.shade300, width: 6),
            ),
          ),
          dropdownMenuTheme: DropdownMenuThemeData(
              textStyle: TextStyle(color: Colors.white60),
              inputDecorationTheme: InputDecorationTheme(
                hintStyle: TextStyle(fontSize: 11),
                constraints: BoxConstraints(maxHeight: 30, maxWidth: 100),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide(color: Colors.black),
                ),
                outlineBorder: BorderSide(color: Colors.black),
              ),
              menuStyle: MenuStyle(
                  maximumSize: MaterialStatePropertyAll(Size(300, 300)),
                  elevation: MaterialStatePropertyAll(0),
                  backgroundColor:
                      MaterialStatePropertyAll(Colors.transparent)))),
      debugShowCheckedModeBanner: false,
      home: const SplashScreen(),
    );
  }
}

// import 'package:flutter/material.dart';
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});
  @override
  SplashScreenState createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen> {
  int currentMainIndex = 3;
  @override
  void initState() {
    super.initState();
    Timer(
        const Duration(seconds: 3),
        () => Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const AuthGateTwo(),
            )));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ShaderMask(
              shaderCallback: (Rect bounds) {
                return LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Colors.blue, Colors.purple, Colors.red])
                    .createShader(bounds);
              },
              child: Center(
                child: Icon(
                  Icons.star_rounded,
                  color: Colors.white,
                  size: 120.0,
                ),
              ),
            ),
            // Image.asset('assets/icon.png', height: 100),
            SizedBox(height: 100),
            Text('dressmate', style: GoogleFonts.pacifico(color: Colors.black))
          ],
        ),
      ),
    );
  }
}

// import 'package:flutter/material.dart';
//
class MainIndex extends StatefulWidget {
  const MainIndex({super.key});

  @override
  State<MainIndex> createState() => MainIndexState();
}

class MainIndexState extends State<MainIndex> {
  int currentMainIndex = 0;

  final controller = ScrollController();

  @override
  void dispose() async {
    super.dispose();
    await FlutterWindowManager.clearFlags(FlutterWindowManager.FLAG_SECURE);
  }

  @override
  Widget build(BuildContext context) {
    return Middle(
      width: 500,
      child: Scaffold(
        body: [
          // LoginScreen(),
          // SignupScreen(),
          // LoginOrSignupScreen(),
          // AuthGateTwo(),
          StoreScreen(controller: controller),
          // BlogScre
          Tv(),
          PostSearch(),
          LikeScreen(),
          kIsWeb ? InstallApp() : CreateScreen(ancestorId: '')
          // AddItem(headPostId: ''),
          // ProfileScreen(userUid: FirebaseAuth.instance.currentUser!.uid),
          // EditProfile()
        ][currentMainIndex],
        bottomNavigationBar: SizedBox(
          height: 55,
          child: Theme(
            data: Theme.of(context).copyWith(
              canvasColor: Colors.black,
            ),
            child: BottomNavigationBar(
                currentIndex: currentMainIndex,
                onTap: (v) {
                  setState(() {
                    currentMainIndex = v;
                  });
                },
                showSelectedLabels: false,
                items: <BottomNavigationBarItem>[
                  //
                  // featured
                  BottomNavigationBarItem(
                      label: 'home',
                      icon: Icon(
                        Icons.home_outlined,
                        color: Colors.white38,
                        size: 17,
                      ),
                      activeIcon: Icon(
                        Icons.home_filled,
                        color: Colors.white,
                        size: 17,
                      )),

                  // blog
                  BottomNavigationBarItem(
                    label: 'tv',
                    icon: Icon(
                      Icons.live_tv_rounded,
                      color: Colors.white38,
                      size: 17,
                      weight: 10,
                    ),
                    activeIcon: Icon(Icons.live_tv_rounded,
                        size: 17, color: Colors.white),
                  ),

                  BottomNavigationBarItem(
                    label: 'search',
                    icon: Icon(
                      Icons.search,
                      color: Colors.white38,
                      size: 17,
                      weight: 10,
                    ),
                    activeIcon:
                        Icon(Icons.search, size: 17, color: Colors.white),
                  ),

                  BottomNavigationBarItem(
                    label: 'saved',
                    icon: Icon(
                      Icons.favorite_border,
                      size: 17,
                      color: Colors.white38,
                    ),
                    activeIcon: Icon(Icons.favorite_rounded,
                        size: 17, color: Colors.white),
                  ),
                  //chat
                  BottomNavigationBarItem(
                    label: 'chat',
                    icon: CircleAvatar(
                      radius: 9,
                      backgroundColor: Colors.white,
                      child: Icon(
                        Icons.add,
                        color: Colors.black,
                        size: 17,
                      ),
                    ),
                    activeIcon: Icon(Icons.add, size: 15, color: Colors.white),
                  ),
                  //   BottomNavigationBarItem(
                  //     label: 'profile',
                  //     icon: Icon(
                  //       Icons.person,
                  //       color: Colors.black26,
                  //     ),
                  //     activeIcon: Icon(Icons.person, color: Colors.black),
                  //   ),
                  // ]),
                  // BottomNavigationBarItem(
                  //   label: 'profile',
                  //   icon: Icon(Icons.person, color: Colors.black26),
                  //   activeIcon: Icon(Icons.person, color: Colors.black),
                  // ), // upload
                  //mine
                ]),
          ),
        ),
        resizeToAvoidBottomInset: false,
      ),
    );
  }
}



// boxy@gmail.com