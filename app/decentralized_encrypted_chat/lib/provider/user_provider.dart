import 'package:decentralized_encrypted_chat/service/auth.dart' as Auth;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

class UserProvider with ChangeNotifier {
  User? _user;

  Future<bool> getCurrentUser() async {
    _user = await Auth.getUser();
    if (_user == null)
      return false;
    else
      return true;
  }

  Future<bool> signInWithEmailPassword(String email, String password) async {
    _user = await Auth.signInEmailAndPassword(email, password);
    if (_user != null)
      return true;
    else
      return false;
  }

  Future<bool> signUpWithEmailPassword(String email, String password) async {
    _user = await Auth.signUpWithEmailAndPassword(email, password);
    if (_user != null)
      return true;
    else
      return false;
  }
}
