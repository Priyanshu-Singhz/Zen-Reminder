import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:zenreminder/constants.dart';
import 'package:zenreminder/services/firebase_services.dart';
import 'package:zenreminder/view/screens/reminder_screen.dart';
import 'package:zenreminder/view/screens/signup_screen.dart';
import 'package:zenreminder/view/widgets/global.dart';


class LoginScreen extends StatelessWidget {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final FirebaseService _firebaseService = FirebaseService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Theme.of(context).brightness == Brightness.dark
                  ? AppColors.darkBackgroundColor
                  : AppColors.lightBackgroundColor,
              Theme.of(context).brightness == Brightness.dark
                  ? AppColors.darkBackgroundColor
                  : AppColors.lightBackgroundColor,
            ],
          ),
        ),
        child: Padding(
          padding: EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Welcome back!',
                style: TextStyle(
                  fontFamily: 'Montserrat',
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).brightness == Brightness.dark
                      ? AppColors.darkTextColor
                      : AppColors.lightTextColor,
                ),
              ),
              SizedBox(height: 20.0),
              TextField(
                controller: _emailController,
                style: TextStyle(
                  color: Theme.of(context).brightness == Brightness.dark
                      ? AppColors.darkTextColor
                      : AppColors.lightTextColor,
                ),
                decoration: InputDecoration(
                  labelText: 'Email',
                  labelStyle: TextStyle(
                    color: Theme.of(context).brightness == Brightness.dark
                        ? AppColors.darkTextColor
                        : AppColors.lightTextColor,
                  ),
                  border: OutlineInputBorder(),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Theme.of(context).brightness == Brightness.dark
                          ? AppColors.darkTextColor
                          : AppColors.lightTextColor,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 10.0),
              TextField(
                controller: _passwordController,
                style: TextStyle(
                  color: Theme.of(context).brightness == Brightness.dark
                      ? AppColors.darkTextColor
                      : AppColors.lightTextColor,
                ),
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Password',
                  labelStyle: TextStyle(
                    color: Theme.of(context).brightness == Brightness.dark
                        ? AppColors.darkTextColor
                        : AppColors.lightTextColor,
                  ),
                  border: OutlineInputBorder(),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Theme.of(context).brightness == Brightness.dark
                          ? AppColors.darkTextColor
                          : AppColors.lightTextColor,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20.0),
              ElevatedButton(
                onPressed: () {
                  _login(context);
                },
                child: Text('Login'),
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Theme.of(context).brightness == Brightness.dark
                      ? AppColors.darkButtonColor
                      : AppColors.lightButtonColor,
                  padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              SizedBox(height: 10.0),
              GoogleSignInButton(
  text: 'Sign in with Google',
  onPressed: () {
    _loginWithGoogle(context);
  },
),

              SizedBox(height: 10.0),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SignUpScreen()),
                  );
                },
                child: Text(
                  'Don\'t have an account? Sign up',
                  style: TextStyle(
                    fontFamily: 'Montserrat',
                    color: Theme.of(context).brightness == Brightness.dark
                        ? AppColors.darkTextColor
                        : AppColors.lightTextColor,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _login(BuildContext context) async {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    if (email.isNotEmpty && password.isNotEmpty) {
      User? user = await _firebaseService.signInWithEmailAndPassword(email, password);
      if (user != null) {
        // If login is successful, redirect to main screen with username
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => MainScreen(username: user.displayName ?? '')),
        );
      } else {
        // Show Snackbar if user not found
        _showSnackbar(context, 'User not found, please register');
      }
    } else {
      // Show Snackbar for missing fields
      _showSnackbar(context, 'Please fill in all details');
    }
  }

  void _loginWithGoogle(BuildContext context) async {
    User? user = await _firebaseService.signInWithGoogle();
    if (user != null) {
      // If login with Google is successful, redirect to main screen with username
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => MainScreen(username: user.displayName ?? '')),
      );
    } else {
      // Show Snackbar if login with Google failed
      _showSnackbar(context, 'Failed to sign in with Google');
    }
  }

  void _showSnackbar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }
}
