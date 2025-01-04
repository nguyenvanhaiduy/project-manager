import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:project_manager/models/project.dart';
import 'package:uuid/uuid.dart';

class Task {
  final String id;
  final String title;
  final String description;
  final DateTime startDate;
  final DateTime endDate;
  final Status status;
  final Priority priority;
  final String assignTo; // Lưu ID của User

  Task(
    this.id, {
    required this.title,
    required this.description,
    required this.startDate,
    required this.endDate,
    required this.status,
    required this.priority,
    required this.assignTo,
  });

  factory Task.fromMap({required Map<String, dynamic> data}) {
    return Task(
      data['id'],
      title: data['title'],
      description: data['description'],
      startDate: (data['startDate'] as Timestamp).toDate(),
      endDate: (data['endDate'] as Timestamp).toDate(),
      status: Status.values.firstWhereOrNull((s) => s.name == data['status']) ??
          Status.notStarted,
      priority: data['priority'],
      assignTo: data['assignTo'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': const Uuid().v4(),
      'title': title,
      'description': description,
      'startDate': Timestamp.fromDate(startDate),
      'endDate': Timestamp.fromDate(endDate),
      'status': status.name,
      'assignTo': assignTo,
    };
  }
}
