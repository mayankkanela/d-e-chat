import 'package:decentralized_encrypted_chat/models/chat.dart';
import 'package:decentralized_encrypted_chat/models/current_user.dart';

class ScreenArgsMessages {
  final CurrentUser currentUser;
  final Chat chatData;
  final String? chatKey;

  ScreenArgsMessages(
      {required this.currentUser,
      required this.chatData,
      required this.chatKey});
}
