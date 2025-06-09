import 'package:encrypt/encrypt.dart';

class EncryptionService {
  final _key = Key.fromUtf8('my32lengthsupersecretnooneknows1'); // 32 chars
  final _iv = IV.fromLength(16);

  String encrypt(String text) {
    final encrypter = Encrypter(AES(_key));
    final encrypted = encrypter.encrypt(text, iv: _iv);
    return encrypted.base64;
  }

  String decrypt(String encryptedText) {
    final encrypter = Encrypter(AES(_key));
    final decrypted = encrypter.decrypt64(encryptedText, iv: _iv);
    return decrypted;
  }
}
