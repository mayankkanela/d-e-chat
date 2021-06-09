import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:decentralized_encrypted_chat/utils/aes_helper.dart'
    as aesHelper;

class Message {
  static const ENC_MSG = "encMsg";
  static const TIMESTAMP = "timestamp";
  static const FROM = "from";

  final String encMsg;
  final Timestamp timestamp;
  final String from;
  Message({required this.encMsg, required this.timestamp, required this.from});

  factory Message.fromJson(Map<String, dynamic> json) {
    final timestamp = json[TIMESTAMP] as Timestamp;
    return Message(
        encMsg: json[ENC_MSG], timestamp: timestamp, from: json[FROM]);
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{ENC_MSG: encMsg, TIMESTAMP: timestamp, FROM: from};
  }

  String decrypted({required String? symKey}) {
    final msg = aesHelper.decrypt(this.encMsg, symKey!);
    return msg ?? "UNABLE_TO_DECRYPT";
  }

  String getTime() {
    return "${timestamp.toDate().hour}:${timestamp.toDate().minute}";
  }
}
