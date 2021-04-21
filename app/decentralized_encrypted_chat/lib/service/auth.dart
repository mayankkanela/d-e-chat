import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

FirebaseAuth _auth = FirebaseAuth.instance;

Future<User?> getUser() async {
  return await _auth.currentUser;
}

Future<User?> signInEmailAndPassword(String email, String password) async {
  try {
    UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email, password: password);
    User? user = userCredential.user;
    return user;
  } catch (e) {
    debugPrint("auth:");
    debugPrint(e.toString());
    return null;
  }
}

Future<User?> signUpWithEmailAndPassword(String email, String password) async {
  try {
    UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email, password: password);
    debugPrint(userCredential.user.toString());
    return userCredential.user;
  } catch (e) {
    debugPrint("auth:");
    debugPrint(e.toString());
    return null;
  }
}
