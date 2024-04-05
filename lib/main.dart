// lib/main.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:minimalist_reminder/view/screens/login_screen.dart';
import 'package:minimalist_reminder/view/screens/reminder_screen.dart';
import 'package:minimalist_reminder/view/screens/signup_screen.dart';
import 'package:minimalist_reminder/view/screens/splash_screen.dart';
import 'package:timezone/data/latest_10y.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize timezone package
  initializeTimeZones();

  // Other initialization code
  
  runApp(MyApp());
}


class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => SplashScreen(),
        '/login': (context) => LoginScreen(),
        '/signup': (context) => SignUpScreen(),
        '/main': (context) => MainScreen(),
      },
    );
  }
}
