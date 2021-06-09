import 'dart:developer';

import 'package:decentralized_encrypted_chat/utils/aes_helper.dart'
    as aesHelper;
import 'package:decentralized_encrypted_chat/utils/rsa_pem_helper.dart'
    as rsaHelper;

class Chat {
  static const ENC_SYM_KEY_M0 = "encSymKeyP0";
  static const ENC_SYM_KEY_M1 = "encSymKeyP1";
  static const M1_INIT = "p1Init";
  static const MEMBERS = "members";
  static const LAST_MESSAGE = "lastMessage";

  final List<String> members;
  final String encSymKeyM0;
  final String encSymKeyM1;
  final bool m1Init;
  final String lastMessage;
  final String docId;

  Chat({
    required this.encSymKeyM0,
    required this.encSymKeyM1,
    required this.m1Init,
    required this.members,
    required this.lastMessage,
    required this.docId,
  });

  factory Chat.fromJSON(Map<String, dynamic> json, String docId) {
    // todo: parse messages
    final List<String> members = List.castFrom(json[MEMBERS]);
    return Chat(
        m1Init: json[M1_INIT],
        members: members,
        encSymKeyM0: json[ENC_SYM_KEY_M0],
        encSymKeyM1: json[ENC_SYM_KEY_M1],
        lastMessage: json[LAST_MESSAGE],
        docId: docId);
  }

  String getReceiverId(String currentUserEmail) {
    return currentUserEmail == this.members[0]
        ? this.members[1]
        : this.members[0];
  }

  String getDecryptLastMessage(String? chatKey) {
    try {
      return aesHelper.decrypt(this.lastMessage, chatKey!)!;
    } catch (e, st) {
      log("${e.toString()} \n ${st.toString()}");
      return "CLEAR_CACHE_RESTART";
    }
  }

  String? getChatKey(
      {required String currentUserEmail,
      required String? appKey,
      required String encAsymPvtKey}) {
    try {
      if (currentUserEmail == this.members[0]) {
        return aesHelper.decrypt(this.encSymKeyM0, appKey!);
      } else {
        final asymPvtKeyString = aesHelper.decrypt(encAsymPvtKey, appKey!);
        final asymPvtKey = rsaHelper.parsePrivateKeyFromPem(asymPvtKeyString);
        return rsaHelper.decrypt(this.encSymKeyM1, asymPvtKey);
      }
    } catch (e, st) {
      log("${e.toString()} \n ${st.toString()}");
      return null;
    }
  }
}
