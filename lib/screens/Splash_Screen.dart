import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'Home_Screen.dart';
import 'auth_screen.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;
    Future.delayed(Duration(seconds: 3), () {
      if (user != null) {
        return Navigator.push(
            context, MaterialPageRoute(builder: (context) => HomeScreen()));
      } else {
        return Navigator.push(
            context, MaterialPageRoute(builder: (context) => AuthScreen()));
      }
    });

    return const Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "خش برجلك اليمين يا حبيب اخوك ",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 20,
            ),
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
            ),
          ],
        ),
      ),
    );
  }
}
