import 'package:flutter/material.dart';

class MessageBubble extends StatelessWidget {
  final Map msg;
  final bool isMe;
  final VoidCallback onLongPress;
  final VoidCallback onSeen;

  const MessageBubble({
    super.key,
    required this.msg,
    required this.isMe,
    required this.onLongPress,
    required this.onSeen,
  });

  Widget _buildStatusIcon(String? status) {
    if (status == "sent") {
      return const Icon(Icons.check, size: 16, color: Colors.grey);
    } else if (status == "delivered") {
      return const Icon(Icons.done_all, size: 16, color: Colors.grey);
    } else if (status == "seen") {
      return const Icon(Icons.done_all, size: 16, color: Colors.blue);
    } else {
      return const SizedBox.shrink();
    }
  }

  @override
  Widget build(BuildContext context) {
    // لو مش أنا اللي باعت الرسالة → اعمل onSeen
    if (!isMe && msg["status"] != "seen") {
      onSeen();
    }

    return GestureDetector(
      onLongPress: onLongPress,
      child: Align(
        alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: isMe ? Colors.green[400] : Colors.grey[300],
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            crossAxisAlignment:
                isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
            children: [
              Text(
                msg["text"] ?? "",
                style: TextStyle(
                  color: isMe ? Colors.white : Colors.black,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                "From: ${msg["sender"] ?? ""}",
                style: TextStyle(
                  color: isMe ? Colors.white70 : Colors.black54,
                  fontSize: 12,
                ),
              ),

              // ✅ حالة الرسالة (تظهر بس لو أنا المرسل)
              if (isMe)
                Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: _buildStatusIcon(msg["status"] as String?),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
