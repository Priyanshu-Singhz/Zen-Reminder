// lib/main.dart

import 'package:flutter/material.dart';
import 'package:timezone/data/latest_10y.dart';
import 'package:zenreminder/services/notification_service.dart';
import 'package:zenreminder/view/screens/login_screen.dart';
import 'package:zenreminder/view/screens/reminder_screen.dart';
import 'package:zenreminder/view/screens/signup_screen.dart';
import 'package:zenreminder/view/screens/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await LocalNotifications.init();
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
