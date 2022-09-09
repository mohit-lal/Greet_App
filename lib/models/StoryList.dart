import 'package:greet_app/models/Profile.dart';
import 'package:greet_app/models/Story.dart';

class StoryList {
  final int? user_id;
  final Profile? user;
  final List<Story>? stories;

  StoryList({this.user_id, this.user, this.stories});

  factory StoryList.fromJson(Map<String, dynamic> json) {
    return StoryList(
      user_id: json['user_id'],
      user: Profile.fromJson(json['user']),
      stories: (json['stories'] as List<dynamic>)
          .map((i) => Story.fromJson(i as Map<String, dynamic>))
          .toList(),
    );
  }
}
