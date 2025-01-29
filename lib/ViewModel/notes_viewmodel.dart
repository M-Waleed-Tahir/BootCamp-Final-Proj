import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:new_firebase/model/note_model.dart';

class NotesViewModel extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<Note> _notes = [];

  List<Note> get notes => _notes;

  Future<void> fetchNotes(String userId) async {
    final querySnapshot = await _firestore
        .collection('users/$userId/notes')
        .orderBy('createdAt', descending: true)
        .get();

    _notes = querySnapshot.docs
        .map((doc) => Note.fromMap(doc.data(), doc.id))
        .toList();
    notifyListeners();
  }

  Future<void> addNote(String userId, Note note) async {
    await _firestore.collection('users/$userId/notes').add(note.toMap());
    await fetchNotes(userId);
  }

  Future<void> updateNote(String userId, Note note) async {
    await _firestore
        .collection('users/$userId/notes')
        .doc(note.id)
        .update(note.toMap());
    await fetchNotes(userId);
  }

  Future<void> deleteNote(String userId, String noteId) async {
    await _firestore.collection('users/$userId/notes').doc(noteId).delete();
    await fetchNotes(userId);
  }
}
