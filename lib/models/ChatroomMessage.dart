class ChatRoomMessage {
  final int? id;
  final int? senderId;
  final String? sender;
  final String? message;
  final int? type;

  ChatRoomMessage(
      {this.id, this.senderId, this.sender, this.message, this.type});

  factory ChatRoomMessage.fromJson(Map<String, dynamic> json) {
    return ChatRoomMessage(
      id: json['id'],
      senderId: json['sender_id'],
      sender: json['sender'],
      message: json['message'],
      type: json['type'],
    );
  }
}
