import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:greet_app/models/ChatList.dart';
import 'package:greet_app/models/Profile.dart';
import 'package:greet_app/services/socket_api.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:pusher_channels_flutter/pusher_channels_flutter.dart';
import 'package:socket_io_client/socket_io_client.dart';

class PrivatechatController extends GetxController {
  final storage = GetStorage();
  final chatList = <ChatList>[].obs;
  final unreadCount = 0.obs;
  final messages = <types.Message>[].obs;
  final user = Profile().obs;
  final isLoading = false.obs;
  final isChatLoading = false.obs;
  Socket socket = SocketApi().getInstance();

  @override
  void onInit() {
    super.onInit();
    fetchChatList();
    var currentUser = storage.read("user");
    socket.emit("login", currentUser['id']);

    socket.on("sendMessage", (data) {
      fetchChatList();
    });
  }

  Future fetchChatList() async {
    isLoading.value = true;
    try {
      final response = await http.get(
        Uri.parse('${dotenv.env['API_URL']}/chatlist'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer ${storage.read("token")}',
        },
      );

      if (response.statusCode == 200) {
        List<ChatList> getChats = List<ChatList>.from(
            jsonDecode(response.body).map((x) => ChatList.fromJson(x)));
        chatList.value = getChats;
        unreadCount.value = getChats
            .where((x) => x.seenAt == null && x.senderId != x.receiverId)
            .length;
        update();
      } else {
        // If the server did not return a 200 OK response,
        // then throw an exception.
        Get.snackbar(
          "Error",
          "Failed to load chats.",
          icon: Icon(
            Icons.error,
            color: Colors.white,
          ),
          colorText: Colors.white,
          backgroundColor: Colors.red,
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } on Exception {
      Get.snackbar(
        "Error",
        "Could not connect to server.",
        icon: Icon(
          Icons.error,
          color: Colors.white,
        ),
        colorText: Colors.white,
        backgroundColor: Colors.red,
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future iceBreaker() async {
    isLoading.value = true;
    try {
      final response = await http.get(
        Uri.parse('${dotenv.env['API_URL']}/icebreaker'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer ${storage.read("token")}',
        },
      );

      if (response.statusCode == 200) {
        final chatUser = jsonDecode(response.body);
        user.value = Profile.fromJson(chatUser);
      } else {
        // If the server did not return a 200 OK response,
        // then throw an exception.
        Get.snackbar(
          "Error",
          "Something went wrong!",
          icon: Icon(
            Icons.error,
            color: Colors.white,
          ),
          colorText: Colors.white,
          backgroundColor: Colors.red,
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } on Exception {
      Get.snackbar(
        "Error",
        "Could not connect to server.",
        icon: Icon(
          Icons.error,
          color: Colors.white,
        ),
        colorText: Colors.white,
        backgroundColor: Colors.red,
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future fetchChat(int id) async {
    isChatLoading.value = true;
    try {
      final response = await http.get(
        Uri.parse('${dotenv.env['API_URL']}/chat?user_id=${id.toString()}'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer ${storage.read("token")}',
        },
      );

      if (response.statusCode == 200) {
        final chats = jsonDecode(response.body)["chats"]["data"];
        final chatUser = jsonDecode(response.body)["user"];
        final author = jsonDecode(response.body)["author"];
        user.value = Profile.fromJson(chatUser);
        messages.value = chats.toList().length != 0
            ? List<types.Message>.from(chats.map((x) {
                return types.TextMessage(
                  author: types.User(id: x["sender"].toString()),
                  createdAt:
                      DateTime.parse(x["created_at"]).millisecondsSinceEpoch,
                  id: x["id"].toString(),
                  text: x["message"],
                );
              }))
            : [];
      } else {
        // If the server did not return a 200 OK response,
        // then throw an exception.
        Get.snackbar(
          "Error",
          jsonDecode(response.body)["message"],
          icon: Icon(
            Icons.error,
            color: Colors.white,
          ),
          colorText: Colors.white,
          backgroundColor: Colors.red,
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } on PlatformException catch (e) {
      printError(info: e.toString());
    } on Exception {
      Get.snackbar(
        "Error",
        "Could not connect to server.",
        icon: Icon(
          Icons.error,
          color: Colors.white,
        ),
        colorText: Colors.white,
        backgroundColor: Colors.red,
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isChatLoading.value = false;
    }
  }

  void sendChat(String message) async {
    try {
      isLoading.value = true;
      final response = await http.post(
        Uri.parse('${dotenv.env['API_URL']}/chat'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer ${storage.read("token")}',
        },
        body: jsonEncode(
            <String, dynamic>{'user': user.value.id, 'message': message}),
      );
      if (response.statusCode != 200) {}
    } on Exception {
      Get.snackbar(
        "Error",
        "Could not connect to server.",
        icon: Icon(
          Icons.error,
          color: Colors.white,
        ),
        colorText: Colors.white,
        backgroundColor: Colors.red,
      );
    } finally {
      isLoading.value = false;
    }
  }
}
