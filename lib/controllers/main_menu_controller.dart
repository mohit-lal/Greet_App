import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class MainMenuController extends GetxController {
  final RxInt selectedIndex = 0.obs;
  final List<BottomNavigationBarItem> menu = <BottomNavigationBarItem>[
    BottomNavigationBarItem(
      icon: Icon(MdiIcons.chatOutline),
      label: "Chats",
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.forum_outlined),
      label: "Chatrooms",
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.travel_explore_outlined),
      label: "Discover",
    ),
  ].obs;

  void onTap(int index) {
    selectedIndex.value = index;
    Get.toNamed("/dashboard");
  }
}
