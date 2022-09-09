import 'dart:async';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:greet_app/controllers/chatroom_controller.dart';
import 'package:greet_app/screens/chatrooms/chatroom.dart';
import 'package:greet_app/screens/chatrooms/chatroom_list.dart';
import 'package:greet_app/screens/chats/chat_list.dart';

class ChatroomPageScreen extends StatelessWidget {
  const ChatroomPageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    ChatRoomController chatRoomController = Get.find<ChatRoomController>();
    chatRoomController.fetchChatRooms();
    chatRoomController.fetchMyChatRooms();
    chatRoomController.fetchJoinedChatRooms();

    return Obx(
      () => DefaultTabController(
        length: chatRoomController.joinedRooms.length + 1,
        child: Scaffold(
          appBar: AppBar(
            title: Text("Chatrooms"),
            elevation: 0,
            bottom: TabBar(
              isScrollable: true,
              enableFeedback: true,
              indicatorWeight: 5,
              indicatorColor: Colors.white,
              tabs: () {
                List<Widget> tabs = [];
                tabs.add(Tab(
                  child: Row(
                    children: [
                      Icon(Icons.forum_outlined),
                      Text("Chatrooms",
                          style: TextStyle(fontWeight: FontWeight.bold)),
                    ],
                  ),
                ));
                chatRoomController.joinedRooms.forEach((room) {
                  tabs.add(Tab(
                    child: Text(room.name.toString()),
                  ));
                });
                return tabs;
              }(),
            ),
          ),
          body: Obx(() => TabBarView(
                children: [
                  ChatroomListScreen(),
                  ...chatRoomController.joinedRooms.map((room) {
                    return ChatroomScreen(
                      chatroom: room,
                    );
                  }),
                ],
              )),
        ),
      ),
    );
  }
}
