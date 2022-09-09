import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:greet_app/controllers/profile_controller.dart';
import 'package:greet_app/widgets/profile_link.dart';

class FollowListScreen extends StatelessWidget {
  const FollowListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final parameters = Get.parameters;
    ProfileController profileController = Get.find<ProfileController>();

    return Scaffold(
      appBar: AppBar(
        title: parameters["type"] == "followers"
            ? Text('Followers')
            : Text('Following'),
      ),
      body: ListView.builder(
        itemCount: parameters["type"] == "followers"
            ? profileController.profile.value.followers!.length
            : profileController.profile.value.followings!.length,
        itemBuilder: (BuildContext buildContext, int index) {
          return ProfileLink(
            user: parameters["type"] == "followers"
                ? profileController.profile.value.followers![index]
                : profileController.profile.value.followings![index],
          );
        },
        shrinkWrap: true,
      ),
    );
  }
}
