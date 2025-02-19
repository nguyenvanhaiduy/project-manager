import 'package:flutter/material.dart';
import 'package:project_manager/models/project.dart';
import 'package:project_manager/models/task.dart';

Color getContrastingTextColor(Color backgroundColor) {
  return backgroundColor.computeLuminance() > 0.5 ? Colors.black : Colors.white;
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
  }
}

Color getComplexityColor(Complexity complexity) {
  switch (complexity) {
    case Complexity.easy:
      return Colors.green;
    case Complexity.medium:
      return Colors.blue;
    case Complexity.hard:
      return Colors.orange;
    case Complexity.veryHard:
      return Colors.red;
  }
}
