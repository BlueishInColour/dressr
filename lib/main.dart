import 'dart:async';

// import 'package:dressr/view/auth/auth_gate.dart';
import 'package:dressr/controller/laundry_controller.dart';
import 'package:dressr/view/utils/loading_page.dart';
import 'package:dressr/view/utils/middle.dart';
import 'package:dressr/view/auth/auth_gate_two.dart';
import 'package:dressr/view/auth/login_or_signup.dart';
import 'package:dressr/view/auth/signup_screen.dart';
import 'package:dressr/view/create_post/create.dart';
import 'package:dressr/view/save/index.dart';
import 'package:dressr/view/chat/index.dart';
import 'package:dressr/view/create_post/index.dart';
import 'package:dressr/view/profile/index.dart';
import 'package:dressr/view/search/index.dart';
import 'package:dressr/view/search/post_search.dart';
import 'package:dressr/view/explore/index.dart';
import 'package:dressr/view/tv/index.dart';
import 'package:dressr/view/management/install_app_function.dart';
import 'package:dressr/view/utils/loading.dart';
import 'package:dressr/view/utils/shared_pref.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:hidable/hidable.dart';
import 'package:ionicons/ionicons.dart';
// dressr@gmail.com
// Oluwapelumide631$
import 'package:google_fonts/google_fonts.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:line_icons/line_icons.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';
import 'view/auth/login_screen.dart';
// import 'package:window_manager/window_manager.dart';
import 'package:flutter_windowmanager/flutter_windowmanager.dart';

import 'package:flutterwave_web_client/flutterwave_web_client.dart';
// import 'package:admob_flutter/admob_flutter.dart';

//to prevent viewhots in app
Future<void> secureScreen() async {
  await FlutterWindowManager.addFlags(FlutterWindowManager.FLAG_SECURE);
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  // Admob.initialize();
  unawaited(MobileAds.instance.initialize());
  // if (kIsWeb) {
  //   FlutterwaveWebClient.initialize(
  //       'FLWPUBK_TEST-ef4d818fa96ee72db01e180edd283079-X');
  // }
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
    ChangeNotifierProvider(
        create: (_) => LaundryController(), child: const MyApp()),
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
            elevation: MaterialStatePropertyAll(5),
            foregroundColor: MaterialStatePropertyAll(Colors.blue),
            padding:
                MaterialStatePropertyAll(EdgeInsets.symmetric(horizontal: 5)),
            side: MaterialStatePropertyAll(BorderSide(color: Colors.blue)),
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
        const Duration(seconds: 5),
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
      body: Center(child: Loading()),
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
          CreatePost(ancestorId: '')
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