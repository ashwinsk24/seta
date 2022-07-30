import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:seta/responsive/mobile_screen_layout.dart';
import 'package:seta/responsive/responsive_layout_screen.dart';
import 'package:seta/responsive/web_screen_layout.dart';
import 'package:seta/screens/login_screen.dart';
import 'package:seta/utils/colors.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (kIsWeb) {
    await Firebase.initializeApp(
      options: const FirebaseOptions(
        apiKey: 'AIzaSyBhQ9a9qlC6qh3wpbsdO9UfN9tiRlnKNnM',
        appId: '1:391759904308:web:ddda3ed2585a084a125461',
        messagingSenderId: '391759904308',
        projectId: 'seta2022-9aaed',
        storageBucket: "seta2022-9aaed.appspot.com",
      ),
    );
  } else {
    await Firebase.initializeApp();
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'SETA',
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: mobileBackgroundColor,
      ),
      /* home: const ResponsiveLayout(
        mobileScreenLayout: MobileScreenLayout(),
        webScreenLayout: WebScreenLayout(),
      ),*/
      home: LoginScreen(),
    );
  }
}
