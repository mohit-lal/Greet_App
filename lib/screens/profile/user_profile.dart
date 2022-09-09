import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:greet_app/controllers/main_menu_controller.dart';
import 'package:greet_app/controllers/privatechat_controller.dart';
import 'package:greet_app/controllers/profile_controller.dart';
import 'package:greet_app/widgets/profile_link.dart';

class UserProfileScreen extends StatelessWidget {
  const UserProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    ProfileController profileController = Get.find<ProfileController>();
    PrivatechatController privatechatController =
        Get.find<PrivatechatController>();

    MainMenuController mainMenuController = Get.find<MainMenuController>();
    final parameters = Get.parameters;
    profileController.fetchUserProfile(parameters["username"]!);

    return Scaffold(
      appBar: AppBar(
        title: Text("Profile"),
        elevation: 0,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: mainMenuController.selectedIndex.value,
        items: mainMenuController.menu,
        onTap: mainMenuController.onTap,
      ),
      body: Obx(
        () => profileController.isProfileLoading.value
            ? Center(child: CircularProgressIndicator())
            : RefreshIndicator(
                onRefresh: () async {
                  await profileController
                      .fetchUserProfile(parameters["username"]!);
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListView(
                    children: [
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8.0, vertical: 8.0),
                          child: Text(
                            "@${profileController.profile.value.username ?? ''}",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      Center(
                        child: CircleAvatar(
                          radius: 80,
                          //backgroundImage: AssetImage("assets/images/user.jpg"),
                          backgroundColor: Colors.blue,
                          foregroundImage:
                              profileController.profile.value.avatar != null
                                  ? NetworkImage(
                                      profileController.profile.value.avatar!)
                                  : null,
                          child: Text(
                            profileController.profile.value.username != null
                                ? profileController.profile.value.username![0]
                                    .toUpperCase()
                                : "Greet",
                            style: TextStyle(
                              fontSize: 48,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8.0, vertical: 8.0),
                          child: Text(
                            "${profileController.profile.value.firstName ?? ''} ${profileController.profile.value.lastName ?? ''}",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8.0, vertical: 0),
                          child: Text(
                            "Hi, I am using greet app.",
                            style: TextStyle(
                              fontWeight: FontWeight.w300,
                            ),
                          ),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Obx(() => ElevatedButton(
                                    onPressed: () {
                                      var isFollowing =
                                          profileController.isFollowing.value;
                                      if (isFollowing) {
                                        profileController.unfollow(
                                            profileController
                                                .profile.value.id!);
                                      } else {
                                        profileController.follow(
                                            profileController
                                                .profile.value.id!);
                                      }
                                    },
                                    child: (profileController.isFollowing.value)
                                        ? Text("Unfollow")
                                        : Text("+ Follow"),
                                  )),
                            ),
                          ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: OutlinedButton(
                                onPressed: () {
                                  privatechatController.fetchChat(
                                      profileController.profile.value.id!);
                                  Get.toNamed("privatechat", parameters: {
                                    "id": profileController.profile.value.id
                                        .toString(),
                                  });
                                },
                                child: Text("Message"),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Divider(),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8.0, vertical: 16.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            InkWell(
                              onTap: () {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text("Followers"),
                                          IconButton(
                                              onPressed: () =>
                                                  Navigator.of(context).pop(),
                                              icon: Icon(Icons.close)),
                                        ],
                                      ),
                                      actions: [],
                                      content: Container(
                                        width: double.maxFinite,
                                        child: ListView.builder(
                                          itemCount: profileController
                                              .profile.value.followers!.length,
                                          itemBuilder:
                                              (BuildContext buildContext,
                                                  int index) {
                                            return ProfileLink(
                                              user: profileController.profile
                                                  .value.followers![index],
                                            );
                                          },
                                          shrinkWrap: true,
                                        ),
                                      ),
                                    );
                                  },
                                );
                              },
                              child: Column(
                                children: [
                                  Text(
                                    "${profileController.profile.value.followers?.length}",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16.0,
                                    ),
                                  ),
                                  Text("Followers")
                                ],
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text("Followings"),
                                          IconButton(
                                              onPressed: () =>
                                                  Navigator.of(context).pop(),
                                              icon: Icon(Icons.close)),
                                        ],
                                      ),
                                      actions: [],
                                      content: Container(
                                        width: double.maxFinite,
                                        child: ListView.builder(
                                          itemCount: profileController
                                              .profile.value.followings!.length,
                                          itemBuilder:
                                              (BuildContext buildContext,
                                                  int index) {
                                            return ProfileLink(
                                              user: profileController.profile
                                                  .value.followings![index],
                                            );
                                          },
                                          shrinkWrap: true,
                                        ),
                                      ),
                                    );
                                  },
                                );
                              },
                              child: Column(
                                children: [
                                  Text(
                                    "${profileController.profile.value.followings?.length}",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16.0,
                                    ),
                                  ),
                                  Text("Followings")
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Divider(),
                      // Card(
                      //   child: ListTile(
                      //     onTap: () {},
                      //     leading: CircleAvatar(
                      //       child: Icon(Icons.block),
                      //     ),
                      //     title: Text("Block User"),
                      //     trailing: Icon(Icons.chevron_right),
                      //   ),
                      // ),
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}
