import 'dart:async';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:decentralized_encrypted_chat/models/message.dart';
import 'package:decentralized_encrypted_chat/service/data.dart' as data;
import 'package:decentralized_encrypted_chat/utils/aes_helper.dart'
    as aesHelper;

class MessageProvider {
  final _streamController = StreamController<List<Message>?>();

  get messageStream => _streamController.stream;

  void getAllMessages(String docId) {
    data.getAllMessagesQuerySnapShot(docId).listen((event) {
      _streamController
          .add(event.docs.map((e) => Message.fromJson(e.data())).toList());
    }).onError((e, st) {
      log("${e.toString()} \n ${st.toString()}");
    });
  }

  Future<bool> sendMessage(
      {required String plainMessage,
      required String? symKey,
      required String from,
      required String documentId}) async {
    try {
      final Message message = Message(
          encMsg: aesHelper.encrypt(plainMessage, symKey!)!,
          timestamp: Timestamp.now(),
          from: from);
      final res = await data.sendMessage(message.toJson(), documentId);
      if (res) {
        await data.setLastMessage(message.encMsg, documentId);
      }
      return res;
    } catch (e, st) {
      log("${e.toString()} \n ${st.toString()}");
      return false;
    }
  }

  void dispose() {
    _streamController.close();
  }
}
