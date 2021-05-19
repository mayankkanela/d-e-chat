import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:decentralized_encrypted_chat/models/current_user.dart';
import 'package:decentralized_encrypted_chat/service/data.dart' as data;
import 'package:decentralized_encrypted_chat/utils/aes_helper.dart'
    as aesHelper;
import 'package:decentralized_encrypted_chat/utils/rsa_pem_helper.dart'
    as rsaPemHelper;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pointycastle/asymmetric/api.dart';

class UserProvider with ChangeNotifier {
  /// This is the user obj with all the keys.
  CurrentUser? _currentUser;

  CurrentUser? get currentUser => _currentUser;

  /// Used to encrypt and decrypt and make sure not empty.
  String? _appKey;

  /// get [_appKey]
  String? get appKey => _appKey;

  bool decryptAppKey({required String key}) {
    try {
      final appKey = aesHelper.decrypt(_currentUser!.encSymAppKey, key);
      this._appKey = appKey;
      return true;
    } catch (e) {
      debugPrint("decryptAppKey ${e.toString()}");
      return false;
    }
  }

  /// Fetch current user from the firebase database to use it further.
  Future<bool> getCurrentUser() async {
    final DocumentSnapshot? documentSnapshot =
        await data.getCurrentUserDocument();
    if (documentSnapshot != null &&
        documentSnapshot.exists &&
        documentSnapshot.data() != null) {
      try {
        _currentUser = CurrentUser.fromJson(documentSnapshot.data()!);
        debugPrint(_currentUser!.encSymAppKey);
      } catch (e) {
        debugPrint("provider/user-provider-getCurrentUser: \n ${e.toString()}");
        return false;
      }
      if (_currentUser != null) return true;
    }
    return false;
  }

  /// Sign In user with email and password and remember to set property
  /// listen = false.
  Future<bool> signInWithEmailPassword(String email, String password) async {
    final DocumentSnapshot? documentSnapshot =
        await data.signInGetUserDocument(email: email, password: password);

    if (documentSnapshot != null &&
        documentSnapshot.exists &&
        documentSnapshot.data() != null) {
      try {
        _currentUser = CurrentUser.fromJson(documentSnapshot.data()!);
      } catch (e) {
        debugPrint(
            "provider/user-provider-signUpWithEmailPassword: \n ${e.toString()}");
        return false;
      }

      if (_currentUser != null) return true;
    }

    return false;
  }

  /// Signs up user with email password, symmetric key entered by user is
  /// required to enc and generate symmetric app key and asymmetric keys and
  /// remember to set property listen = false.
  Future<bool> signUpWithEmailPassword(
      String email, String password, String symKey) async {
    //App key, to have consistent size of encrypting key thus
    final String symAppKey = aesHelper.generateSymmetricKey(8);
    final String? encSymAppKey = aesHelper.encrypt(symAppKey, symKey);

    //asymmetric key gen
    final keyPair = rsaPemHelper.generateKeyPair();
    final String? asymPubKey =
        rsaPemHelper.encodePublicKeyToPem(keyPair.publicKey);
    final String? encAsymPvtKey = _getEncPvtKey(symKey, keyPair.privateKey);
    // getting data
    if (encSymAppKey != null && encAsymPvtKey != null && asymPubKey != null) {
      final DocumentSnapshot? documentSnapshot =
          await data.completeSignUpGetUserDocument(
              email: email,
              encSymAppKey: encSymAppKey,
              password: password,
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
    final rsaPvtKey = rsaPemHelper.encodePrivateKeyToPem(privateKey);
    return aesHelper.encrypt(rsaPvtKey, symKey);
  }
}
