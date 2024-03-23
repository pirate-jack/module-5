import 'package:flutter/semantics.dart';

class Task {
  int? id;
  String name;
  String description;
  String priority;
  String complete;
  int? createAt;

  Task({
    this.id,
    required this.name,
    required this.description,
    required this.priority,
    required this.complete,
    required this.createAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'description': description,
      'priority': priority,
      'complete': complete,
      'createdAt': createAt,
    };
  }

  factory Task.fromMap(Map<String, dynamic> map) {
    return Task(
      id: map['id'],
      name: map['name'],
      description: map['description'],
      priority: map['priority'],
      complete: map['complete'],
      createAt: map['createAt'],
    );
  }
}
