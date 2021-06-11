import 'package:decentralized_encrypted_chat/models/chat.dart';
import 'package:decentralized_encrypted_chat/models/current_user.dart';
import 'package:decentralized_encrypted_chat/provider/user_provider.dart';
import 'package:decentralized_encrypted_chat/screens/chat/screen_args_messages.dart';
import 'package:decentralized_encrypted_chat/utils/constants.dart';
import 'package:decentralized_encrypted_chat/utils/utility.dart' as utils;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChatItem extends StatelessWidget {
  const ChatItem({
    Key? key,
    required this.data,
    required this.currentUser,
    required this.dw,
    required this.dh,
  }) : super(key: key);

  final Chat data;
  final CurrentUser currentUser;
  final double dh;
  final double dw;

  @override
  Widget build(BuildContext context) {
    final String? chatKey = data.getChatKey(
        currentUserEmail: currentUser.email,
        appKey: Provider.of<UserProvider>(context, listen: false).appKey,
        encAsymPvtKey: currentUser.encAsymPvtKey);
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () => data.groupName == null
          ? _openMessageScreen(data, currentUser, chatKey, context)
          : _openGroupMessageScreen(data, currentUser, chatKey, context),
      child: Padding(
        padding: EdgeInsets.all(dw * 2),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              data.groupName == null
                  ? data.getReceiverId(currentUser.email)
                  : data.groupName ?? "empty",
              style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: dh * 2.2),
            ),
            SizedBox(
              height: dh * 1,
            ),
            Text(
              utils.isNullOrEmpty(data.lastMessage)
                  ? "No Messages"
                  : data.getDecryptLastMessage(chatKey),
              style: TextStyle(color: Colors.grey),
            ),
            SizedBox(
              height: dh * 1,
            ),
            Divider(
              color: Colors.grey,
            )
          ],
        ),
      ),
    );
  }

  _openMessageScreen(Chat data, CurrentUser currentUser, String? chatKey,
      BuildContext context) {
    Navigator.of(context).pushNamed(Constants.ROUTE_CHAT_SCREEN,
        arguments: ScreenArgsMessages(
            currentUser: currentUser, chatData: data, chatKey: chatKey));
  }

  _openGroupMessageScreen(Chat data, CurrentUser currentUser, String? chatKey,
      BuildContext context) {
    Navigator.of(context).pushNamed(Constants.ROUTE_GROUP_CHAT_SCREEN,
        arguments: ScreenArgsMessages(
            currentUser: currentUser, chatData: data, chatKey: chatKey));
  }
}
