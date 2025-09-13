import 'package:firebase_demo1/controller/FireBaseFunctions.dart';
import 'package:firebase_demo1/controller/UserDataController.dart';
import 'package:firebase_demo1/screens/BottomPickerDate.dart';
import 'package:flutter/material.dart';

class Registerscreen extends StatefulWidget {
  const Registerscreen({super.key});

  @override
  State<Registerscreen> createState() => _RegisrescreenState();
}

class _RegisrescreenState extends State<Registerscreen> {
  bool _obscurePassword = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Enter Your Data Information")),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: TextFormField(
                    controller: userName,
                    decoration: InputDecoration(
                      label: Text("Name"),
                      hintText: "Enter your Name",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    )),
              ),
              SizedBox(height: 20),
              TextFormField(
                  controller: age,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    label: Text("Age"),
                    hintText: "Enter your Age",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  )),
              SizedBox(height: 20),
              TextFormField(
                controller: birthDate,
                decoration: InputDecoration(
                  label: Text("Birth Date"),
                  hintText: "Enter your Birth Date",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onTap: () => pickBirthDate(context),
              ),
              SizedBox(height: 20),
              DropdownButtonFormField<String>(
                value: gender.text.isEmpty ? null : gender.text,
                hint: Text("اختر النوع"),
                decoration: InputDecoration(
                  labelText: "النوع",
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.person),
                ),
                items: ['ذكر', 'أنثى'].map((gender) {
                  return DropdownMenuItem<String>(
                    value: gender,
                    child: Text(gender),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    if (value != null) {
                      gender.text =
                          value; // هنا بنخزن القيمة جوه الـ Controller
                    }
                  });
                },
              ),
              SizedBox(height: 20),
              DropdownButtonFormField<String>(
                value: maritalStatus.text.isEmpty ? null : maritalStatus.text,
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
                      maritalStatus.text =
                          value; // هنا بنخزن القيمة جوه الـ Controller
                    }
                  });
                },
              ),
              SizedBox(height: 20),
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
              SizedBox(height: 20),
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
                  await creatingUser(context);
                },
                child: const Text("Login"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
