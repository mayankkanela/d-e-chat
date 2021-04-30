import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

FirebaseAuth _auth = FirebaseAuth.instance;

/// Don't Use this in ui, only in viewModels.
Future<User?> getUser() async {
  return await _auth.currentUser;
}

/// Initial sign-in to check if user exists in firebase auth
/// use signIn method in data.dart for final signIn.
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

/// Don't Use this in ui, only in viewModels.
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
