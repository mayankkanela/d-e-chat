import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:decentralized_encrypted_chat/service/auth.dart' as Auth;
import 'package:decentralized_encrypted_chat/utils/constants.dart';
import 'package:flutter/cupertino.dart';

FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

/// Method to sign up user in firebase auth,
/// then add the user data to a document in firestore
Future<DocumentSnapshot?> completeSignUp(
    {required String email,
    required String password,
    required String encSymAppKey,
    required String encAsymPvtKey,
    required String asymPubKey}) async {
  try {
    //firebase auth
    final user = await Auth.signUpWithEmailAndPassword(email, password);
    //user with all appended data added in the collection
    if (user != null) {
      final Map<String, dynamic> data = {
        "userId": user.uid,
        "email": email,
        "encSymAppKey": encSymAppKey,
        "encAsymPvtKey": encAsymPvtKey,
        "asymPubKey": asymPubKey
      };

      await _firebaseFirestore
          .collection(Constants.USERS)
          .doc(user.uid)
          .set(data)
          .then((value) => debugPrint("user added"));
      final DocumentSnapshot result = await _firebaseFirestore
          .collection(Constants.USERS)
          .doc(user.uid)
          .get();
      debugPrint(result.data().toString());
      return result;
    }
  } catch (e) {
    debugPrint("completeSignUp: ${e.toString()}");
    return null;
  }
}
