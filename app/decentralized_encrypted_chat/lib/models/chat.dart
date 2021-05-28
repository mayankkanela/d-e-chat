import 'package:decentralized_encrypted_chat/models/message.dart';

class Chat {
  static const ENC_SYM_KEY_M0 = "encSymKeyP0";
  static const ENC_SYM_KEY_M1 = "encSymKeyP1";
  static const M1_INIT = "p1Init";
  static const MEMBERS = "members";

  final List<String> members;
  final String encSymKeyM0;
  final String encSymKeyM1;
  final bool m1Init;
  final List<Message> messages;

  Chat(
      {required this.encSymKeyM0,
      required this.encSymKeyM1,
      required this.m1Init,
      required this.members,
      required this.messages});

  factory Chat.fromJSON(Map<String, dynamic> json) {
    // todo: parse messages
    final messages = <Message>[];
    final List<String> members = List.castFrom(json[MEMBERS]);
    return Chat(
      messages: messages,
      m1Init: json[M1_INIT],
      members: members,
      encSymKeyM0: json[ENC_SYM_KEY_M0],
      encSymKeyM1: json[ENC_SYM_KEY_M1],
    );
  }
}
