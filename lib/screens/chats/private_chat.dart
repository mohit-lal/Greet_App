import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;

import 'package:flutter/material.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:greet_app/controllers/privatechat_controller.dart';
import 'package:greet_app/controllers/profile_controller.dart';
import 'package:greet_app/models/Profile.dart';
import 'package:greet_app/services/socket_api.dart';
import 'package:pusher_channels_flutter/pusher_channels_flutter.dart';
import 'package:socket_io_client/socket_io_client.dart';

class PrivateChatScreen extends StatefulWidget {
  const PrivateChatScreen({super.key});

  @override
  State<PrivateChatScreen> createState() => _PrivateChatScreenState();
}

class _PrivateChatScreenState extends State<PrivateChatScreen> {
  final parameters = Get.parameters;
  final PrivatechatController privatechatController =
      Get.find<PrivatechatController>();

  final ProfileController profileController = Get.find<ProfileController>();
  List<types.Message> messages = [];
  var timer;
  Socket socket = SocketApi().getInstance();

  @override
  void initState() {
    super.initState();
    timer = Timer(Duration(seconds: 0), () async {
      await privatechatController.fetchChat(int.parse(parameters["id"]!));
    });

    socket.on("sendMessage", (message) {
      var data = jsonDecode(jsonEncode(message));

      final textMessage = types.TextMessage(
        author: types.User(id: data["sender"].toString()),
        createdAt: DateTime.parse(data["created_at"]).millisecondsSinceEpoch,
        id: data["id"].toString(),
        text: data["message"],
      );

      if (privatechatController.user.value.id != data["receiver"] &&
          privatechatController.user.value.id == data["sender"]) {
        setState(() {
          messages.insert(0, textMessage);
        });
      }
    });

    setState(() {
      messages = privatechatController.messages;
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        appBar: AppBar(
          elevation: 0,
          titleSpacing: 0,
          title: ListTile(
            textColor: Colors.white,
            title: Text(
              privatechatController.user.value.username ?? "",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            subtitle: Text("Click to view profile"),
            contentPadding: EdgeInsets.all(0),
            leading: CircleAvatar(
              backgroundColor: Colors.primaries[
                  Random(privatechatController.user.value.id)
                      .nextInt(Colors.primaries.length)],
              foregroundImage: privatechatController.user.value.avatar != null
                  ? NetworkImage(privatechatController.user.value.avatar!)
                  : null,
            ),
            onTap: () {
              Get.toNamed("/profile", parameters: {
                "username": privatechatController.user.value.username!
              });
            },
          ),
        ),
        body: privatechatController.isChatLoading.value
            ? Center(
                child: CircularProgressIndicator(),
              )
            : Chat(
                theme: const DefaultChatTheme(
                  inputBackgroundColor: Colors.black12,
                  inputTextColor: Colors.black,
                  inputBorderRadius: BorderRadius.all(Radius.circular(50)),
                ),
                messages: messages,
                onSendPressed: (message) => _handleSendPressed(message),
                onTextChanged: (message) => _handleTextChanged(message),
                onEndReached: () {
                  return Future.value();
                },
                user:
                    types.User(id: profileController.user.value.id.toString()),
              ),
      ),
    );
  }

  void _handleSendPressed(types.PartialText message) {
    final textMessage = types.TextMessage(
      author: types.User(id: profileController.user.value.id.toString()),
      createdAt: DateTime.now().millisecondsSinceEpoch,
      id: randomString(),
      text: message.text,
    );
    setState(() {
      messages.insert(0, textMessage);
    });
    privatechatController.sendChat(message.text);
  }

  String randomString() {
    final random = Random.secure();
    final values = List<int>.generate(16, (i) => random.nextInt(255));
    return base64UrlEncode(values);
  }

  _handleTextChanged(String message) {
    socket.emit("sendMessage", {
      "sender": profileController.user.value.id.toString(),
      "receiver": privatechatController.user.value.id.toString(),
      "message": message,
      "created_at": DateTime.now().toString(),
    });
  }
}
