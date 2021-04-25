import 'package:decentralized_encrypted_chat/service/auth.dart' as auth;
import 'package:decentralized_encrypted_chat/utils/encrypt.dart' as encrypt;
import 'package:decentralized_encrypted_chat/utils/rsa_pem_util.dart';
import 'package:decentralized_encrypted_chat/utils/utility.dart' as util;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

class UserProvider with ChangeNotifier {
  User? _user;

  Future<bool> getCurrentUser() async {
    _user = await auth.getUser();
    if (_user == null)
      return false;
    else
      return true;
  }

  Future<bool> signInWithEmailPassword(String email, String password) async {
    _user = await auth.signInEmailAndPassword(email, password);
    if (_user != null)
      return true;
    else
      return false;
  }

  Future<bool> signUpWithEmailPassword(
      String email, String password, String pvtKey) async {
    {
      final String? encAppKey =
          encrypt.symmetricEncrypt(util.generate(8), pvtKey);
      final keyPair = RsaKeyHelper().generateKeyPair();
      final String privateKey =
          RsaKeyHelper().encodePrivateKeyToPem(keyPair.privateKey);
      return false;
      // if (encAppKey != null)
      //   await data.completeSignUp(
      //       email, password, encAppKey, "encPvtKey", "encPublicKey");
      // if (_user != null)
      //   return true;
      // else
      //   return false;
    }
  }
}
