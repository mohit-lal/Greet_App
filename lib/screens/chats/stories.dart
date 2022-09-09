import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:greet_app/controllers/story_controller.dart';
import 'package:greet_app/models/Story.dart';
import 'package:stories_for_flutter/stories_for_flutter.dart';
import 'package:stories_for_flutter/story_circle.dart';

class StoryList extends StatelessWidget {
  const StoryList({super.key});

  @override
  Widget build(BuildContext context) {
    StoryController storyController = Get.find<StoryController>();
    storyController.fetchStories();

    var stories = storyController.stories;
    print(stories);

    return Column(
      children: [
        Stories(
          autoPlayDuration: Duration(seconds: 3),
          displayProgress: true,
          highLightColor: Colors.grey,
          storyItemList: () {
            List<StoryItem> storyItems = [];
            stories.forEach((story) {
              storyItems.add(StoryItem(
                name: story.user!.username ?? "",
                thumbnail: NetworkImage(story.user!.avatar ?? ''),
                stories: [
                  Scaffold(
                    body: Container(
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          fit: BoxFit.cover,
                          image: NetworkImage(
                            "${dotenv.env['BASE_URL']}/uploads/${story.image}",
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ));
            });
            return storyItems;
          }(),
        ),
      ],
    );
  }
}
