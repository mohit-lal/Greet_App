import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:greet_app/models/Profile.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class ProfileController extends GetxController {
  final firstName = TextEditingController();
  final lastName = TextEditingController();
  final dateOfBirth = TextEditingController();
  final searchQuery = TextEditingController();
  final storage = GetStorage();
  final user = Profile().obs;
  final profile = Profile().obs;
  final isFollowing = false.obs;
  final searchList = <Profile>[].obs;
  final isLoading = false.obs;
  final isProfileLoading = false.obs;
  final username = "".obs;

  @override
  void onInit() {
    super.onInit();
    //fetchMyProfile();
  }

  @override
  void onClose() {
    super.onClose();
    firstName.dispose();
    lastName.dispose();
    dateOfBirth.dispose();
  }

  void setProfile(String username) {
    this.username.value = username;
    fetchUserProfile(username);
  }

  Future logout() async {
    storage.remove("bearer");
    storage.remove("token");
    storage.remove("user");
    Get.offAllNamed("/login");
  }

  Future fetchMyProfile() async {
    try {
      final response = await http.get(
        Uri.parse('${dotenv.env['API_URL']}/myprofile'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer ${storage.read("token")}',
        },
      );

      if (response.statusCode == 200) {
        Profile profile = Profile.fromJson(jsonDecode(response.body));
        user.value = profile;
        firstName.text = profile.firstName ?? "";
        lastName.text = profile.lastName ?? "";
        dateOfBirth.text = profile.dateOfBirth != null
            ? DateFormat('yyyy-MM-dd')
                .format(DateTime.parse(profile.dateOfBirth!))
            : "";
      } else {
        // If the server did not return a 200 OK response,
        // then throw an exception.
        Get.snackbar(
          "Error",
          "Can't load profile",
          icon: Icon(
            Icons.error,
            color: Colors.white,
          ),
          colorText: Colors.white,
          backgroundColor: Colors.red,
        );
      }
    } on Exception {
      Get.snackbar(
        "Error",
        "Could not connect to server.",
        icon: Icon(
          Icons.error,
          color: Colors.white,
        ),
        colorText: Colors.white,
        backgroundColor: Colors.red,
      );
    }
  }

  Future fetchUserProfile(String username) async {
    isProfileLoading.value = true;
    try {
      final response = await http.get(
        Uri.parse('${dotenv.env['API_URL']}/profile?username=$username'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer ${storage.read("token")}',
        },
      );

      if (response.statusCode == 200) {
        Profile profile = Profile.fromJson(jsonDecode(response.body));
        this.profile.value = profile;
        isFollowing.value = profile.isFollowing!;
      } else {
        // If the server did not return a 200 OK response,
        // then throw an exception.
        Get.snackbar(
          "Error",
          "Can't load profile",
          icon: Icon(
            Icons.error,
            color: Colors.white,
          ),
          colorText: Colors.white,
          backgroundColor: Colors.red,
        );
      }
    } on Exception {
      Get.snackbar(
        "Error",
        "Could not connect to server.",
        icon: Icon(
          Icons.error,
          color: Colors.white,
        ),
        colorText: Colors.white,
        backgroundColor: Colors.red,
      );
    } finally {
      isProfileLoading.value = false;
    }
  }

  Future updateProfile() async {
    try {
      final response =
          await http.put(Uri.parse('${dotenv.env['API_URL']}/updateprofile'),
              headers: <String, String>{
                'Content-Type': 'application/json; charset=UTF-8',
                'Authorization': 'Bearer ${storage.read("token")}',
              },
              body: jsonEncode(<String, String>{
                'first_name': firstName.text,
                'last_name': lastName.text,
                'date_of_birth': dateOfBirth.text
              }));

      if (response.statusCode == 200) {
        Profile profile = Profile.fromJson(jsonDecode(response.body)['user']);
        user.value = profile;
        firstName.text = profile.firstName ?? "";
        lastName.text = profile.lastName ?? "";
        dateOfBirth.text = profile.dateOfBirth != null
            ? DateFormat('yyyy-MM-dd')
                .format(DateTime.parse(profile.dateOfBirth!))
            : "";
        Get.snackbar(
          "Success",
          jsonDecode(response.body)['message'],
          icon: Icon(
            Icons.error,
            color: Colors.white,
          ),
          colorText: Colors.white,
          backgroundColor: Colors.green,
          isDismissible: true,
          dismissDirection: DismissDirection.horizontal,
          snackPosition: SnackPosition.BOTTOM,
        );
      } else {
        // If the server did not return a 200 OK response,
        // then throw an exception.
        Get.snackbar(
          "Error",
          jsonDecode(response.body)['message'],
          icon: Icon(
            Icons.error,
            color: Colors.white,
          ),
          colorText: Colors.white,
          backgroundColor: Colors.red,
          isDismissible: true,
          dismissDirection: DismissDirection.horizontal,
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } on Exception {
      Get.snackbar(
        "Error",
        "Could not connect to server.",
        icon: Icon(
          Icons.error,
          color: Colors.white,
        ),
        colorText: Colors.white,
        backgroundColor: Colors.red,
        isDismissible: true,
        dismissDirection: DismissDirection.horizontal,
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  Future searchUsers() async {
    isLoading.value = true;
    try {
      final response = await http.get(
        Uri.parse('${dotenv.env['API_URL']}/search?query=${searchQuery.text}'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer ${storage.read("token")}',
        },
      );

      if (response.statusCode == 200) {
        List<Profile> users = List<Profile>.from(
            jsonDecode(response.body).map((x) => Profile.fromJson(x)));
        searchList.value = users;
      } else {
        // If the server did not return a 200 OK response,
        // then throw an exception.
        Get.snackbar(
          "Error",
          "Failed to search users.",
          icon: Icon(
            Icons.error,
            color: Colors.white,
          ),
          colorText: Colors.white,
          backgroundColor: Colors.red,
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } on Exception {
      Get.snackbar(
        "Error",
        "Could not connect to server.",
        icon: Icon(
          Icons.error,
          color: Colors.white,
        ),
        colorText: Colors.white,
        backgroundColor: Colors.red,
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future follow(int id) async {
    isLoading.value = true;
    try {
      final response = await http.get(
        Uri.parse('${dotenv.env['API_URL']}/follow?user=$id'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer ${storage.read("token")}',
        },
      );

      if (response.statusCode == 200) {
        isFollowing.value = true;
        Get.snackbar(
          "Success",
          jsonDecode(response.body)['message'],
          icon: Icon(
            Icons.error,
            color: Colors.white,
          ),
          colorText: Colors.white,
          backgroundColor: Colors.green,
          isDismissible: true,
          dismissDirection: DismissDirection.horizontal,
          snackPosition: SnackPosition.BOTTOM,
        );
      } else {
        // If the server did not return a 200 OK response,
        // then throw an exception.
        Get.snackbar(
          "Error",
          "Failed to search users.",
          icon: Icon(
            Icons.error,
            color: Colors.white,
          ),
          colorText: Colors.white,
          backgroundColor: Colors.red,
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } on Exception {
      Get.snackbar(
        "Error",
        "Could not connect to server.",
        icon: Icon(
          Icons.error,
          color: Colors.white,
        ),
        colorText: Colors.white,
        backgroundColor: Colors.red,
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future unfollow(int id) async {
    isLoading.value = true;
    try {
      final response = await http.get(
        Uri.parse('${dotenv.env['API_URL']}/unfollow?user=$id'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer ${storage.read("token")}',
        },
      );

      if (response.statusCode == 200) {
        isFollowing.value = false;
        Get.snackbar(
          "Success",
          jsonDecode(response.body)['message'],
          icon: Icon(
            Icons.error,
            color: Colors.white,
          ),
          colorText: Colors.white,
          backgroundColor: Colors.green,
          isDismissible: true,
          dismissDirection: DismissDirection.horizontal,
          snackPosition: SnackPosition.BOTTOM,
        );
      } else {
        // If the server did not return a 200 OK response,
        // then throw an exception.
        Get.snackbar(
          "Error",
          "Failed to search users.",
          icon: Icon(
            Icons.error,
            color: Colors.white,
          ),
          colorText: Colors.white,
          backgroundColor: Colors.red,
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } on Exception {
      Get.snackbar(
        "Error",
        "Could not connect to server.",
        icon: Icon(
          Icons.error,
          color: Colors.white,
        ),
        colorText: Colors.white,
        backgroundColor: Colors.red,
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }
}
