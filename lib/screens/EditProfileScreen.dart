import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_demo1/controller/UserDataController.dart';
import 'package:firebase_demo1/screens/BottomPickerDate.dart';
import 'package:flutter/material.dart';

class EditProfileScreen extends StatefulWidget {
  final Map<String, dynamic> currentUserData;

  const EditProfileScreen({super.key, required this.currentUserData});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController nameController;
  late TextEditingController ageController;
  late TextEditingController birthdatecontroller;
  late TextEditingController genderController;
  late TextEditingController maritalStatusController;

  @override
  void initState() {
    super.initState();
    // نملأ الـ Controllers بالبيانات الحالية عشان نعدل عليها
    nameController =
        TextEditingController(text: widget.currentUserData['username']);
    ageController = TextEditingController(text: widget.currentUserData['age']);
    birthdatecontroller =
        TextEditingController(text: widget.currentUserData['birthDate']);
    genderController =
        TextEditingController(text: widget.currentUserData['gender']);
    maritalStatusController =
        TextEditingController(text: widget.currentUserData['maritalStatus']);
  }

  Future<void> updateUserData() async {
    final currentUser = FirebaseAuth.instance.currentUser;

    if (currentUser != null) {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(currentUser.uid)
          .update({
        'username': nameController.text.trim(),
        'age': ageController.text.trim(),
        'birthDate': birthdatecontroller.text.trim(),
        'gender': genderController.text.trim(),
        'maritalStatus': maritalStatusController.text.trim(),
      });

      Navigator.pop(context, true); // نرجع للبروفايل بعد التحديث
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("تعديل الملف الشخصي")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: nameController,
                decoration: const InputDecoration(labelText: "الاسم"),
              ),
              const SizedBox(height: 20),
              TextFormField(
                  controller: ageController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    label: Text("Age"),
                    hintText: "Enter your Age",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  )),
              const SizedBox(height: 20),
              TextFormField(
                controller: birthdatecontroller,
                decoration: InputDecoration(
                  label: Text("Birth Date"),
                  hintText: "Enter your Birth Date",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onTap: () => pickBirthDate(context),
              ),
              const SizedBox(height: 20),
              DropdownButtonFormField<String>(
                value: maritalStatusController.text.isEmpty
                    ? null
                    : maritalStatusController.text,
                hint: Text("اختر الحالة الاجتماعية"),
                decoration: InputDecoration(
                  labelText: "الحالة الاجتماعية",
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.family_restroom),
                ),
                items: ['مطلقة', 'مطلق', 'اعزب', 'متزوج'].map((gender) {
                  return DropdownMenuItem<String>(
                    value: gender,
                    child: Text(gender),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    if (value != null) {
                      maritalStatusController.text =
                          value; // هنا بنخزن القيمة جوه الـ Controller
                    }
                  });
                },
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: email,
                decoration: InputDecoration(
                  label: Text("Email"),
                  hintText: "Enter your email",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: updateUserData,
                child: const Text("حفظ التعديلات"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
