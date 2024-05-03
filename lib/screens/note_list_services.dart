import 'package:flutter/material.dart';
import 'package:notes_firestore/services/notes_service.dart';
import 'package:notes_firestore/widgets/note_dialog.dart';

class NoteListScreen extends StatefulWidget {
  const NoteListScreen({super.key});

  @override
  State<NoteListScreen> createState() => _NoteListScreenState();
}

class _NoteListScreenState extends State<NoteListScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notes'),
      ),
      body: NoteList(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
              context: context,
              builder: (context) {
                return NoteDialog();
              });
        },
        tooltip: 'Add Note',
        child: const Icon(Icons.add),
      ),
    );
  }
}

class NoteList extends StatelessWidget {
  const NoteList({super.key});

  @override
  Widget build(BuildContext context) {
    // return FutureBuilder(
    // future :NoteService.retrieveNotes(),
    return StreamBuilder(
        //     stream: FirebaseFirestore.instance.collection('collection').snapshots(),
        stream: NoteService.getNoteList(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return new Text('Error: ${snapshot.error}');
          }
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return const Center(
                child: CircularProgressIndicator(),
              );
            default:
              return ListView(
                padding: const EdgeInsets.only(bottom: 80),
                // children: snapshot.data!.docs.map((document) {
                children: snapshot.data!.map((document) {
                  return Card(
                    child: ListTile(
                      onTap: () {
                        showDialog(
                            context: context,
                            builder: (context) {
                              return NoteDialog(note : document);
                            });
                      },
                      title: Text(document['title']),
                      subtitle: Text(document['description']),
                      trailing: InkWell(
                        onTap: () {
                          showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: const Text('Delete Notes??'),
                                  actions: [
                                    ElevatedButton(
                                        onPressed: () {
                                          NoteService.deleteNote(document['id'])
                                              .whenComplete(() =>
                                                  Navigator.of(context).pop());
                                        },
                                        child: Text('Yes')),
                                    ElevatedButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        child: Text('No')),
                                  ],
                                );
                              });
                        },
                        child: const Padding(
                          padding: EdgeInsets.symmetric(vertical: 10),
                          child: Icon(Icons.delete),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              );
          }
        });
  }
}
