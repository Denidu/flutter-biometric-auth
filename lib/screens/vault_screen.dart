import 'package:flutter/material.dart';
import '../services/storage_service.dart';
import '../services/encryption_service.dart';
import '../models/secure_note.dart';
import '../widgets/note_card.dart';
import 'login_screen.dart';

class VaultScreen extends StatefulWidget {
  const VaultScreen({super.key});

  @override
  State<VaultScreen> createState() => _VaultScreenState();
}

class _VaultScreenState extends State<VaultScreen> {
  final StorageService _storageService = StorageService();
  final EncryptionService _encryptionService = EncryptionService();
  final TextEditingController _controller = TextEditingController();

  List<SecureNote> _notes = [];

  @override
  void initState() {
    super.initState();
    _loadNotes();
  }

  Future<void> _loadNotes() async {
    final allData = await _storageService.getAllNotes();
    List<SecureNote> loaded = [];
    allData.forEach((key, encryptedValue) {
      final decrypted = _encryptionService.decrypt(encryptedValue);
      loaded.add(SecureNote(id: key, content: decrypted));
    });

    setState(() {
      _notes = loaded;
    });
  }

  Future<void> _addNote() async {
    final text = _controller.text.trim();
    if (text.isEmpty) return;
    final encrypted = _encryptionService.encrypt(text);
    final id = DateTime.now().millisecondsSinceEpoch.toString();

    await _storageService.saveNote(id, encrypted);
    _controller.clear();
    _loadNotes();
  }

  Future<void> _deleteNote(String id) async {
    await _storageService.deleteNote(id);
    _loadNotes();
  }

  Future<void> _logout() async {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const LoginScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SecureVault'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: _logout,
            tooltip: 'Logout',
          )
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: const InputDecoration(
                      hintText: 'Add new secure note',
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: _addNote,
                )
              ],
            ),
          ),
          Expanded(
            child: _notes.isEmpty
                ? const Center(child: Text('No notes stored yet.'))
                : ListView.builder(
                    itemCount: _notes.length,
                    itemBuilder: (context, index) {
                      final note = _notes[index];
                      return NoteCard(
                        note: note,
                        onDelete: () => _deleteNote(note.id),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
