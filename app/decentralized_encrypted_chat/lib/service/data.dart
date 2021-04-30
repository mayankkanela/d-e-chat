import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:decentralized_encrypted_chat/service/auth.dart' as auth;
import 'package:decentralized_encrypted_chat/utils/constants.dart';
import 'package:flutter/cupertino.dart';

FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

/// Method to sign up user in firebase auth,then add the user data to a document
/// in firestore and returns doc snapshot with user data.
Future<DocumentSnapshot?> completeSignUpGetUserDocument(
    {required String email,
    required String password,
    required String encSymAppKey,
    required String encAsymPvtKey,
    required String asymPubKey}) async {
  try {
    //firebase auth
    final user = await auth.signUpWithEmailAndPassword(email, password);
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
    } else {
      return null;
    }
  } catch (e) {
    debugPrint(
        "service/data.dart-completeSignUpGetUserDocument: \n ${e.toString()}");
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
      debugPrint("servicce/data.dart-SignIn: \n ${documentSnapshot?.data()}");
      return documentSnapshot;
    } else {
      return null;
    }
  } catch (e) {
    debugPrint("service/data.dart-signInGetUserDocument: \n ${e.toString()}");
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
      debugPrint("${documentSnapshot?.data()}");
      return documentSnapshot;
    }
  } catch (e) {
    debugPrint("service/data.dart-getCurrentUser(): \n ${e.toString()}");
    return null;
  }
}
