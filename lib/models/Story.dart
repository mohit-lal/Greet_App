import 'package:greet_app/models/ChatroomMessage.dart';
import 'package:greet_app/models/Profile.dart';

class Story {
  final int id;
  final Profile? user;
  final String? text;
  final String? image;

  Story({required this.id, this.user, this.text, this.image});

  factory Story.fromJson(Map<String, dynamic> json) {
    return Story(
      id: json['id'],
      text: json['text'],
      image: json['image'],
      user: Profile.fromJson(json['user']),
    );
  }
}
