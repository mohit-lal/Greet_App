import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:greet_app/models/Chatroom.dart';
import 'package:greet_app/models/ChatroomMessage.dart';
import 'package:greet_app/services/socket_api.dart';
import 'package:http/http.dart' as http;
import 'package:socket_io_client/socket_io_client.dart';

class ChatRoomController extends GetxController {
  final storage = GetStorage();
  final chatRooms = <ChatRoom>[].obs;
  final myChatRooms = <ChatRoom>[].obs;
  final joinedRooms = <ChatRoom>[].obs;
  final isLoading = false.obs;
  final isJoining = false.obs;
  Socket socket = SocketApi().getInstance();
  final chatRoomName = TextEditingController();
  final chatRoomDescription = TextEditingController();
  final messageField = TextEditingController();
  final scrollController = ScrollController();

  @override
  void onInit() {
    super.onInit();
    socket.on("sendChatRoomMessage", (data) {
      var message = jsonDecode(jsonEncode(data));
      var roomIndex =
          joinedRooms.indexWhere((room) => room.id == message["chatroom_id"]);
      roomIndex == -1
          ? null
          : joinedRooms[roomIndex]
              .messages
              ?.add(ChatRoomMessage.fromJson(message));
      joinedRooms.refresh();
      if (scrollController.hasClients) {
        Future.delayed(
          Duration(milliseconds: 200),
          () {
            scrollController.animateTo(
              scrollController.position.maxScrollExtent,
              duration: Duration(milliseconds: 400),
              curve: Curves.ease,
            );
          },
        );
      }
    });

    socket.on("sendGameMessage", (data) {
      var message = jsonDecode(jsonEncode(data));
      var roomIndex = joinedRooms.indexWhere((room) => room.id == 50);
      roomIndex == -1
          ? null
          : joinedRooms[roomIndex]
              .messages
              ?.add(ChatRoomMessage.fromJson(message));
      joinedRooms.refresh();
      if (scrollController.hasClients) {
        Future.delayed(
          Duration(milliseconds: 200),
          () {
            scrollController.animateTo(
              scrollController.position.maxScrollExtent,
              duration: Duration(milliseconds: 400),
              curve: Curves.ease,
            );
          },
        );
      }
    });
  }

  Future fetchChatRooms() async {
    isLoading.value = true;
    try {
      final response = await http.get(
        Uri.parse('${dotenv.env['API_URL']}/chatrooms'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer ${storage.read("token")}',
        },
      );

      if (response.statusCode == 200) {
        List<ChatRoom> getChatRooms = List<ChatRoom>.from(
            jsonDecode(response.body).map((x) => ChatRoom.fromJson(x)));
        chatRooms.value = getChatRooms;
      } else {
        // If the server did not return a 200 OK response,
        // then throw an exception.
        Get.snackbar(
          "Error",
          "Failed to load chatrooms.",
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

  Future fetchMyChatRooms() async {
    isLoading.value = true;
    try {
      final response = await http.get(
        Uri.parse('${dotenv.env['API_URL']}/mychatrooms'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer ${storage.read("token")}',
        },
      );

      if (response.statusCode == 200) {
        List<ChatRoom> getChatRooms = List<ChatRoom>.from(
            jsonDecode(response.body).map((x) => ChatRoom.fromJson(x)));
        myChatRooms.value = getChatRooms;
      } else {
        // If the server did not return a 200 OK response,
        // then throw an exception.
        Get.snackbar(
          "Error",
          "Failed to load chatrooms.",
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

  Future fetchJoinedChatRooms() async {
    isLoading.value = true;
    try {
      final response = await http.get(
        Uri.parse('${dotenv.env['API_URL']}/joinedchatrooms'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer ${storage.read("token")}',
        },
      );

      if (response.statusCode == 200) {
        List<ChatRoom> getChatRooms = List<ChatRoom>.from(
            jsonDecode(response.body).map((x) => ChatRoom.fromJson(x)));
        getChatRooms.forEach((room) {
          var roomIndex =
              joinedRooms.indexWhere((room1) => room1.id == room.id);
          if (roomIndex == -1) {
            joinedRooms.add(room);
          }
        });
      } else {
        // If the server did not return a 200 OK response,
        // then throw an exception.
        Get.snackbar(
          "Error",
          "Failed to load chatrooms.",
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

  Future createChatroom() async {
    isLoading.value = true;
    try {
      if (chatRoomName.text.isEmpty) {
        Get.snackbar(
          "Error",
          "Please enter a name for the chatroom.",
          icon: Icon(
            Icons.error,
            color: Colors.white,
          ),
          colorText: Colors.white,
          backgroundColor: Colors.red,
          snackPosition: SnackPosition.BOTTOM,
        );
      } else {
        final response =
            await http.post(Uri.parse('${dotenv.env['API_URL']}/chatrooms'),
                headers: <String, String>{
                  'Content-Type': 'application/json; charset=UTF-8',
                  'Authorization': 'Bearer ${storage.read("token")}',
                },
                body: jsonEncode(<String, dynamic>{
                  'name': chatRoomName.text,
                  'description': chatRoomDescription.text,
                }));
        if (response.statusCode == 200) {
          Get.snackbar(
            "Success",
            "Chatroom Created",
            backgroundColor: Colors.green,
            colorText: Colors.white,
            icon: Icon(
              Icons.check_circle,
              color: Colors.white,
            ),
            snackPosition: SnackPosition.BOTTOM,
          );
          return true;
        } else {
          // If the server did not return a 200 OK response,
          // then throw an exception.
          Get.snackbar(
            "Error",
            jsonDecode(response.body)['message'],
            icon: Icon(
              Icons.error,
              color: Colors.white,
            ),
            colorText: Colors.white,
            backgroundColor: Colors.red,
            snackPosition: SnackPosition.BOTTOM,
          );
          return false;
        }
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
      chatRoomName.text = "";
      chatRoomDescription.text = "";
    }
    return false;
  }

  Future<bool> deleteChatroom(int id) async {
    isLoading.value = true;
    try {
      final response =
          await http.delete(Uri.parse('${dotenv.env['API_URL']}/chatrooms'),
              headers: <String, String>{
                'Content-Type': 'application/json; charset=UTF-8',
                'Authorization': 'Bearer ${storage.read("token")}',
              },
              body: jsonEncode(<String, dynamic>{
                'chatroom_id': id,
              }));

      if (response.statusCode == 200) {
        var index = joinedRooms.indexWhere((element) => element.id == id);
        if (index != -1) {
          joinedRooms.removeAt(index);
        }
        Get.snackbar(
          "Success",
          jsonDecode(response.body)['message'],
          backgroundColor: Colors.green,
          colorText: Colors.white,
          icon: Icon(
            Icons.check_circle,
            color: Colors.white,
          ),
          snackPosition: SnackPosition.BOTTOM,
        );
        return true;
      } else {
        // If the server did not return a 200 OK response,
        // then throw an exception.
        Get.snackbar(
          "Error",
          jsonDecode(response.body)['message'],
          icon: Icon(
            Icons.error,
            color: Colors.white,
          ),
          colorText: Colors.white,
          backgroundColor: Colors.red,
          snackPosition: SnackPosition.BOTTOM,
        );
        return false;
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
    return false;
  }

  Future<bool> joinChatroom(int id) async {
    isJoining.value = true;
    try {
      final response =
          await http.post(Uri.parse('${dotenv.env['API_URL']}/chatrooms/join'),
              headers: <String, String>{
                'Content-Type': 'application/json; charset=UTF-8',
                'Authorization': 'Bearer ${storage.read("token")}',
              },
              body: jsonEncode(<String, dynamic>{
                'chatroom_id': id,
              }));

      if (response.statusCode == 200) {
        var chatroom = ChatRoom.fromJson(jsonDecode(response.body));
        var roomIndex =
            joinedRooms.indexWhere((element) => element.id == chatroom.id);
        if (roomIndex == -1) {
          joinedRooms.add(chatroom);
          return true;
        }
        return false;
      } else {
        // If the server did not return a 200 OK response,
        // then throw an exception.
        Get.snackbar(
          "Error",
          jsonDecode(response.body)['message'],
          icon: Icon(
            Icons.error,
            color: Colors.white,
          ),
          colorText: Colors.white,
          backgroundColor: Colors.red,
          snackPosition: SnackPosition.BOTTOM,
        );
        return false;
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
      return false;
    } finally {
      isJoining.value = false;
    }
  }

  Future leaveChatroom(int id) async {
    isJoining.value = true;
    try {
      final response =
          await http.post(Uri.parse('${dotenv.env['API_URL']}/chatrooms/leave'),
              headers: <String, String>{
                'Content-Type': 'application/json; charset=UTF-8',
                'Authorization': 'Bearer ${storage.read("token")}',
              },
              body: jsonEncode(<String, dynamic>{
                'chatroom_id': id,
              }));

      if (response.statusCode == 200) {
        var roomIndex = joinedRooms.indexWhere((element) => element.id == id);
        if (roomIndex != -1) {
          joinedRooms.removeAt(roomIndex);
        } else {}
        // Get.toNamed('/chatroom', parameters: {
        //   'name': jsonDecode(response.body)['name'],
        //   'id': jsonDecode(response.body)['id'].toString(),
        // });
      } else {
        // If the server did not return a 200 OK response,
        // then throw an exception.
        Get.snackbar(
          "Error",
          jsonDecode(response.body)['message'],
          icon: Icon(
            Icons.error,
            color: Colors.white,
          ),
          colorText: Colors.white,
          backgroundColor: Colors.red,
          snackPosition: SnackPosition.BOTTOM,
        );
        return false;
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
      isJoining.value = false;
    }
  }

  Future sendMessage(int id, String message) async {
    try {
      final response =
          await http.post(Uri.parse('${dotenv.env['API_URL']}/chatrooms/send'),
              headers: <String, String>{
                'Content-Type': 'application/json; charset=UTF-8',
                'Authorization': 'Bearer ${storage.read("token")}',
              },
              body: jsonEncode(<String, dynamic>{
                'chatroom_id': id,
                'message': message,
              }));

      if (response.statusCode == 200) {
      } else {
        // If the server did not return a 200 OK response,
        // then throw an exception.
        Get.snackbar(
          "Error",
          jsonDecode(response.body)['message'],
          icon: Icon(
            Icons.error,
            color: Colors.white,
          ),
          colorText: Colors.white,
          backgroundColor: Colors.red,
          snackPosition: SnackPosition.BOTTOM,
        );
        return false;
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
}
