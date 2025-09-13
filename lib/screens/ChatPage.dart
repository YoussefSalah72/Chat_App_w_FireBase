import 'package:firebase_demo1/widghts/message_bubble.dart';
import 'package:firebase_demo1/widghts/message_input_field.dart';
import 'package:firebase_demo1/widghts/message_options_sheet.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_demo1/controller/CRUd.dart';
import 'package:firebase_demo1/screens/Home_Screen.dart';

class ChatPage extends StatefulWidget {
  final String chatId;

  const ChatPage({super.key, required this.chatId});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  late final DatabaseService dbService;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    dbService = DatabaseService(widget.chatId);
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black12,
      appBar: AppBar(
        title: Text(
          "Chat - ${widget.chatId}",
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.black12,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const HomeScreen()),
            );
          },
        ),
      ),
      body: Column(
        children: [
          // ✅ الرسائل
          Expanded(
            child: StreamBuilder<DatabaseEvent>(
              stream: dbService.getMessagesStream(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return const Center(child: Text("Error loading messages"));
                }
                if (!snapshot.hasData ||
                    snapshot.data!.snapshot.value == null) {
                  return const Center(child: Text("No messages yet"));
                }

                final raw = snapshot.data!.snapshot.value as Map;
                final List<Map<String, dynamic>> messages = [];
                raw.forEach((k, v) {
                  final m = Map<String, dynamic>.from(v);
                  m["key"] = k;
                  messages.add(m);
                });

                // ✅ ترتيب الرسائل: القديم فوق والجديد تحت
                messages.sort((a, b) =>
                    (a["timestamp"] as int).compareTo(b["timestamp"] as int));

                // ✅ نزول لآخر رسالة بعد ما تتغير الداتا
                _scrollToBottom();

                return ListView.builder(
                  controller: _scrollController,
                  padding: const EdgeInsets.all(8),
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final msg = messages[index];
                    final key = msg["key"] as String;

                    return MessageBubble(
                      msg: msg,
                      isMe: msg["uid"] == dbService.currentUid,
                      onLongPress: () {
                        if (msg["uid"] == dbService.currentUid) {
                          showMessageOptionsSheet(
                            context: context,
                            msg: msg,
                            keyMsg: key,
                            dbService: dbService,
                          );
                        }
                      },
                      onSeen: () {
                        if (msg["uid"] != dbService.currentUid &&
                            msg["status"] != "seen") {
                          dbService.updateMessage(key, {"status": "seen"});
                        }
                      },
                    );
                  },
                );
              },
            ),
          ),

          // ✅ مربع الكتابة
          MessageInputField(
            onSend: (text) {
              dbService.sendMessage(text);
              _scrollToBottom(); // انزل لآخر رسالة بعد الإرسال
            },
          ),
        ],
      ),
    );
  }
}
