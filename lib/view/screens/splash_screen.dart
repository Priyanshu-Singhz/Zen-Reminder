// lib/view/splash_screen.dart

import 'package:flutter/material.dart';
import 'package:zenreminder/controllers/authentication_controller.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final AuthenticationController _authController = AuthenticationController();

  @override
  void initState() {
    super.initState();
    _initSplashScreen();
  }

  Future<void> _initSplashScreen() async {
    // Simulate some initialization process (e.g., checking authentication)
    await Future.delayed(Duration(seconds: 2)); // Simulating 2 seconds delay
    _redirectToNextScreen();
  }

  void _redirectToNextScreen() {
    _authController.checkUserAuthentication().then((isAuthenticated) {
      if (isAuthenticated) {
        Navigator.pushReplacementNamed(context, '/main');
      } else {
        Navigator.pushReplacementNamed(context, '/login');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.grey[900]!, Colors.black],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Add your splash screen UI elements here
              Image.asset(
                'assets/logo.png', // Provide your logo image path
                height: 250,
                width: 250,
              ),
              SizedBox(height: 20),
              CircularProgressIndicator(), // Add a loading indicator
            ],
          ),
        ),
      ),
    );
  }
}
