import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:decentralized_encrypted_chat/models/current_user.dart';
import 'package:decentralized_encrypted_chat/service/auth.dart' as auth;
import 'package:decentralized_encrypted_chat/service/data.dart' as data;
import 'package:decentralized_encrypted_chat/utils/encrypt.dart' as encrypt;
import 'package:decentralized_encrypted_chat/utils/rsa_pem_util.dart';
import 'package:decentralized_encrypted_chat/utils/utility.dart' as util;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:pointycastle/asymmetric/api.dart';

class UserProvider with ChangeNotifier {
  User? _user;
  CurrentUser? _currentUser;
  String? _appKey;
  CurrentUser? get currentUser => _currentUser;

  Future<bool> getCurrentUser() async {
    _user = await auth.getUser();
    if (_user == null)
      return false;
    else
      return true;
  }

  /// Sign In user with email and password, use this method in ui
  Future<bool> signInWithEmailPassword(String email, String password) async {
    _user = await auth.signInEmailAndPassword(email, password);
    if (_user != null)
      return true;
    else
      return false;
  }

  /// Signs up user with email password, symmetric key entered by user is required
  Future<bool> signUpWithEmailPassword(
      String email, String password, String symKey) async {
    //App key, refer white paper
    final String? encSymAppKey =
        encrypt.symmetricEncrypt(util.generate(8), symKey);

    //asymmetric key gen
    final keyPair = RsaKeyHelper().generateKeyPair();
    final String? asymPubKey =
        RsaKeyHelper().encodePublicKeyToPem(keyPair.publicKey);
    final String? encAsymPvtKey = _getEncPvtKey(symKey, keyPair.privateKey);

    // getting data
    if (encSymAppKey != null && encAsymPvtKey != null && asymPubKey != null) {
      final DocumentSnapshot? documentSnapshot = await data.completeSignUp(
          email: email,
          password: password,
          encSymAppKey: encSymAppKey,
          encAsymPvtKey: encAsymPvtKey,
          asymPubKey: asymPubKey);
      if (documentSnapshot != null && documentSnapshot.exists) {
        try {
          _currentUser = CurrentUser.fromJson(documentSnapshot.data()!);
        } catch (e) {
          debugPrint(
              "user-provider-signUpWithEmailPassword: \n ${e.toString()}");
          return false;
        }
      }
      if (_currentUser != null) return true;
    }
    return false;
  }

  String? _getEncPvtKey(String symKey, RSAPrivateKey privateKey) {
    final rsaPvtKey = RsaKeyHelper().encodePrivateKeyToPem(privateKey);
    return encrypt.symmetricEncrypt(rsaPvtKey, symKey);
  }
}
