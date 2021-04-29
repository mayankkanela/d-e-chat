import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';

import "package:asn1lib/asn1lib.dart";
import 'package:flutter/cupertino.dart';
import "package:pointycastle/api.dart";
import 'package:pointycastle/asymmetric/api.dart';
import 'package:pointycastle/asymmetric/rsa.dart';
import 'package:pointycastle/key_generators/api.dart';
import 'package:pointycastle/key_generators/rsa_key_generator.dart';
import 'package:pointycastle/random/fortuna_random.dart';

List<int> decodePEM(String pem) {
  var startsWith = [
    "-----BEGIN PUBLIC KEY-----",
    "-----BEGIN PRIVATE KEY-----",
    "-----BEGIN PGP PUBLIC KEY BLOCK-----\r\nVersion: React-Native-OpenPGP.js 0.1\r\nComment: http://openpgpjs.org\r\n\r\n",
    "-----BEGIN PGP PRIVATE KEY BLOCK-----\r\nVersion: React-Native-OpenPGP.js 0.1\r\nComment: http://openpgpjs.org\r\n\r\n",
  ];
  var endsWith = [
    "-----END PUBLIC KEY-----",
    "-----END PRIVATE KEY-----",
    "-----END PGP PUBLIC KEY BLOCK-----",
    "-----END PGP PRIVATE KEY BLOCK-----",
  ];
  bool isOpenPgp = pem.indexOf('BEGIN PGP') != -1;

  for (String s in startsWith) {
    if (pem.startsWith(s)) {
      pem = pem.substring(s.length);
    }
  }

  for (String s in endsWith) {
    if (pem.endsWith(s)) {
      pem = pem.substring(0, pem.length - s.length);
    }
  }

  if (isOpenPgp) {
    final index = pem.indexOf('\r\n');
    pem = pem.substring(0, index);
  }

  pem = pem.replaceAll('\n', '');
  pem = pem.replaceAll('\r', '');

  return base64.decode(pem);
}

class RsaKeyHelper {
  AsymmetricKeyPair<RSAPublicKey, RSAPrivateKey> generateKeyPair() {
    final keyParams =
        RSAKeyGeneratorParameters(BigInt.parse('65537'), 2048, 12);

    final secureRandom = FortunaRandom();
    final random = Random.secure();
    List<int> seeds = [];
    for (int i = 0; i < 32; i++) {
      seeds.add(random.nextInt(255));
    }
    secureRandom.seed(KeyParameter(Uint8List.fromList(seeds)));

    final rngParams = ParametersWithRandom(keyParams, secureRandom);
    final k = RSAKeyGenerator();
    k.init(rngParams);

    final pair = k.generateKeyPair();

    final myPublic = pair.publicKey as RSAPublicKey;
    final myPrivate = pair.privateKey as RSAPrivateKey;
    return AsymmetricKeyPair<RSAPublicKey, RSAPrivateKey>(myPublic, myPrivate);
  }

  String encrypt(String plaintext, RSAPublicKey publicKey) {
    final cipher = RSAEngine()
      ..init(true, PublicKeyParameter<RSAPublicKey>(publicKey));
    final cipherText = cipher.process(Uint8List.fromList(plaintext.codeUnits));

    return String.fromCharCodes(cipherText);
  }

  String decrypt(String cipherText, RSAPrivateKey privateKey) {
    final cipher = RSAEngine()
      ..init(false, PrivateKeyParameter<RSAPrivateKey>(privateKey));
    final decrypted = cipher.process(Uint8List.fromList(cipherText.codeUnits));

    return String.fromCharCodes(decrypted);
  }

  parsePublicKeyFromPem(pemString) {
    List<int> publicKeyDER = decodePEM(pemString);
    final asn1Parser = ASN1Parser(publicKeyDER as Uint8List);
    final topLevelSeq = asn1Parser.nextObject() as ASN1Sequence;
    final publicKeyBitString = topLevelSeq.elements[1];

    final publicKeyAsn = ASN1Parser(publicKeyBitString.contentBytes()!);
    final ASN1Sequence publicKeySeq = publicKeyAsn.nextObject() as ASN1Sequence;
    final modulus = publicKeySeq.elements[0] as ASN1Integer;
    final exponent = publicKeySeq.elements[1] as ASN1Integer;

    RSAPublicKey rsaPublicKey =
        RSAPublicKey(modulus.valueAsBigInteger!, exponent.valueAsBigInteger!);

    return rsaPublicKey;
  }

  parsePrivateKeyFromPem(pemString) {
    List<int> privateKeyDER = decodePEM(pemString);
    var asn1Parser = ASN1Parser(privateKeyDER as Uint8List);
    final topLevelSeq = asn1Parser.nextObject() as ASN1Sequence;
    var version = topLevelSeq.elements[0];
    final algorithm = topLevelSeq.elements[1];
    final privateKey = topLevelSeq.elements[2];

    asn1Parser = ASN1Parser(privateKey.contentBytes()!);
    var pkSeq = asn1Parser.nextObject() as ASN1Sequence;

    version = pkSeq.elements[0];
    final modulus = pkSeq.elements[1] as ASN1Integer;
    final publicExponent = pkSeq.elements[2] as ASN1Integer;
    final privateExponent = pkSeq.elements[3] as ASN1Integer;
    final p = pkSeq.elements[4] as ASN1Integer;
    final q = pkSeq.elements[5] as ASN1Integer;
    final exp1 = pkSeq.elements[6] as ASN1Integer;
    final exp2 = pkSeq.elements[7] as ASN1Integer;
    final co = pkSeq.elements[8] as ASN1Integer;

    RSAPrivateKey rsaPrivateKey = RSAPrivateKey(
        modulus.valueAsBigInteger!,
        privateExponent.valueAsBigInteger!,
        p.valueAsBigInteger,
        q.valueAsBigInteger);

    return rsaPrivateKey;
  }

  String? encodePublicKeyToPem(RSAPublicKey publicKey) {
    try {
      var algorithmSeq = new ASN1Sequence();
      var algorithmAsn1Obj = new ASN1Object.fromBytes(Uint8List.fromList(
          [0x6, 0x9, 0x2a, 0x86, 0x48, 0x86, 0xf7, 0xd, 0x1, 0x1, 0x1]));
      var paramsAsn1Obj =
          new ASN1Object.fromBytes(Uint8List.fromList([0x5, 0x0]));
      algorithmSeq.add(algorithmAsn1Obj);
      algorithmSeq.add(paramsAsn1Obj);

      var publicKeySeq = new ASN1Sequence();
      publicKeySeq.add(ASN1Integer(publicKey.modulus!));
      publicKeySeq.add(ASN1Integer(publicKey.exponent!));
      var publicKeySeqBitString =
          new ASN1BitString(Uint8List.fromList(publicKeySeq.encodedBytes));

      var topLevelSeq = new ASN1Sequence();
      topLevelSeq.add(algorithmSeq);
      topLevelSeq.add(publicKeySeqBitString);
      var dataBase64 = base64.encode(topLevelSeq.encodedBytes);

      return "$dataBase64";
    } catch (e) {
      debugPrint("encodePublicKeyToPem \n ${e.toString()}");
      return null;
    }
  }

  encodePrivateKeyToPem(RSAPrivateKey privateKey) {
    var version = ASN1Integer(BigInt.from(0));

    var algorithmSeq = new ASN1Sequence();
    var algorithmAsn1Obj = new ASN1Object.fromBytes(Uint8List.fromList(
        [0x6, 0x9, 0x2a, 0x86, 0x48, 0x86, 0xf7, 0xd, 0x1, 0x1, 0x1]));
    var paramsAsn1Obj =
        new ASN1Object.fromBytes(Uint8List.fromList([0x5, 0x0]));
    algorithmSeq.add(algorithmAsn1Obj);
    algorithmSeq.add(paramsAsn1Obj);

    var privateKeySeq = new ASN1Sequence();
    var modulus = ASN1Integer(privateKey.n!);
    var publicExponent = ASN1Integer(BigInt.parse('65537'));
    var privateExponent = ASN1Integer(privateKey.privateExponent!);
    var p = ASN1Integer(privateKey.p!);
    var q = ASN1Integer(privateKey.q!);
    var dP = privateKey.privateExponent! % (privateKey.p! - BigInt.from(1));
    var exp1 = ASN1Integer(dP);
    var dQ = privateKey.privateExponent! % (privateKey.q! - BigInt.from(1));
    var exp2 = ASN1Integer(dQ);
    var iQ = privateKey.q!.modInverse(privateKey.p!);
    var co = ASN1Integer(iQ);

    privateKeySeq.add(version);
    privateKeySeq.add(modulus);
    privateKeySeq.add(publicExponent);
    privateKeySeq.add(privateExponent);
    privateKeySeq.add(p);
    privateKeySeq.add(q);
    privateKeySeq.add(exp1);
    privateKeySeq.add(exp2);
    privateKeySeq.add(co);
    var publicKeySeqOctetString =
        new ASN1OctetString(Uint8List.fromList(privateKeySeq.encodedBytes));

    var topLevelSeq = new ASN1Sequence();
    topLevelSeq.add(version);
    topLevelSeq.add(algorithmSeq);
    topLevelSeq.add(publicKeySeqOctetString);
    var dataBase64 = base64.encode(topLevelSeq.encodedBytes);

    return "$dataBase64";
  }
}
