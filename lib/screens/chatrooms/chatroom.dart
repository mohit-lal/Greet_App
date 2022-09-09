import 'package:chat_bubbles/chat_bubbles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/state_manager.dart';
import 'package:greet_app/controllers/chatroom_controller.dart';
import 'package:greet_app/controllers/profile_controller.dart';
import 'package:greet_app/models/Chatroom.dart';
import 'package:greet_app/services/socket_api.dart';
import 'package:greet_app/widgets/chat_bubble.dart';
import 'package:greet_app/widgets/message_bar.dart';
import 'package:socket_io_client/socket_io_client.dart';

class ChatroomScreen extends StatelessWidget {
  var chatroom;

  ChatroomScreen({super.key, this.chatroom});

  @override
  Widget build(BuildContext context) {
    ChatRoomController chatroomController = Get.find<ChatRoomController>();
    ProfileController profileController = Get.find<ProfileController>();
    var room = chatroomController.joinedRooms
        .indexWhere((room) => room.id == chatroom.id);

    Socket socket = SocketApi().getInstance();
    socket.emit("joinRoom", chatroom.id);

    return Scaffold(
      body: Stack(
        children: <Widget>[
          Obx(
            () => Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: ListView.builder(
                  padding: EdgeInsets.only(bottom: 50),
                  controller: chatroomController.scrollController,
                  itemCount: room != -1
                      ? chatroomController.joinedRooms[room].messages?.length
                      : 0,
                  itemBuilder: (context, index) {
                    // find type
                    var type = 0;
                    if (chatroomController
                            .joinedRooms[room].messages![index].sender ==
                        profileController.user.value.username) {
                      type = 1;
                    }
                    if (chatroomController
                            .joinedRooms[room].messages![index].sender ==
                        "SYSTEM") {
                      type = 2;
                    }
                    if (chatroomController
                            .joinedRooms[room].messages![index].sender ==
                        "GIFT") {
                      type = 3;
                    }
                    if (chatroomController
                            .joinedRooms[room].messages![index].sender ==
                        "GAME") {
                      type = 4;
                    }
                    return ChatBubble(
                      user: chatroomController
                          .joinedRooms[room].messages![index].sender,
                      type: type,
                      message: chatroomController
                          .joinedRooms[room].messages![index].message,
                      prevUser: index > 0
                          ? chatroomController
                              .joinedRooms[room].messages![index - 1].sender
                          : '',
                    );
                  }),
            ),
          ),
          CustomMessageBar(
            actions: [
              PopupMenuButton(
                position: PopupMenuPosition.over,
                itemBuilder: (context) => [
                  PopupMenuItem(
                    value: 1,
                    onTap: () {
                      chatroomController.leaveChatroom(chatroom.id);
                    },
                    child: Text("Leave Chatroom"),
                  ),
                ],
              ),
            ],
            onSend: (message) {
              chatroomController.sendMessage(chatroom.id, message);
            },
          ),
        ],
      ),
    );
  }
}
