import 'package:flutter/material.dart';
import 'package:firebase_demo1/controller/CRUd.dart';
import 'package:firebase_demo1/utils/showEditDialog.dart';

void showMessageOptionsSheet({
  required BuildContext context,
  required Map msg,
  required String keyMsg,
  required DatabaseService dbService,
}) {
  showModalBottomSheet(
    context: context,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
    ),
    builder: (context) {
      return Wrap(
        children: [
          ListTile(
            leading: const Icon(Icons.edit, color: Colors.blue),
            title: const Text("Edit Message"),
            onTap: () {
              Navigator.pop(context);
              showEditDialog(
                context: context,
                oldText: msg["text"] ?? "",
                onSave: (newText) {
                  dbService.updateMessage(keyMsg, {"text": newText});
                },
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.delete, color: Colors.red),
            title: const Text("Delete Message"),
            onTap: () {
              Navigator.pop(context);
              dbService.deleteMessage(keyMsg);
            },
          ),
        ],
      );
    },
  );
}
