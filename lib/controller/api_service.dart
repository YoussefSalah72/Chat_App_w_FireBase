import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl =
      "https://console.firebase.google.com/project/fir-demo-65cfb/usage/details"; // غير ده بـ project-id بتاعك

  static Future<void> sendNotification({
    required String token,
    required String title,
    required String body,
  }) async {
    final url = Uri.parse("$baseUrl/sendNotification");

    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "token": token,
        "title": title,
        "body": body,
      }),
    );

    if (response.statusCode == 200) {
      print("✅ Notification sent!");
    } else {
      print("❌ Failed: ${response.body}");
    }
  }
}
