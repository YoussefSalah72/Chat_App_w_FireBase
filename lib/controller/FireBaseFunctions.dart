import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_demo1/controller/UserDataController.dart';
import 'package:firebase_demo1/screens/Home_Screen.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

Future<void> creatingUser(BuildContext context) async {
  try {
    UserCredential userCredential = await FirebaseAuth.instance
        .createUserWithEmailAndPassword(
            email: email.text.trim(), password: password.text.trim());

    final uid = userCredential.user?.uid;
    await FirebaseFirestore.instance.collection('users').doc(uid).set({
      'username': userName.text.trim(),
      'birthDate': birthDate.text.trim(),
      'gender': gender.text.trim(),
      'age': age.text.trim(),
      'maritalStatus': maritalStatus.text.trim(),
      'email': email.text.trim(),
      'password': password.text.trim(),
    });

    print("✅ User created with UID: ${userCredential.user?.uid}");
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => HomeScreen()));
  } on FirebaseAuthException catch (e) {
    if (e.code == 'email-already-in-use') {
      return signInUser(context);
    }
    print("❌ FirebaseAuthException: ${e.code} - ${e.message}");
  } catch (e) {
    print("❌ Unknown error: ${e.toString()}");
  }
}

Future<void> signInUser(BuildContext context) async {
  try {
    UserCredential userCredential = await FirebaseAuth.instance
        .signInWithEmailAndPassword(
            email: email.text.trim(), password: password.text.trim());
    print("✅ User signed in UID: ${userCredential.user?.uid}");
    Navigator.of(context)
        .pushReplacement(MaterialPageRoute(builder: (context) => HomeScreen()));
  } on FirebaseAuthException catch (e) {
    print("❌ FirebaseAuthException: ${e.code} - ${e.message}");
  } catch (e) {
    print("❌ Unknown error: ${e.toString()}");
  }
}
///////////////////////////////

class NotificationService {
  // Singleton (اختياري بس بيخلي الكود أنضف)
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  Future<void> saveDeviceToken() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    try {
      // 1️⃣ الحصول على التوكين
      String? token = await FirebaseMessaging.instance.getToken();

      if (token != null) {
        // 2️⃣ تخزين التوكين في Firestore
        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .update({
          'deviceToken': token,
        });
        print(token);
      }

      // 3️⃣ متابعة أي تحديث في التوكين
      FirebaseMessaging.instance.onTokenRefresh.listen((newToken) async {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .update({
          'deviceToken': newToken,
        });
      });
    } catch (e) {
      print("❌ Error saving device token: $e");
    }
  }
}
