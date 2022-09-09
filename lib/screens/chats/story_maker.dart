import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:greet_app/controllers/story_controller.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:story_maker/story_maker.dart';

class StoryMakerScreen extends StatefulWidget {
  const StoryMakerScreen({super.key});

  @override
  State<StoryMakerScreen> createState() => _StoryMakerScreenState();
}

class _StoryMakerScreenState extends State<StoryMakerScreen> {
  File? image;

  @override
  Widget build(BuildContext context) {
    StoryController storyController = Get.find<StoryController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Upload Story'),
        elevation: 0,
        actions: [
          if (image != null)
            IconButton(
              icon: Icon(Icons.upload),
              onPressed: () {
                storyController.uploadStory(image!);
                setState(() {
                  image = null;
                });
              },
            ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () async {
                await [
                  Permission.photos,
                  Permission.storage,
                ].request();
                final picker = ImagePicker();
                final pickedFile =
                    await picker.pickImage(source: ImageSource.gallery);
                if (pickedFile != null) {
                  final editedFile = await Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => StoryMaker(
                        filePath: pickedFile.path,
                        doneButtonChild:
                            Text("Next", style: TextStyle(color: Colors.black)),
                      ),
                    ),
                  );
                  setState(() {
                    image = editedFile;
                  });
                  print('editedFile: ${image?.path}');
                }
              },
              child: const Text('Pick Image'),
            ),
            if (image != null)
              Expanded(
                child: Image.file(image!),
              ),
          ],
        ),
      ),
    );
  }
}
