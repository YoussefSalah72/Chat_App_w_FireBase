import 'package:firebase_demo1/controller/UserDataController.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

Future<void> pickBirthDate(BuildContext context) async {
  DateTime? pickedDate = await showDatePicker(
    context: context,
    initialDate: DateTime(2000),
    firstDate: DateTime(1900),
    lastDate: DateTime.now(),
    helpText: "اختر تاريخ الميلاد",
    cancelText: "إلغاء",
    confirmText: "تم",
    builder: (context, child) {
      return Theme(
        data: ThemeData.light().copyWith(
          primaryColor: Colors.teal,
          colorScheme: const ColorScheme.light(primary: Colors.teal),
          dialogBackgroundColor: Colors.white,
        ),
        child: child!,
      );
    },
  );

  if (pickedDate != null) {
    birthDate.text = DateFormat('yyyy-MM-dd').format(pickedDate);
  }
}
