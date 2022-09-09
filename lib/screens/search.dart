import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:greet_app/controllers/profile_controller.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    ProfileController profileController = Get.find<ProfileController>();

    return Scaffold(
      appBar: AppBar(
        title: Obx(
          () => TextField(
            controller: profileController.searchQuery,
            cursorColor: Colors.white,
            autofocus: true,
            onChanged: (String query) {
              profileController.searchUsers();
            },
            decoration: InputDecoration(
                hintText: " Search...",
                hintStyle: TextStyle(color: Colors.white),
                border: InputBorder.none,
                suffix: profileController.isLoading.value
                    ? SizedBox(
                        height: 16,
                        width: 16,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : null),
            style: TextStyle(
              color: Colors.white,
              fontSize: 15.0,
            ),
          ),
        ),
      ),
      body: Obx(
        () => ListView.builder(
          itemCount: profileController.searchList.length,
          itemBuilder: ((context, index) {
            var user = profileController.searchList;
            return Card(
                elevation: 0,
                child: Padding(
                  padding: const EdgeInsets.all(0.0),
                  child: ListTile(
                    onTap: () {
                      // profileController.setProfile(user[index].username!);
                      Get.toNamed("/profile",
                          parameters: {"username": user[index].username!});
                    },
                    title: Text(
                        "${user[index].firstName ?? ""} ${user[index].lastName ?? ""}"),
                    subtitle: Text("@${user[index].username!}"),
                    leading: CircleAvatar(
                      radius: 24,
                      backgroundColor: Colors.primaries[Random(user[index].id)
                          .nextInt(Colors.primaries.length)],
                      foregroundImage: user[index].avatar != null
                          ? NetworkImage(user[index].avatar!)
                          : null,
                      child: Text(
                        user[index].username![0].toUpperCase(),
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ));
          }),
        ),
      ),
    );
  }
}
