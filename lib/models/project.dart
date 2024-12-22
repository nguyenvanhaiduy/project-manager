import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:project_manager/models/task.dart';
import 'package:project_manager/models/user.dart';
import 'package:uuid/uuid.dart';

class Project {
  final String id;
  final String title;
  final String description;
  final Status status;
  final DateTime startDate;
  final DateTime endDate;
  final List<Task> tasks;
  final List<User> users;
  final String owner;

  Project(
    this.id, {
    required this.title,
    required this.description,
    required this.status,
    required this.startDate,
    required this.endDate,
    required this.tasks,
    required this.users,
    required this.owner,
  });

  factory Project.fromMap({required Map<String, dynamic> data}) {
    return Project(
      data['id'],
      title: data['title'],
      description: data['description'],
      status: data['status'],
      startDate: (data['startDate'] as Timestamp).toDate(),
      endDate: (data['endDate'] as Timestamp).toDate(),
      tasks: (data['tasks'] as List).isNotEmpty
          ? (data['tasks'] as List)
              .map((task) => Task.fromMap(data: task))
              .toList()
          : [],
      users: (data['users'] as List).isNotEmpty
          ? (data['users'] as List)
              .map((user) => User.fromMap(data: user))
              .toList()
          : [],
      owner: data['owner'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': const Uuid().v4(),
      'title': title,
      'description': description,
      'status': status.name,
      'startDate': Timestamp.fromDate(startDate),
      'endDate': Timestamp.fromDate(endDate),
      'tasks': tasks.map((task) => task.toMap()).toList(),
      'users': users.map((user) => user.toMap()).toList(),
      'owner': owner,
    };
  }
}

enum Status {
  notStarted,
  inProgress,
  completed,
}
