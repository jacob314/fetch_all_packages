library aes_cbc;

import 'dart:typed_data';
import 'dart:convert';
import 'package:pointycastle/export.dart';

class AesCBC {
  generateIV(String message) async {
    var iv = new Digest("SHA-256").process(utf8.encode(message)).sublist(0, 16);
    return iv;
  }

  generateParams(Uint8List key, Uint8List iv) async {
    CipherParameters params = new PaddedBlockCipherParameters(
        new ParametersWithIV(new KeyParameter(key), iv), null);
    return params;
  }

  doAESEncrypt(String message, Uint8List key, Uint8List iv) async {
    var params = await generateParams(key, iv);
    BlockCipher encryptionCipher = new PaddedBlockCipher("AES/CBC/PKCS7");
    encryptionCipher.init(true, params);
    Uint8List encrypted = encryptionCipher.process(utf8.encode(message));
    return base64.encode(encrypted);
  }

  doAESDecrypt(Uint8List key, Uint8List iv, Uint8List encrypted) async {
    var params = await generateParams(key, iv);
    BlockCipher decryptionCipher = new PaddedBlockCipher("AES/CBC/PKCS7");
    decryptionCipher.init(false, params);
    String decrypted = utf8.decode(decryptionCipher.process(encrypted));
    return decrypted;
  }
}
