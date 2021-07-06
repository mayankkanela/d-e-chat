import 'dart:developer';

import 'package:decentralized_encrypted_chat/utils/aes_helper.dart'
    as aesHelper;
import 'package:decentralized_encrypted_chat/utils/rsa_pem_helper.dart'
    as rsaHelper;

enum Status { initiator, admin, unprivileged }

class Chat {
  static const MEMBERS = "members";
  static const LAST_MESSAGE = "lastMessage";
  static const GROUP_NAME = "groupName";
  static const KEYS = "keys";
  static const STATUSES = "status";

  final List<String> members;
  final Status status;
  final Map<String, String> keys;
  final Map<String, int> statuses;
  final String encKey;
  final String? groupName;
  final String lastMessage;
  final String docId;

  Chat({required this.encKey,
      required this.groupName,
      required this.members,
      required this.status,
      required this.lastMessage,
      required this.docId,
      required this.statuses,
      required this.keys});

  factory Chat.fromJSON(
      Map<String, dynamic> json, String docId, String cEmail) {
    final List<String> members = List.castFrom(json[MEMBERS]);
    final Map<String, String> keys = Map<String, String>.from(json[KEYS]);
    final Map<String, int> statuses = Map<String, int>.from(json[STATUSES]);

    return Chat(
        members: members,
        lastMessage: json[LAST_MESSAGE],
        docId: docId,
        statuses: statuses,
        keys: keys,
        groupName: json[GROUP_NAME],
        encKey: keys[cEmail]!,
        status: Status.values[statuses[cEmail]!]);
  }

  String getReceiverId(String currentUserEmail) {
    return currentUserEmail == members[0] ? members[1] : members[0];
  }

  String getDecryptLastMessage(String? chatKey) {
    try {
      return aesHelper.decrypt(lastMessage, chatKey!)!;
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
      if (status == Status.initiator) {
        return aesHelper.decrypt(encKey, appKey!);
      } else {
        final asymPvtKeyString = aesHelper.decrypt(encAsymPvtKey, appKey!);
        final asymPvtKey = rsaHelper.parsePrivateKeyFromPem(asymPvtKeyString);
        return rsaHelper.decrypt(encKey, asymPvtKey);
      }
    } catch (e, st) {
      log("${e.toString()} \n ${st.toString()}");
      return null;
    }
  }
}
