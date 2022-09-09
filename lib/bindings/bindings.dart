import 'package:get/get.dart';
import 'package:greet_app/controllers/chatroom_controller.dart';
import 'package:greet_app/controllers/login_controller.dart';
import 'package:greet_app/controllers/main_menu_controller.dart';
import 'package:greet_app/controllers/privatechat_controller.dart';
import 'package:greet_app/controllers/profile_controller.dart';
import 'package:greet_app/controllers/story_controller.dart';

class GetxBindings implements Bindings {
// default dependency
  @override
  void dependencies() {
    Get.lazyPut<LoginController>(() => LoginController(), fenix: true);
    Get.lazyPut<MainMenuController>(() => MainMenuController(), fenix: true);
    Get.lazyPut<ProfileController>(() => ProfileController(), fenix: true);
    Get.lazyPut<PrivatechatController>(() => PrivatechatController(),
        fenix: true);
    Get.lazyPut<ChatRoomController>(() => ChatRoomController(), fenix: true);
    Get.lazyPut<StoryController>(() => StoryController(), fenix: true);
  }
}
