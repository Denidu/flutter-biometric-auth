import 'package:flutter/material.dart';
import '../models/secure_note.dart';

class NoteCard extends StatelessWidget {
  final SecureNote note;
  final VoidCallback onDelete;

  const NoteCard({
    super.key,
    required this.note,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: ListTile(
        title: Text(note.content),
        trailing: IconButton(
          icon: const Icon(Icons.delete, color: Colors.redAccent),
          onPressed: onDelete,
          tooltip: 'Delete note',
        ),
      ),
    );
  }
}
