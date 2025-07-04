import 'dart:convert';

import 'package:chalosaath/features/authorization/data/user_model.dart';
import 'package:chalosaath/features/chat/data/Message.dart';
import 'package:chalosaath/features/helper/CustomScaffoldScreen.dart';
import 'package:chalosaath/features/loader/CustomLoader.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/storage/app_key.dart';
import '../../../core/storage/app_preferences.dart';
import '../../../services/service_locator.dart';
import '../data/ChatEvent.dart';
import '../data/ChatState.dart';
import 'ChatBloc.dart';

class ChatScreen extends StatefulWidget {
  final UserModel args;
  final ChatBloc chatBloc;

  const ChatScreen({super.key, required this.args, required this.chatBloc});

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  UserModel? loggedInUser;
  String chatId = "";
  final TextEditingController _controller = TextEditingController();
  bool isLoading = false;
  List<Message> messages = [];

  @override
  void initState() {
    super.initState();
    final userJson = getX<AppPreference>().getString(AppKey.userData);
    final map = jsonDecode(userJson);
    loggedInUser = UserModel.fromMap(map);
    widget.chatBloc.add(GetChatID(loggedInUser!.email, widget.args.email));
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => widget.chatBloc,
      child: BlocListener<ChatBloc, ChatState>(
        listener: (context, state) async {
          if (state is ChatLoading) {
            setState(() {
              isLoading = true;
            });
          } else if (state is ChatIdSucces) {
            setState(() {
              isLoading = false;
              chatId = state.message;
            });
            widget.chatBloc.add(LoadMessages(chatId));
          } else if (state is ChatLoaded) {
            setState(() {
              isLoading = false;
              messages = state.messages;
            });
          } else if (state is ChatError) {
            setState(() {
              isLoading = false;
            });
          }
        },
        child: buildUI(),
      ),
    );
  }

  void _send() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;
    widget.chatBloc.add(SendMessageEvent(chatId, loggedInUser!.email, text));
    _controller.clear();


  }

  @override
  void dispose() {
    widget.chatBloc.close();
    super.dispose();
  }

  buildUI() {
    return CustomScaffoldScreen(
      backpress: true,
      profile: true,
      body: Stack(
        children: [
          Column(
            children: [
              Expanded(
                child: ListView.builder(
                  reverse: true,
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final message = messages[messages.length - 1 - index];
                    final isMe = message.senderId == loggedInUser?.email;
                    return Align(
                      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                        decoration: BoxDecoration(
                          color: isMe ? Colors.blue : Colors.grey[300],
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          message.text,
                          style: TextStyle(color: isMe ? Colors.white : Colors.black),
                        ),
                      ),
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _controller,
                        decoration: const InputDecoration(hintText: "Enter message..."),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.send),
                      onPressed: _send,
                    )
                  ],
                ),
              ),
              SizedBox(height: 40,),
            ],
          ),

          isLoading ? CustomLoader() :Container()
        ],
      ),
    );
  }
}
