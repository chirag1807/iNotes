import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:inotes/provider/notes_provider.dart';
import 'package:provider/provider.dart';

import '../models/note.dart';
import 'add_new_note.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String searchQuery = "";
  @override
  Widget build(BuildContext context) {
    NotesProvider notesProvider = Provider.of<NotesProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text("iNotes"),
        centerTitle: true,
      ),
      body: notesProvider.isLoading == false
          ? SafeArea(
          child: notesProvider.notes.isNotEmpty
          ? SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: TextFormField(
                    decoration: const InputDecoration(
                      hintText: "Search"
                    ),
                    onChanged: (value){
                      setState(() {
                        searchQuery = value;
                      });
                    },
                  ),
                ),
                notesProvider.getFilteredNotes(searchQuery).isNotEmpty
                ? GridView.builder(
                  shrinkWrap: true,
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2
                    ),
                    itemCount: notesProvider.getFilteredNotes(searchQuery).length,
                    itemBuilder: (context, index){
                      Note currentNote = notesProvider.getFilteredNotes(searchQuery)[index];
                      return GestureDetector(
                        onTap: (){
                          Navigator.push(context, CupertinoPageRoute(builder: (context) => AddNote(isUpdate: true, note: currentNote,)));
                        },
                        onLongPress: (){
                          showDeleteDialog(notesProvider, currentNote);
                        },
                        child: Container(
                          margin: const EdgeInsets.all(5),
                          padding: const EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.blue,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(currentNote.title!, maxLines: 1, overflow: TextOverflow.ellipsis,
                                style: const TextStyle(fontSize: 25, fontWeight: FontWeight.bold, color: Colors.white),),
                              const Divider(height: 8, color: Colors.transparent,),
                              Text(currentNote.content!, maxLines: 5, overflow: TextOverflow.ellipsis,
                                style: const TextStyle(fontSize: 17, color: Colors.white),)
                            ],
                          ),
                        ),
                      );
                    }
                )
                    : const Text("No Notes Found"),
              ],
            ),
          )
          : const Center(
              child: Text("No Notes Yet", style: TextStyle(fontSize: 25),),
          )
        )
      : const Center(
        child: CircularProgressIndicator(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context, CupertinoPageRoute(builder: (context) => const AddNote(isUpdate: false,)));
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  void showDeleteDialog(NotesProvider notesProvider, Note currentNote) {
    showDialog(context: context, builder: (content) {
      return AlertDialog(
        title: const Text("Delete Note"),
        content: const Text("Are You Sure to Want to Delete this Note?"),
        actions: [
          TextButton(
              onPressed: (){
                Navigator.pop(context);
              },
              child: const Text("No")
          ),
          TextButton(
              onPressed: (){
                notesProvider.deleteNote(currentNote);
                Navigator.pop(context);
              },
              child: const Text("Yes")
          ),
        ],
      );
    });
  }
}
