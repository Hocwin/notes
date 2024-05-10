import 'package:cloud_firestore/cloud_firestore.dart';

class Note {
  String? id;
  final String title;
  String? imageUrl;
  final String description;
  Timestamp? createdAt;
  Timestamp? updatedAt;

  Note({
    this.id,
    required this.title,
    this.imageUrl,
    required this.description,
    this.createdAt,
    this.updatedAt,
  });

  factory Note.fromDocument(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return Note(
      id: doc.id,
      title: data['title'],
      description: data['description'],
      imageUrl: data['imageUrl'],
      createdAt: data['created_at'] as Timestamp,
      updatedAt: data['updated_at'] as Timestamp,
    );
  }

  Map<String, dynamic> toDocument() {
    return {
      'title': title,
      'description': description,
      'imageUrl' : imageUrl,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}
