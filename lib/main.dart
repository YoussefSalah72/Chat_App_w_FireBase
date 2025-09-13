import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_demo1/controller/notification_service.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:firebase_demo1/screens/Home_Screen.dart';
import 'package:firebase_demo1/screens/auth_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  /// ✅ لازم نربط الهاندلر بالـ Messaging
  FirebaseMessaging.onBackgroundMessage(
    NotificationServiceFb.firebaseMessagingBackgroundHandler,
  );

  /// ✅ تهيئة خدمة الإشعارات
  await NotificationServiceFb.init();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'firebase demo',
      home: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasData) {
            return const HomeScreen();
          } else {
            return AuthScreen();
          }
        },
      ),
    );
  }
}
