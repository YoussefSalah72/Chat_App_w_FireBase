import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_demo1/controller/api_service.dart';
import 'package:firebase_demo1/screens/ChatPage.dart';
import 'package:firebase_demo1/utils/ImagePIcker.dart';
import 'package:flutter/material.dart';

class UserProfileScreen extends StatefulWidget {
  const UserProfileScreen({super.key});

  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  File? _selectedImage;

  Future<void> chooseImage(String uid) async {
    final image = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const ImagePickerPage()),
    );

    if (image != null && mounted) {
      // هنا image عبارة عن String (المسار) مش File
      setState(() {
        _selectedImage = File(image);
      });

      await FirebaseFirestore.instance.collection("users").doc(uid).update({
        "profileImagePath": image, // نحفظ المسار مباشرة كـ String
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = FirebaseAuth.instance.currentUser;

    if (currentUser == null) {
      return const Scaffold(
        body: Center(
          child: Text("❌ لم يتم تسجيل الدخول"),
        ),
      );
    }

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: StreamBuilder<DocumentSnapshot>(
          stream: FirebaseFirestore.instance
              .collection('users')
              .doc(currentUser.uid)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (!snapshot.hasData || !snapshot.data!.exists) {
              return const Center(
                child: Text("❌ لم يتم العثور على بيانات المستخدم."),
              );
            }

            final userData = snapshot.data!.data() as Map<String, dynamic>;

            final String? profileImagePath =
                userData['profileImagePath'] as String?;

            final bool hasValidImage = profileImagePath != null &&
                profileImagePath.isNotEmpty &&
                File(profileImagePath).existsSync();

            return SingleChildScrollView(
              child: Column(
                children: [
                  // صورة المستخدم
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 60,
                        backgroundImage: hasValidImage
                            ? FileImage(File(profileImagePath))
                            : null,
                        child: !hasValidImage
                            ? const Icon(Icons.person, size: 60)
                            : null,
                      ),
                      const SizedBox(width: 20),
                      Column(
                        children: [
                          ElevatedButton(
                            onPressed: () => chooseImage(currentUser.uid),
                            child: const Text("اختيار صورة"),
                          ),
                          const SizedBox(height: 20),
                          ElevatedButton(
                            onPressed: () => Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ChatPage(
                                          chatId: 'general',
                                        ))),
                            child: const Text("الدردشة"),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              ApiService.sendNotification(
                                token:
                                    "<device-token>", // هنا حط التوكين اللي معاك من Firestore
                                title: "Hello",
                                body: "This is a test notification",
                              );
                            },
                            child: Text("Send Notification"),
                          )
                        ],
                      )
                    ],
                  ),
                  const SizedBox(height: 16),

                  // بيانات المستخدم
                  buildInfoTile("الاسم", userData['username'] ?? 'غير متوفر'),
                  buildInfoTile(
                      "تاريخ الميلاد", userData['birthDate'] ?? 'غير متوفر'),
                  buildInfoTile("النوع", userData['gender'] ?? 'غير متوفر'),
                  buildInfoTile(
                      "السن", userData['age']?.toString() ?? 'غير متوفر'),
                  buildInfoTile("الحالة الاجتماعية",
                      userData['maritalStatus'] ?? 'غير متوفر'),
                  buildInfoTile(
                      "البريد الإلكتروني", userData['email'] ?? 'غير متوفر'),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget buildInfoTile(String title, String value) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        leading: const Icon(Icons.info_outline),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(value),
      ),
    );
  }
}
