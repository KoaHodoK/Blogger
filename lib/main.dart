import 'package:blog_app/screens/option_screen.dart';
import 'package:blog_app/screens/splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        textTheme: const TextTheme(
          headline1: TextStyle(
              fontSize: 26.0,
              fontWeight: FontWeight.bold,
              fontFamily: 'Roboto'),
          headline2: TextStyle(
              fontSize: 22.0,
              fontWeight: FontWeight.w700,
              fontFamily: 'Roboto'),
          headline3: TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.w500,
              fontFamily: 'Roboto'),
          bodyText1: TextStyle(
            fontSize: 16.0,
            fontFamily: 'Raleway',
          ),
          bodyText2: TextStyle(
            fontSize: 14.0,
            fontFamily: 'Raleway',
          ),
        ),
      ),
      home: const SplashScreen(),
    );
  }
}
