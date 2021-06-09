import 'dart:async';
import 'dart:developer';

import 'package:decentralized_encrypted_chat/models/chat.dart';
import 'package:decentralized_encrypted_chat/models/current_user.dart';
import 'package:decentralized_encrypted_chat/service/data.dart' as data;

class ChatProvider {
  ChatProvider({required String email}) {
    _getAllChats(email);
  }
  late final _streamController = StreamController<List<Chat>>();

  get stream => _streamController.stream;

  void _getAllChats(String emailId) {
    data.getAllChatsQuerySnapShot(emailId).listen((event) {
      _streamController
          .add(event.docs.map((e) => Chat.fromJSON(e.data(), e.id)).toList());
    }).onError((e, st) {
      log("_getAllChats: ${e.toString()} \n ${st.toString()}");
    });
  }

  static Future<bool> addNewContact(
      {required CurrentUser currentUser,
      required String contactEmail,
      required String appKey}) async {
    try {
      data.addNewContactDocumentSnapshot(
          currentUser: currentUser,
          contactEmail: contactEmail,
          appKey: appKey,
          alreadyAdded: false);
      return true;
    } catch (e) {
      log("addNewContact ${e.toString()}");
      return false;
    }
  }

  void dispose() {
    _streamController.close();
  }
}
