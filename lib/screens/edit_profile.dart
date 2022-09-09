import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:greet_app/controllers/profile_controller.dart';
import 'package:intl/intl.dart';
import 'package:textfield_datepicker/textfield_datepicker.dart';

class EditProfileScreen extends StatelessWidget {
  const EditProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    ProfileController profileController = Get.find<ProfileController>();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: Theme.of(context).primaryColor,
        elevation: 0,
        title: Text("Edit Profile"),
      ),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            child: TextFormField(
              controller: profileController.firstName,
              decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "First Name",
                  prefixIcon: Icon(Icons.account_circle)),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            child: TextFormField(
              controller: profileController.lastName,
              decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "Last Name",
                  prefixIcon: Icon(Icons.account_circle)),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            child: TextfieldDatePicker(
              cupertinoDatePickerBackgroundColor: Colors.white,
              cupertinoDatePickerMaximumDate: DateTime.now(),
              cupertinoDatePickerMaximumYear: 2022,
              cupertinoDatePickerMinimumYear: 1900,
              cupertinoDatePickerMinimumDate: DateTime(1900),
              cupertinoDateInitialDateTime: DateTime(1995),
              materialDatePickerFirstDate: DateTime(1900),
              materialDatePickerInitialDate: DateTime(1995),
              materialDatePickerLastDate: DateTime.now(),
              preferredDateFormat: DateFormat('yyyy-MM-dd'),
              textfieldDatePickerController: profileController.dateOfBirth,
              decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "Date of Birth",
                  prefixIcon: Icon(Icons.calendar_month)),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
            child: SizedBox(
              height: 48,
              child: ElevatedButton(
                onPressed: () {
                  profileController.updateProfile();
                },
                child: const Text("Update Profile"),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
