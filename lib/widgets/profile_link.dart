import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:get/get.dart';
import 'package:get/state_manager.dart';
import 'package:greet_app/controllers/profile_controller.dart';
import 'package:greet_app/models/Profile.dart';

class ProfileLink extends StatelessWidget {
  const ProfileLink({super.key, required this.user});

  final Profile user;

  @override
  Widget build(BuildContext context) {
    ProfileController profileController = Get.find<ProfileController>();

    return ListTile(
      contentPadding: EdgeInsets.all(0),
      onTap: () {
        //profileController.setProfile(user.username!);
        Navigator.of(context, rootNavigator: true).pop();
        //Get.toNamed("/profile", parameters: {"username": user.username!});
        Get.toNamed("/profile",
            parameters: {"username": user.username!}, preventDuplicates: true);
      },
      title: Text(
        '${user.firstName!} ${user.lastName!}',
        style: TextStyle(
          fontWeight: FontWeight.normal,
          fontSize: 18,
        ),
      ),
      subtitle: Text('@${user.username!}'),
      leading: CircleAvatar(
        radius: 24,
        backgroundColor:
            Colors.primaries[Random(user.id).nextInt(Colors.primaries.length)],
        foregroundImage:
            user.avatar != null ? NetworkImage(user.avatar!) : null,
        child: Text(
          user.username![0].toUpperCase(),
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}
