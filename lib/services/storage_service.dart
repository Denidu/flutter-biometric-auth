import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class StorageService {
  final _storage = const FlutterSecureStorage();

  Future<void> saveNote(String id, String encryptedNote) async {
    await _storage.write(key: id, value: encryptedNote);
  }

  Future<String?> getNote(String id) async {
    return await _storage.read(key: id);
  }

  Future<void> deleteNote(String id) async {
    await _storage.delete(key: id);
  }

  Future<Map<String, String>> getAllNotes() async {
    return await _storage.readAll();
  }

  Future<void> clearAll() async {
    await _storage.deleteAll();
  }
}
