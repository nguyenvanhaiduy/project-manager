import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:project_manager/views/widgets/custom_drawer.dart';

class ProjectScreen extends StatelessWidget {
  const ProjectScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'your project'.tr,
        ),
      ),
      drawer: CustomDrawer(),
    );
  }
}
