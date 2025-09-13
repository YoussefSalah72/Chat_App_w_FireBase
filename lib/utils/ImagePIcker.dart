import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ImagePickerPage extends StatefulWidget {
  const ImagePickerPage({super.key});

  @override
  State<ImagePickerPage> createState() => _ImagePickerPageState();
}

class _ImagePickerPageState extends State<ImagePickerPage> {
  File? _image;
  final picker = ImagePicker();

  Future pickImage(ImageSource source) async {
    final pickedFile = await picker.pickImage(source: source);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  Future saveImagePathToFirestore() async {
    if (_image == null) return;

    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) return;

    final imagePath = _image!.path;

    // خزّن المسار في Firestore
    await FirebaseFirestore.instance
        .collection("users")
        .doc(currentUser.uid)
        .update({"profileImagePath": imagePath});

    // ارجع المسار للصفحة اللي استدعتني
    Navigator.pop(context, imagePath);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("اختر صورة")),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: _image == null
                ? const Icon(Icons.person, size: 100)
                : Image.file(_image!, height: 200),
          ),
          const SizedBox(height: 20),
          ElevatedButton.icon(
            icon: const Icon(Icons.photo),
            label: const Text("من المعرض"),
            onPressed: () => pickImage(ImageSource.gallery),
          ),
          ElevatedButton.icon(
            icon: const Icon(Icons.camera_alt),
            label: const Text("من الكاميرا"),
            onPressed: () => pickImage(ImageSource.camera),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: saveImagePathToFirestore,
            child: const Text("تأكيد الاختيار"),
          ),
        ],
      ),
    );
  }
}
