import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:decentralized_encrypted_chat/models/chat.dart';
import 'package:decentralized_encrypted_chat/models/current_user.dart';
import 'package:decentralized_encrypted_chat/service/auth.dart' as auth;
import 'package:decentralized_encrypted_chat/utils/aes_helper.dart'
    as aesHelper;
import 'package:decentralized_encrypted_chat/utils/constants.dart';
import 'package:decentralized_encrypted_chat/utils/rsa_pem_helper.dart'
    as rsaHelper;

FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

/// Method to sign up user in firebase auth,then add the user data to a document
/// in firestore and returns doc snapshot with user data.
Future<DocumentSnapshot?> completeSignUpGetUserDocument({
  required String email,
  required String password,
  required String encAsymPvtKey,
  required String asymPubKey,
  required String encSymAppKey,
}) async {
  try {
    //firebase auth
    final user = await auth.signUpWithEmailAndPassword(email, password);
    //user with all appended data added in the collection
    if (user != null) {
      final Map<String, dynamic> data = {
        CurrentUser.USER_ID: user.uid,
        CurrentUser.EMAIL: email,
        CurrentUser.ENC_ASYM_PVT_KEY: encAsymPvtKey,
        CurrentUser.ASYM_PUB_KEY: asymPubKey,
        CurrentUser.ENC_SYM_APP_KEY: encSymAppKey,
      };

      await _firebaseFirestore
          .collection(Constants.USERS)
          .doc(user.uid)
          .set(data)
          .then((value) => log("user added"));
      final DocumentSnapshot result = await _firebaseFirestore
          .collection(Constants.USERS)
          .doc(user.uid)
          .get();

      log(result.data().toString());
      return result;
    } else {
      return null;
    }
  } catch (e) {
    log("service/data.dart-completeSignUpGetUserDocument: \n ${e.toString()}");
    return null;
  }
}

/// Use this method to signIn user with email and password instead of method
/// in auth.dart, signsIn user and returns doc snapshot with user data.
Future<DocumentSnapshot?> signInGetUserDocument(
    {required String email, required String password}) async {
  try {
    final user = await auth.signInEmailAndPassword(email, password);
    if (user != null) {
      final DocumentSnapshot? documentSnapshot = await _firebaseFirestore
          .collection(Constants.USERS)
          .doc(user.uid)
          .get();
      log("servicce/data.dart-SignIn: \n ${documentSnapshot?.data()}");
      return documentSnapshot;
    } else {
      return null;
    }
  } catch (e) {
    log("service/data.dart-signInGetUserDocument: \n ${e.toString()}");
    return null;
  }
}

/// Gets user from cache and then send request to get user document and returns
/// doc snapshot with user data.
Future<DocumentSnapshot?> getCurrentUserDocument() async {
  try {
    final user = await auth.getUser();
    if (user != null) {
      final DocumentSnapshot? documentSnapshot = await _firebaseFirestore
          .collection(Constants.USERS)
          .doc(user.uid)
          .get();
      log("getCurrentUserDocument: ${documentSnapshot?.data()}");
      return documentSnapshot;
    }
  } catch (e) {
    log("service/data.dart-getCurrentUser(): \n ${e.toString()}");
    return null;
  }
}

/// Get All the chats of the user,the docId is userId and this consists of a
/// sub-collection which contain(s) document(s) which in turn have all the user
/// chat related data, each chat is different document to make updating of
/// chats easy and reduce query time.
Stream<QuerySnapshot> getAllChatsQuerySnapShot(String email) {
  final Stream<QuerySnapshot> stream = _firebaseFirestore
      .collection(Constants.CHATS)
      .where(Chat.MEMBERS, arrayContains: email)
      .snapshots();
  return stream;
}

/// Function to add a new contact, a document is added to the chats
/// collection against the current user document.

Future<bool> addNewContactDocumentSnapshot(
    {required CurrentUser currentUser,
    required String contactEmail,
    required String appKey,
    required bool alreadyAdded}) async {
  try {
    final String chatKey = aesHelper.generateSymmetricKey(8);
    final String encSymKeyP0 = aesHelper.encrypt(chatKey, appKey)!;
    final receiverDoc = await _firebaseFirestore
        .collection(Constants.USERS)
        .where(CurrentUser.EMAIL, isEqualTo: contactEmail)
        .limit(1)
        .get();
    final String receiverPubKey = receiverDoc.docs.first["asymPubKey"];

    final String encSymKeyP1 = rsaHelper.encrypt(
        chatKey, rsaHelper.parsePublicKeyFromPem(receiverPubKey));
    final String receiverEmail = receiverDoc.docs.first["email"];
    final Map<String, dynamic> data = {};
    data[Chat.MEMBERS] = [currentUser.email, receiverEmail];
    data[Chat.ENC_SYM_KEY_M0] = encSymKeyP0;
    data[Chat.ENC_SYM_KEY_M1] = encSymKeyP1;
    data[Chat.M1_INIT] = true;
    _firebaseFirestore
        .collection(Constants.CHATS)
        .doc()
        .set(data)
        .then((value) => log("Contact added"));
    return true;
  } catch (e, stacktrace) {
    log("${e.toString()}");
    log("${stacktrace.toString()}");
    return false;
  }
}
