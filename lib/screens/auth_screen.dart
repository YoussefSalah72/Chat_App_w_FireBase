import 'package:firebase_demo1/controller/FireBaseFunctions.dart';
import 'package:firebase_demo1/controller/UserDataController.dart';
import 'package:firebase_demo1/screens/ForgetPasswordScreen.dart';
import 'package:firebase_demo1/screens/RegisterScreen.dart';
import 'package:flutter/material.dart';

class AuthScreen extends StatefulWidget {
  AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  bool _obscurePassword = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("سجل بالايميل بتاعك يا مجهول ")),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
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
                SizedBox(
                  height: 20,
                ),
                TextFormField(
                  controller: password,
                  obscureText: _obscurePassword,
                  decoration: InputDecoration(
                    label: Text("Password"),
                    hintText: "Enter your Password",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(_obscurePassword
                          ? Icons.remove_red_eye
                          : Icons.visibility_off),
                      onPressed: () {
                        setState(() {
                          _obscurePassword = !_obscurePassword;
                        });
                      },
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                  onPressed: () async {
                    await signInUser(context);
                  },
                  child: const Text("Login"),
                ),
                SizedBox(
                  height: 40,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ForgotPasswordScreen()),
                        );
                      },
                      child: Text("نسيت كلمة السر؟",
                          style: TextStyle(
                              color: Colors.red,
                              fontSize: 20,
                              fontWeight: FontWeight.bold)),
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Registerscreen()),
                        );
                      },
                      child: Text("انشاء حساب جديد",
                          style: TextStyle(
                              color: Colors.blue,
                              fontSize: 20,
                              fontWeight: FontWeight.bold)),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
