import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:chat_bubbles/chat_bubbles.dart';

class ChatBubble extends StatelessWidget {
  final message;
  final user;
  final type;
  final prevUser;

  const ChatBubble(
      {super.key, this.type, this.message, this.user, this.prevUser});

  @override
  Widget build(BuildContext context) {
    var color = {
      2: Colors.blue,
      3: Colors.pink,
      4: Colors.purple,
    };
    return (type > 1)
        ? Center(child: Text(message, style: TextStyle(color: color[type])))
        : Padding(
            padding: type == 2
                ? EdgeInsets.all(0)
                : EdgeInsets.symmetric(vertical: 4.0),
            child: Column(
              children: [
                type == 0 && user != prevUser
                    ? Padding(
                        padding: const EdgeInsets.only(left: 16.0),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            user,
                            style: TextStyle(
                                color: Colors.black87,
                                fontStyle: FontStyle.italic),
                          ),
                        ),
                      )
                    : SizedBox(height: 0),
                BubbleSpecialTwo(
                  text: message,
                  color: type == 1
                      ? Theme.of(context).primaryColor
                      : Colors.black12,
                  isSender: type == 1,
                  tail: false,
                  textStyle: TextStyle(
                      color: type == 1 ? Colors.white : Colors.black,
                      fontSize: 16),
                ),
              ],
            ),
          );
  }
}
