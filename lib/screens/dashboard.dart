import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:greet_app/controllers/main_menu_controller.dart';
import 'package:greet_app/controllers/profile_controller.dart';
import 'package:greet_app/screens/chatrooms/chatroom_list.dart';
import 'package:greet_app/screens/chatrooms/chatroom_page.dart';
import 'package:greet_app/screens/chats/chat_page.dart';
import 'package:greet_app/screens/discover.dart';
import 'package:greet_app/services/socket_api.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    MainMenuController mainMenuController = Get.find<MainMenuController>();
    ProfileController profileController = Get.find<ProfileController>();

    profileController.fetchMyProfile();

    return Obx(
      () => Scaffold(
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: mainMenuController.selectedIndex.value,
          items: mainMenuController.menu,
          onTap: mainMenuController.onTap,
        ),
        body: SafeArea(
          child: IndexedStack(
            index: mainMenuController.selectedIndex.value,
            children: const [
              ChatPageScreen(),
              ChatroomPageScreen(),
              DiscoverScreen(),
            ],
          ),
        ),
      ),
    );
  }
}
