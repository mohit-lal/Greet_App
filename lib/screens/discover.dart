import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:greet_app/controllers/profile_controller.dart';

class DiscoverScreen extends StatelessWidget {
  const DiscoverScreen({super.key});

  @override
  Widget build(BuildContext context) {
    ProfileController profileController = Get.find<ProfileController>();

    return Scaffold(
      appBar: AppBar(
        title: Text("Discover"),
      ),
      body: ListView(
        children: [
          Card(
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
              child: ListTile(
                leading: Icon(Icons.ice_skating),
                trailing: Icon(Icons.chevron_right),
                title: Text("Ice Breaker"),
                onTap: () {
                  Get.toNamed("/icebreaker");
                },
              ),
            ),
          ),
          Card(
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
              child: ListTile(
                leading: Icon(Icons.logout),
                trailing: Icon(Icons.chevron_right),
                title: Text("Logout"),
                onTap: () {
                  profileController.logout();
                },
              ),
            ),
          )
        ],
      ),
    );
  }
}
