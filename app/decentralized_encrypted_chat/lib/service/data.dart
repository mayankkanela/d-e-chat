import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:decentralized_encrypted_chat/service/auth.dart' as Auth;
import 'package:decentralized_encrypted_chat/utils/constants.dart';
import 'package:flutter/cupertino.dart';

FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

Future<DocumentSnapshot?> completeSignUp(String email, String password,
    String encAppKey, String encPvtKey, String encPublicKey) async {
  final user = await Auth.signUpWithEmailAndPassword(email, password);
  if (user != null) {
    final Map<String, dynamic> data = {"userId": user.uid, "email": email};
    await _firebaseFirestore
        .collection(Constants.USERS)
        .doc(user.uid)
        .set(data)
        .then((value) => debugPrint("user added"));
    final DocumentSnapshot result = await _firebaseFirestore
        .collection(Constants.USERS)
        .doc(user.uid)
        .get();

    return result;
  }
  return null;
}
