import 'package:flutter/material.dart';
import 'package:new_firebase/ViewModel/auth_viewmodel.dart';
import 'package:new_firebase/ViewModel/notes_viewmodel.dart';
import 'package:new_firebase/model/note_model.dart';
import 'package:provider/provider.dart';

class AddEditNoteScreen extends StatefulWidget {
  final Note? note;

  const AddEditNoteScreen({super.key, this.note});

  @override
  State<AddEditNoteScreen> createState() => _AddEditNoteScreenState();
}

class _AddEditNoteScreenState extends State<AddEditNoteScreen> {
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.note != null) {
      _titleController.text = widget.note!.title;
      _contentController.text = widget.note!.content;
    }
  }

  @override
  Widget build(BuildContext context) {
    final authViewModel = Provider.of<AuthViewModel>(context, listen: false);
    final notesViewModel = Provider.of<NotesViewModel>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.note == null ? 'Add Note' : 'Edit Note'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(labelText: 'Title'),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _contentController,
              decoration: const InputDecoration(labelText: 'Content'),
              maxLines: 5,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () async {
                final title = _titleController.text;
                final content = _contentController.text;

                if (title.isEmpty || content.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text('Title and content are required')),
                  );
                  return;
                }

                if (widget.note == null) {
                  // Add note
                  await notesViewModel.addNote(
                    authViewModel.currentUser!.uid,
                    Note(
                      id: '',
                      title: title,
                      content: content,
                      createdAt: DateTime.now(),
                    ),
                  );
                } else {
                  // Edit note
                  await notesViewModel.updateNote(
                    authViewModel.currentUser!.uid,
                    Note(
                      id: widget.note!.id,
                      title: title,
                      content: content,
                      createdAt: widget.note!.createdAt,
                    ),
                  );
                }

                Navigator.pop(context);
              },
              child: Text(widget.note == null ? 'Add Note' : 'Update Note'),
            ),
          ],
        ),
      ),
    );
  }
}
