import 'dart:convert';

import 'package:crypto/crypto.dart' as crypto;
import 'package:encrypt/encrypt.dart' as en;

String? symmetricEncrypt(String message, String appKey) {
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
    print("encrypt ${e.toString()}");
    return null;
  }
}
