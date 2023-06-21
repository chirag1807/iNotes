import 'package:flutter/material.dart';
import 'package:inotes/services/api_service.dart';

import '../models/note.dart';

class NotesProvider with ChangeNotifier{
  List<Note> notes = [];
  bool isLoading = true;

  NotesProvider(){
    fetchNotes();
  }

  void sortNotes(){
    notes.sort((a,b) => b.dateAdded!.compareTo(a.dateAdded!));
  }

  List<Note> getFilteredNotes(String searchQuery) {
    return notes.where((element) => element.title!.toLowerCase().contains(searchQuery.toLowerCase()) ||
        element.content!.toLowerCase().contains(searchQuery.toLowerCase())).toList();
  }

  void addNote(Note note){
    notes.add(note);
    sortNotes();
    notifyListeners();
    ApiService.addNote(note);
  }

  void updateNote(Note note){
    int indexOfNote = notes.indexOf(notes.firstWhere((element) => element.id == note.id));
    notes[indexOfNote] = note;
    sortNotes();
    notifyListeners();
    ApiService.addNote(note);
  }

  void deleteNote(Note note){
    int indexOfNote = notes.indexOf(notes.firstWhere((element) => element.id == note.id));
    notes.removeAt(indexOfNote);
    sortNotes();
    notifyListeners();
    ApiService.deleteNote(note);
  }

  void fetchNotes() async {
    notes = await ApiService.fetchNotes("chiragmakwana1807@gmail.com");
    sortNotes();
    isLoading = false;
    notifyListeners();
  }
}