import 'package:greet_app/models/ChatroomMessage.dart';

class ChatRoom {
  final int id;
  final String? name;
  final String? description;
  final int? joined;
  final int? capacity;
  final int? owner;
  List<ChatRoomMessage>? messages;

  ChatRoom(
      {required this.id,
      this.name,
      this.description,
      this.joined,
      this.capacity,
      this.owner,
      this.messages});

  factory ChatRoom.fromJson(Map<String, dynamic> json) {
    return ChatRoom(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      joined: json['joined'],
      capacity: json['capacity'],
      owner: json['owner'],
      messages: json['messages'] != null
          ? List<ChatRoomMessage>.from(
              json['messages'].map((x) => ChatRoomMessage.fromJson(x)))
          : [],
    );
  }
}
