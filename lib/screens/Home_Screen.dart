import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_demo1/controller/FireBaseFunctions.dart';
import 'package:firebase_demo1/screens/UserProfileScreen.dart';
import 'package:firebase_demo1/screens/auth_screen.dart';
import 'package:firebase_demo1/utils/editScreenBottom.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Future<String> getUserName() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid != null) {
      final doc =
          await FirebaseFirestore.instance.collection('users').doc(uid).get();
      return doc.data()?['username'] ?? 'User';
    } else {
      return 'User';
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    NotificationService().saveDeviceToken();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          leading: Padding(
            padding: const EdgeInsets.all(8.0),
            child: EditProfileButton(),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.logout),
              onPressed: () async {
                await FirebaseAuth.instance.signOut();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => AuthScreen()),
                );
              },
            )
          ],
          title: FutureBuilder(
            future: getUserName(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Text('حدث خطأ: ${snapshot.error}');
              } else {
                final username = snapshot.data ?? 'User';
                return Text(
                  " Welcome '$username'",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                );
              }
            },
          )),
      body: UserProfileScreen(),
    );
  }
}
