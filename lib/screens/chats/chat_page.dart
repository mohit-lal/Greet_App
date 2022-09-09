import 'package:badges/badges.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/state_manager.dart';
import 'package:greet_app/controllers/privatechat_controller.dart';
import 'package:greet_app/controllers/profile_controller.dart';
import 'package:greet_app/screens/chats/chat_list.dart';
import 'package:greet_app/screens/chats/friend_list.dart';

class ChatPageScreen extends StatelessWidget {
  const ChatPageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    PrivatechatController privatechatController =
        Get.find<PrivatechatController>();
    ProfileController profileController = Get.find<ProfileController>();
    profileController.fetchMyProfile();

    return Obx(
      () => DefaultTabController(
        length: 2,
        child: Scaffold(
          backgroundColor: Theme.of(context).primaryColor,
          appBar: AppBar(
            title: Text("Greet"),
            automaticallyImplyLeading: false,
            elevation: 0,
            actions: [
              IconButton(
                icon: Icon(Icons.add_circle_outline),
                onPressed: () {
                  Get.toNamed("storymaker");
                },
              ),
              InkWell(
                onTap: () {
                  Get.toNamed("/myprofile");
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CircleAvatar(
                    radius: 16,
                    backgroundColor: Colors.white,
                    child: CircleAvatar(
                      backgroundColor: Colors.white,
                      radius: 14,
                      foregroundImage: profileController.user.value.avatar !=
                              null
                          ? NetworkImage(profileController.user.value.avatar!)
                          : null,
                      backgroundImage: AssetImage('assets/images/user.jpg'),
                    ),
                  ),
                ),
              ),
              IconButton(
                icon: Icon(Icons.search),
                onPressed: () {
                  Get.toNamed('/search');
                },
              ),
            ],
            bottom: TabBar(
              unselectedLabelColor: Colors.white60,
              indicatorColor: Colors.grey.shade100,
              indicatorPadding:
                  EdgeInsets.symmetric(horizontal: 30, vertical: 0),
              tabs: <Widget>[
                Tab(
                  child: Obx(
                    () => Badge(
                      badgeContent: Text(
                          privatechatController.unreadCount.value.toString(),
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          )),
                      badgeColor: Colors.orange,
                      position: BadgePosition.topEnd(top: -5, end: -30),
                      showBadge: privatechatController.unreadCount.value > 0,
                      child: Text("Chats"),
                    ),
                  ),
                ),
                Tab(
                  text: "Friends",
                ),
              ],
            ),
          ),
          body: Container(
            constraints: BoxConstraints.expand(),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            child: TabBarView(
              children: [
                ChatListScreen(),
                FriendListScreen(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
