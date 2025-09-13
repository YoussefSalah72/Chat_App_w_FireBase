import 'package:firebase_demo1/screens/EditProfileScreen.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class EditProfileButton extends StatelessWidget {
  const EditProfileButton({Key? key}) : super(key: key);

  Future<void> _navigateToEdit(BuildContext context) async {
    final uid = FirebaseAuth.instance.currentUser!.uid;

    final doc =
        await FirebaseFirestore.instance.collection("users").doc(uid).get();

    if (doc.exists) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => EditProfileScreen(
            currentUserData: doc.data()!, // 👈 هيوصل البيانات للصفحة
          ),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("⚠️ لا يوجد بيانات للمستخدم!")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.blue,
        shape: BoxShape.circle,
      ),
      child: IconButton(
        color: Colors.white,
        icon: const Icon(Icons.edit),
        onPressed: () => _navigateToEdit(context),
      ),
    );
  }
}
