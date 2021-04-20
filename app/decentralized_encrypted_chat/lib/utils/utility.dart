bool isNullOrEmpty(String? string) {
  if (string == null || string.isEmpty)
    return true;
  else
    return false;
}

Function(String) emptyOrNullStringValidator = (String value) {
  if (isNullOrEmpty(value)) {
    return "Cannot be empty!";
  } else
    return null;
};

//
// en.Encrypted encrypt(String plainText, String key) {
//   final content = Utf8Encoder().convert(key);
//   final md5 = crypto.md5;
//   final digest = md5.convert(content);
//   final md5Key = en.Key.fromUtf8(digest.toString());
//   final iv = en.IV.fromLength(16);
//   final encrypter = en.Encrypter(en.AES(md5Key));
//   final encrypted = encrypter.encrypt(plainText, iv: iv);
//   return encrypted;
// }
//
// String decrypt(String encryptedText, String key) {
//   final content = Utf8Encoder().convert(key);
//   final md5 = crypto.md5;
//   final digest = md5.convert(content);
//   final md5Key = en.Key.fromUtf8(digest.toString());
//   final iv = en.IV.fromLength(16);
//   final encrypter = en.Encrypter(en.AES(md5Key));
//   try {
//     final decrypted = encrypter.decrypt64(encryptedText, iv: iv);
//     return decrypted;
//   } catch (e) {}
//   return null;
//
//   // encrypter.decrypt(encryptedText, iv: iv);
// }
