import 'dart:math';

import 'package:flutter/cupertino.dart';

import 'constants.dart';

bool isNullOrEmpty(String? string) {
  if (string == null || string.isEmpty)
    return true;
  else
    return false;
}

String? emptyOrNullStringValidator(String? value) {
  if (isNullOrEmpty(value)) {
    return "Cannot be empty!";
  } else
    return null;
}

String? confirmPasswordValidator(String? value1, String? value2) {
  final val = isNullOrEmpty(value1);
  if (val)
    return null;
  else if (value1 != value2) {
    return "Passwords do not match!";
  } else
    return null;
}

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
String generate(int length) {
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

Future<void> pushNamedReplacement(
    {required BuildContext context, required String path}) async {
  await Navigator.of(context).pushReplacementNamed(path);
}

Future<void> pushNamed(
    {required BuildContext context, required String path}) async {
  await Navigator.of(context).pushNamed(path);
}
// AsymmetricKeyPair<RSAPublicKey, RSAPrivateKey> generateRSAkeyPair(
//     SecureRandom secureRandom,
//     {int bitLength = 2048}) {
// Create an RSA key generator and initialize it

// final keyGen = RSAKeyGenerator()
//   ..init(ParametersWithRandom(
//       RSAKeyGeneratorParameters(BigInt.parse('65537'), bitLength, 64),
//       secureRandom));
//
// // Use the generator
//
// final pair = keyGen.generateKeyPair();
//
// // Cast the generated key pair into the RSA key types
//
// final myPublic = pair.publicKey as RSAPublicKey;
// final myPrivate = pair.privateKey as RSAPrivateKey;
//
// return AsymmetricKeyPair<RSAPublicKey, RSAPrivateKey>(myPublic, myPrivate);
// }
//
// SecureRandom genSecureRandom() {
//   final secureRandom = FortunaRandom();
//
//   final seedSource = Random.secure();
//   final seeds = <int>[];
//   for (int i = 0; i < 32; i++) {
//     seeds.add(seedSource.nextInt(255));
//   }
//   secureRandom.seed(KeyParameter(Uint8List.fromList(seeds)));
//
//   return secureRandom;
// }
