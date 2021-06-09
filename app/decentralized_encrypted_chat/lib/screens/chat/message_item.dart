import 'package:decentralized_encrypted_chat/models/message.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MessageItem extends StatelessWidget {
  const MessageItem(
      {Key? key,
      required this.chatKey,
      required this.message,
      required this.currentUser,
      required this.dw,
      required this.dh})
      : super(key: key);

  final String? chatKey;
  final Message message;
  final double dw;
  final double dh;
  final String currentUser;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: message.from == currentUser
          ? MainAxisAlignment.end
          : MainAxisAlignment.start,
      children: [
        Flexible(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: dw * 3, vertical: dh * 1),
            margin: EdgeInsets.only(
                left: message.from == currentUser ? dw * 20 : dw * 3,
                right: message.from == currentUser ? dw * 3 : dw * 20,
                top: dh * 0.5,
                bottom: dh * 0.5),
            decoration: BoxDecoration(
              borderRadius: message.from == currentUser
                  ? BorderRadius.only(
                      topRight: Radius.circular(dh * 2),
                      topLeft: Radius.circular(dh * 2),
                      bottomLeft: Radius.circular(dh * 2))
                  : BorderRadius.only(
                      bottomRight: Radius.circular(dh * 2),
                      bottomLeft: Radius.circular(dh * 2),
                      topRight: Radius.circular(dh * 2)),
              color:
                  message.from == currentUser ? Colors.black38 : Colors.black12,
            ),
            child: Column(
              crossAxisAlignment: message.from == currentUser
                  ? CrossAxisAlignment.end
                  : CrossAxisAlignment.start,
              children: [
                Text(
                  message.decrypted(symKey: chatKey) ,
                  style: TextStyle(
                      color: message.from == currentUser
                          ? Colors.white
                          : Colors.black),
                ),
                SizedBox(
                  height: dh * 0.5,
                ),
                Text(
                  message.getTime(),
                  style: TextStyle(
                      fontWeight: FontWeight.w300,
                      fontSize: dh * 1,
                      color: message.from == currentUser
                          ? Colors.white
                          : Colors.black),
                  textAlign: TextAlign.end,
                )
              ],
            ),
          ),
        ),
      ],
    );
  }
}
