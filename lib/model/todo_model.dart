// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class ToDo {
  ToDo({
    this.id,
    required this.title,
    this.description,
    required this.isCompleted,
    required this.author,
  });
  String? id;
  final String title;
  final String? description;
  final bool isCompleted;
  final String author;

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'title': title,
      'description': description,
      'isCompleted': isCompleted,
      'author': author,
    };
  }

  factory ToDo.fromMap(Map<String, dynamic> map) {
    return ToDo(
      title: map['title'] as String,
      description: map['description'] as String?,
      isCompleted: map['isCompleted'] as bool,
      author: map['author'] as String,
      id: '',
    );
  }

  String toJson() => json.encode(toMap());

  factory ToDo.fromJson(String source) =>
      ToDo.fromMap(json.decode(source) as Map<String, dynamic>);
}
