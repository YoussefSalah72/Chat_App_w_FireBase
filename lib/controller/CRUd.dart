import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  final String chatId;
  late final DatabaseReference _dbRef;
  final String? currentUid = FirebaseAuth.instance.currentUser?.uid;

  DatabaseService(this.chatId) {
    _dbRef = FirebaseDatabase.instance
        .ref()
        .child("chats")
        .child(chatId)
        .child("messages");
  }

  // Create

  Future<void> sendMessage(String text) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    // اسم المستخدم من Firestore
    String username = "Unknown";
    final userDoc = await FirebaseFirestore.instance
        .collection("users")
        .doc(user.uid)
        .get();

    if (userDoc.exists && userDoc.data()!.containsKey("username")) {
      username = userDoc["username"];
    }

    final message = {
      "uid": user.uid,
      "sender": username,
      "text": text,
      "timestamp": ServerValue.timestamp,
      "status": "sent", // ✅ الحالة الأولية
    };

    await _dbRef.push().set(message);
  }

  // Read
  Stream<DatabaseEvent> getMessagesStream() {
    return _dbRef.orderByChild("timestamp").onValue;
  }

  // Update
  Future<void> updateMessage(String key, Map<String, dynamic> updates) async {
    await _dbRef.child(key).update(updates);
  }

  // Delete
  Future<void> deleteMessage(String key) async {
    await _dbRef.child(key).remove();
  }
}
