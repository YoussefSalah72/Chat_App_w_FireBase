import 'package:flutter/material.dart';

Future<void> showEditDialog({
  required BuildContext context,
  required String oldText,
  required Function(String newText) onSave,
}) async {
  final TextEditingController editController =
      TextEditingController(text: oldText);

  return showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text("Edit Message"),
        content: TextField(
          controller: editController,
          decoration: const InputDecoration(
            hintText: "Enter new message...",
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () {
              if (editController.text.trim().isNotEmpty) {
                onSave(editController.text.trim());
              }
              Navigator.pop(context);
            },
            child: const Text("Save"),
          ),
        ],
      );
    },
  );
}
