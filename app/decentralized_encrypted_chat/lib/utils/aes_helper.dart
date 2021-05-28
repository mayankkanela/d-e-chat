import 'dart:convert';
import 'dart:developer' as dev;
import 'dart:math';

import 'package:crypto/crypto.dart' as crypto;
import 'package:encrypt/encrypt.dart' as en;

import 'constants.dart';

String? encrypt(String message, String appKey) {
  try {
    final content = Utf8Encoder().convert(appKey);
    final md5 = crypto.md5;
    final digest = md5.convert(content);
    final md5Key = en.Key.fromUtf8(digest.toString());
    final iv = en.IV.fromLength(16);
    final encrypt = en.Encrypter(en.AES(md5Key));
    final encrypted = encrypt.encrypt(message, iv: iv);
    return encrypted.base64;
  } catch (e) {
    dev.log("encrypt ${e.toString()}");
    return null;
  }
}

String? decrypt(String encryptedText, String key) {
  try {
    final content = Utf8Encoder().convert(key);
    final md5 = crypto.md5;
    final digest = md5.convert(content);
    final md5Key = en.Key.fromUtf8(digest.toString());
    final iv = en.IV.fromLength(16);
    final encrypter = en.Encrypter(en.AES(md5Key));

    final decrypted = encrypter.decrypt64(encryptedText, iv: iv);
    return decrypted;
  } catch (e) {
    dev.log("aes_helper.dart-encrypt ${e.toString()}");
    return null;
  }
}

String generateSymmetricKey(int length) {
  String pass = '';
  Random random = new Random();
  while (length > 0) {
    int i = random.nextInt(Constants.VECTORS.length);
    pass = pass +
        Constants.VECTORS[i][random.nextInt(Constants.VECTORS[i].length)];
    length--;
  }
  return pass;
}
