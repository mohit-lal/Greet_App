import 'dart:math';

import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:greet_app/controllers/privatechat_controller.dart';
import 'package:greet_app/controllers/story_controller.dart';
import 'package:greet_app/screens/chats/stories.dart';
import 'package:timeago/timeago.dart' as timeago;

class ChatListScreen extends StatelessWidget {
  const ChatListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    PrivatechatController privatechatController =
        Get.find<PrivatechatController>();
    StoryController storyController = Get.find<StoryController>();

    return Obx(
      () => RefreshIndicator(
        onRefresh: () async {
          await privatechatController.fetchChatList();
          await storyController.fetchStories();
        },
        child: SingleChildScrollView(
          physics: AlwaysScrollableScrollPhysics(),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: StoryList(),
              ),
              ListView.builder(
                itemCount: privatechatController.chatList.length,
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemBuilder: ((context, index) {
                  final chatUser = privatechatController.chatList;
                  bool seen;
                  if (chatUser[index].seenAt == null) {
                    if (chatUser[index].senderId ==
                        chatUser[index].receiverId) {
                      seen = true;
                    } else {
                      seen = false;
                    }
                  } else {
                    seen = true;
                  }
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 4.0, horizontal: 16),
                    child: Card(
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: ListTile(
                        onTap: () {
                          Get.toNamed("privatechat", parameters: {
                            "id": chatUser[index].senderId.toString()
                          });
                        },
                        title: Text(
                          "${chatUser[index].username}",
                          style: TextStyle(
                            fontWeight:
                                seen ? FontWeight.normal : FontWeight.bold,
                            color: seen ? Colors.grey.shade600 : Colors.black,
                            fontSize: 16,
                          ),
                        ),
                        subtitle: Text(
                          "${chatUser[index].lastMessage}",
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight:
                                seen ? FontWeight.normal : FontWeight.bold,
                          ),
                        ),
                        isThreeLine: false,
                        leading: Badge(
                          showBadge: false,
                          position: BadgePosition.bottomEnd(bottom: 0, end: 0),
                          padding: EdgeInsets.all(7),
                          elevation: 0,
                          borderSide: BorderSide(
                            color: Colors.white,
                            width: 2,
                          ),
                          badgeColor: Colors.grey,
                          child: CircleAvatar(
                            radius: 24,
                            backgroundColor: Colors.primaries[
                                Random(chatUser[index].id)
                                    .nextInt(Colors.primaries.length)],
                            foregroundImage: chatUser[index].avatar != null
                                ? NetworkImage(chatUser[index].avatar!)
                                : null,
                            child: Text(
                              chatUser[index].username![0].toUpperCase(),
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                        trailing: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              chatUser[index].sentAt != null
                                  ? timeago.format(
                                      DateTime.parse(chatUser[index].sentAt!),
                                      locale: 'en_short',
                                    )
                                  : "",
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey,
                                fontWeight:
                                    seen ? FontWeight.normal : FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
