import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:timezone/data/latest_10y.dart';
import 'package:zenreminder/firebase_options.dart';
import 'package:zenreminder/services/notification_service.dart';
import 'package:zenreminder/view/screens/login_screen.dart';
import 'package:zenreminder/view/screens/reminder_screen.dart';
import 'package:zenreminder/view/screens/signup_screen.dart';
import 'package:zenreminder/view/screens/splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';

import 'constants.dart'; // Importing the constants.dart file

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  // Initialize timezone package
  initializeTimeZones();

  // Other initialization code
  // Initialize Google Sign-In
  GoogleSignIn googleSignIn = GoogleSignIn();

  runApp(MyApp(googleSignIn: googleSignIn));
}

class MyApp extends StatelessWidget {
  final GoogleSignIn googleSignIn;

  MyApp({required this.googleSignIn});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => SplashScreen(),
        '/login': (context) => LoginScreen(),
        '/signup': (context) => SignUpScreen(),
        '/main': (context) => MainScreen(username: 'Human'),
      },
      theme: ThemeData(
        colorScheme: ColorScheme.light(
          primary: AppColors.lightPrimaryColor,
          secondary: AppColors.lightAccentColor,
        ),
        scaffoldBackgroundColor: AppColors.lightBackgroundColor,
        textTheme: TextTheme(
          bodyText1: TextStyle(color: AppColors.lightTextColor),
          bodyText2: TextStyle(color: AppColors.lightTextColor),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all<Color>(AppColors.lightButtonColor),
          ),
        ),
      ),
      darkTheme: ThemeData(
        colorScheme: ColorScheme.dark(
          primary: AppColors.darkPrimaryColor,
          secondary: AppColors.darkAccentColor,
        ),
        scaffoldBackgroundColor: AppColors.darkBackgroundColor,
        textTheme: TextTheme(
          bodyText1: TextStyle(color: AppColors.darkTextColor),
          bodyText2: TextStyle(color: AppColors.darkTextColor),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all<Color>(AppColors.darkButtonColor),
          ),
        ),
      ),
      themeMode: ThemeMode.system, // Theme as per system's light or dark mode
    );
  }
}
