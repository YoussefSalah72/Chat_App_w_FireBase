import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ForgotPasswordScreen extends StatefulWidget {
  @override
  _ForgotPasswordScreenState createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final TextEditingController _emailController = TextEditingController();

  Future<void> resetPassword() async {
    try {
      await FirebaseAuth.instance
          .sendPasswordResetEmail(email: _emailController.text.trim());
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("تم إرسال رابط إعادة تعيين كلمة السر")),
      );
      Navigator.pop(context); // يرجع للشاشة السابقة
    } catch (e) {
      print("Error: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("فشل في إرسال الإيميل. تأكد من صحة الإيميل.")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("نسيت كلمة السر")),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            Text("أدخل بريدك الإلكتروني لإعادة تعيين كلمة السر"),
            SizedBox(height: 20),
            TextField(
              controller: _emailController,
              decoration: InputDecoration(labelText: "البريد الإلكتروني"),
              keyboardType: TextInputType.emailAddress,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: resetPassword,
              child: Text("إرسال"),
            ),
          ],
        ),
      ),
    );
  }
}
