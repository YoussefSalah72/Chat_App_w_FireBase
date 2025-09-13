import 'package:flutter/material.dart';

class MessageInputField extends StatefulWidget {
  final Function(String) onSend;

  const MessageInputField({super.key, required this.onSend});

  @override
  State<MessageInputField> createState() => _MessageInputFieldState();
}

class _MessageInputFieldState extends State<MessageInputField> {
  final TextEditingController _controller = TextEditingController();

  void _send() {
    if (_controller.text.trim().isNotEmpty) {
      widget.onSend(_controller.text.trim());
      _controller.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 8, right: 8, bottom: 8),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _controller,
              decoration: const InputDecoration(
                contentPadding: EdgeInsets.all(8.0),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  borderSide: BorderSide(color: Colors.green),
                ),
                hintText: "Type your message...",
                fillColor: Colors.white,
                filled: true,
              ),
              onSubmitted: (_) => _send(),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.send, color: Colors.green),
            onPressed: _send,
          ),
        ],
      ),
    );
  }
}
