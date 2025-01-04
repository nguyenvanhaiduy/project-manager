import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:project_manager/controllers/theme_controller.dart';
import 'package:project_manager/views/widgets/widgets.dart';

class ProjectDetailScreen extends StatelessWidget {
  ProjectDetailScreen({super.key});

  final ThemeController themeController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Project Detail',
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5),
              child: customTextField(
                context,
                TextEditingController(),
                'Project Name',
                Icons.edit,
                (p0) => null,
                themeController,
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5),
              child: Row(
                children: [
                  Expanded(
                    child: customTextField(
                      context,
                      TextEditingController(),
                      'Start Date',
                      Icons.edit_calendar,
                      (p0) => null,
                      themeController,
                    ),
                  ),
                  Expanded(
                    child: customTextField(
                      context,
                      TextEditingController(),
                      'Due Date',
                      Icons.edit_calendar,
                      (p0) => null,
                      themeController,
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
