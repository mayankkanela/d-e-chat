import 'dart:async';
import 'dart:developer';

import 'package:decentralized_encrypted_chat/models/chat.dart';
import 'package:decentralized_encrypted_chat/models/current_user.dart';
import 'package:decentralized_encrypted_chat/service/data.dart' as data;

class ChatModel {
  static final _streamController = StreamController<List<Chat>?>();

  static get stream => _streamController.stream;

  static void getAllChats(String emailId) {
    // data.getAllChatsQuerySnapShot(userId).listen((event) {
    //   log("data changes: ${event.docChanges.length}");
    //   if (_chats.isEmpty) {
    //     _chats = event.docs.map((e) => Chat.fromJSON(e.data())).toList();
    //   }
    //   else{
    //     event.docChanges.forEach((element) {
    //       if(element.doc.data() != null){
    //         _chats[element.oldIndex] = Chat.fromJSON(element.doc.data()!);}
    //     });
    //   }
    // });
    data.getAllChatsQuerySnapShot(emailId).listen((event) {
      _streamController
          .add(event.docs.map((e) => Chat.fromJSON(e.data())).toList());
    }).onError((e, st) {
      log("${e.toString()} \n ${st.toString()}");
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

  static void dispose() {
    _streamController.close();
  }
}
