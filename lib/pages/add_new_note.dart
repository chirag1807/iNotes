import 'package:flutter/material.dart';
import 'package:inotes/models/note.dart';
import 'package:inotes/provider/notes_provider.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

class AddNote extends StatefulWidget {
  final bool isUpdate;
  final Note? note;
  const AddNote({Key? key, required this.isUpdate, this.note}) : super(key: key);

  @override
  State<AddNote> createState() => _AddNoteState();
}

class _AddNoteState extends State<AddNote> {
  TextEditingController titleController = TextEditingController();
  TextEditingController contentController = TextEditingController();
  FocusNode noteFocus = FocusNode();

  void addNewNote(){
    Note newNote = Note(
      id: const Uuid().v1(),
      userId: "chiragmakwana1807@gmail.com",
      title: titleController.text,
      content: contentController.text,
      dateAdded: DateTime.now()
    );
    Provider.of<NotesProvider>(context, listen: false).addNote(newNote);
    Navigator.pop(context);
  }

  void updateNote(){
    widget.note!.title = titleController.text;
    widget.note!.content = contentController.text;
    widget.note!.dateAdded = DateTime.now();
    Provider.of<NotesProvider>(context, listen: false).updateNote(widget.note!);
    Navigator.pop(context);
  }

  @override
  void initState() {
    super.initState();
    if(widget.isUpdate){
      titleController.text = widget.note!.title!;
      contentController.text = widget.note!.content!;
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: (){
            Navigator.pop(context);
          },
          icon: const Icon(Icons.close),
        ),
        actions: [
          IconButton(
              onPressed: (){
                if(widget.isUpdate){
                  updateNote();
                }
                else{
                  addNewNote();
                }
              },
              icon: const Icon(Icons.check))
        ],
      ),
      body: SafeArea(
        child: Container(
          margin: const EdgeInsets.all(10),
          child: Column(
            children: [
              TextField(
                controller: titleController,
                autofocus: (widget.isUpdate == true) ? false : true,
                decoration: const InputDecoration(
                  label: Text("Title"),
                  hintText: "Enter Title Here",
                  border: OutlineInputBorder()
                ),
                onSubmitted: (val){
                  if(val.isNotEmpty){
                    noteFocus.requestFocus();
                  }
                },
              ),
              const Divider(height: 20, color: Colors.transparent,),
              TextField(
                controller: contentController,
                focusNode: noteFocus,
                decoration: const InputDecoration(
                    label: Text("Content"),
                    hintText: "Enter Content Here",
                    border: OutlineInputBorder()
                ),
                maxLines: null,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
