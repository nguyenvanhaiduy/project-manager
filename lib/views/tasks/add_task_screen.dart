import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddTaskScreen extends StatelessWidget {
  const AddTaskScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('create task'.tr),
      ),
    );
  }
}
