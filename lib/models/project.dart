import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';

class Project {
  final String id;
  final String title;
  final String description;
  final Status status;
  final Priority priority;
  final DateTime startDate;
  final DateTime endDate;
  final List<String> taskIds; // Lưu ID của Task
  final List<String> userIds; // Lưu ID của User
  final String owner; // Lưu ID của người tạo Project

  Project({
    this.id = '',
    required this.title,
    required this.description,
    required this.status,
    required this.priority,
    required this.startDate,
    required this.endDate,
    required this.taskIds,
    required this.userIds,
    required this.owner,
  });

  factory Project.fromMap({required Map<String, dynamic> data}) {
    return Project(
      id: data['id'],
      title: data['title'],
      description: data['description'],
      status: Status.values.firstWhereOrNull((s) => s.name == data['status']) ??
          Status.notStarted,
      priority:
          Priority.values.firstWhereOrNull((p) => p.name == data['priority']) ??
              Priority.low,
      startDate: (data['startDate'] as Timestamp).toDate(),
      endDate: (data['endDate'] as Timestamp).toDate(),
      taskIds: List<String>.from(data['tasks'] ?? []),
      userIds: List<String>.from(data['users'] ?? []),
      owner: data['owner'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': const Uuid().v4(),
      'title': title,
      'description': description,
      'status': status.name,
      'priority': priority.name,
      'startDate': Timestamp.fromDate(startDate),
      'endDate': Timestamp.fromDate(endDate),
      'tasks': taskIds,
      'users': userIds,
      'owner': owner,
    };
  }
}

enum Status {
  notStarted,
  inProgress,
  completed,
  lateCompleted,
  cancelled,
}

enum Priority {
  low,
  medium,
  high,
}

Color getStatusColor(Status status) {
  switch (status) {
    case Status.notStarted:
      return Colors.grey;
    case Status.inProgress:
      return Colors.blue;
    case Status.completed:
      return Colors.green;
    case Status.lateCompleted:
      return Colors.orange;
    case Status.cancelled:
      return Colors.red;
    default:
      return Colors.black;
  }
}

Color getPriorityColor(Priority priority) {
  switch (priority) {
    case Priority.low:
      return Colors.green;
    case Priority.medium:
      return Colors.yellow[700]!;
    case Priority.high:
      return Colors.red;
    default:
      return Colors.black;
  }
}
