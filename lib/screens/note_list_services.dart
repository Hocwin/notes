import 'package:flutter/material.dart';
import 'package:notes_firestore/services/notes_service.dart';

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
                return AlertDialog(
                  content: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Add'),
                      const Padding(
                        padding: EdgeInsets.only(top: 8),
                        child: Text('Title', textAlign: TextAlign.start),
                      ),
                      TextField(controller: _titleController),
                      const Padding(
                        padding: EdgeInsets.only(top: 20),
                        child: Text('Description', textAlign: TextAlign.start),
                      ),
                      TextField(controller: _descriptionController)
                    ],
                  ),
                  actions: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: Text('Cancel')),
                    ),
                    ElevatedButton(
                        onPressed: () {
                          NoteService.addNote(_titleController.text,
                                  _descriptionController.text)
                              .whenComplete(() => Navigator.of(context).pop());
                        },
                        child: Text('Save'))
                  ],
                );
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
                              TextEditingController titleController =
                                  TextEditingController(
                                      text: document['title']);
                              TextEditingController descriptionController =
                                  TextEditingController(
                                      text: document['description']);
                              return AlertDialog(
                                title: const Text('Update Notes'),
                                content: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text('Title',
                                        textAlign: TextAlign.start),
                                    TextField(
                                      controller: titleController,
                                    ),
                                    const Padding(
                                      padding: EdgeInsets.only(top: 20),
                                      child: Text('Description',
                                          textAlign: TextAlign.start),
                                    ),
                                    TextField(
                                      controller: descriptionController,
                                    )
                                  ],
                                ),
                                actions: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10),
                                    child: ElevatedButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        child: Text('Cancel')),
                                  ),
                                  ElevatedButton(
                                      onPressed: () {
                                        NoteService.updateNote(
                                                document['id'],
                                                titleController.text,
                                                descriptionController.text)
                                            .whenComplete(() =>
                                                Navigator.of(context).pop());
                                      },
                                      child: Text('Update'))
                                ],
                              );
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
