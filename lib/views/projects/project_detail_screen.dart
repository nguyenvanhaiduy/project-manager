import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:project_manager/controllers/auth/auth_controller.dart';
import 'package:project_manager/controllers/project/project_controller.dart';
import 'package:project_manager/controllers/theme_controller.dart';
import 'package:project_manager/models/project.dart';
import 'package:project_manager/models/user.dart';
import 'package:project_manager/views/projects/components/build_avatar.dart';
import 'package:project_manager/views/widgets/widgets.dart';

class ProjectDetailScreen extends StatelessWidget {
  ProjectDetailScreen({super.key, required this.project});
  final Project project;

  final ThemeController themeController = Get.find();
  final AuthController authController = Get.find();
  final GlobalKey _buttonStatusKey =
      GlobalKey(); // Tạo GlobalKey cho OutlinedButton
  final GlobalKey _buttonPriorityKey = GlobalKey();
  final ProjectController projectController = Get.find();
  final RxList<User?> listUsers = <User>[].obs;

  @override
  Widget build(BuildContext context) {
    final isOwner = project.owner == authController.currentUser.value!.id;
    final TextEditingController titleController =
        TextEditingController(text: project.title);
    final TextEditingController descriptionController =
        TextEditingController(text: project.description);
    final TextEditingController startDateController = TextEditingController(
        text: DateFormat('MM/dd/yyyy, hh:mm a').format(project.startDate));
    final TextEditingController dueDateController = TextEditingController(
        text: DateFormat('MM/dd/yyyy, hh:mm a').format(project.endDate));

    RxInt selectStatusIndex = project.status.index.obs;
    RxInt selectPriorityIndex = project.priority.index.obs;

    void changeStatusIndex(int value) {
      selectStatusIndex.value = value;
    }

    void changePriorityIndex(int value) {
      selectPriorityIndex.value = value;
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Project Detail',
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // const Divider(),
            SizedBox(height: 20),
            customTextField(context, titleController, 'project name'.tr,
                Icons.edit, (p0) => null, themeController,
                readOnly: !isOwner),
            const SizedBox(height: 20),
            customTextField(
                context,
                descriptionController,
                'project description'.tr,
                Icons.edit,
                (p0) => null,
                themeController,
                readOnly: !isOwner),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5),
              child: Row(
                children: [
                  Expanded(
                    child: customTextField(
                        context,
                        startDateController,
                        'start date'.tr,
                        Icons.edit_calendar,
                        (p0) => null,
                        themeController,
                        readOnly: !isOwner),
                  ),
                  Expanded(
                    child: customTextField(
                        context,
                        dueDateController,
                        'due date'.tr,
                        Icons.edit_calendar,
                        (p0) => null,
                        themeController,
                        readOnly: !isOwner),
                  )
                ],
              ),
            ),
            const SizedBox(height: 15),
            const Divider(),
            const SizedBox(height: 15),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'status'.tr,
                    style: Get.textTheme.bodyLarge,
                  ),
                  Obx(
                    () => OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        backgroundColor: getStatusColor(
                          Status.values[selectStatusIndex.value],
                        ),
                        side: BorderSide(
                          color: Get.isDarkMode ? Colors.white : Colors.black,
                          width: 1,
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 60),
                        foregroundColor: Colors.white,
                      ),
                      key: _buttonStatusKey,
                      onPressed: () async {
                        if (isOwner) {
                          final RenderBox button = _buttonStatusKey
                              .currentContext!
                              .findRenderObject() as RenderBox;
                          final RenderBox overlay = Overlay.of(context)
                              .context
                              .findRenderObject() as RenderBox;
                          final Offset buttonPosition = button
                              .localToGlobal(Offset.zero, ancestor: overlay);
                          await showMenu(
                              initialValue: selectStatusIndex,
                              context: context,
                              position: RelativeRect.fromRect(
                                Rect.fromPoints(
                                  buttonPosition,
                                  buttonPosition.translate(
                                      button.size.width, button.size.height),
                                ),
                                Offset.zero & overlay.size,
                              ),
                              items: Status.values
                                  .map((e) => PopupMenuItem(
                                        child: Text(e.name.tr),
                                        onTap: () {
                                          changeStatusIndex(e.index);
                                        },
                                      ))
                                  .toList());
                        }
                      },
                      child: Text(
                        Status.values[selectStatusIndex.value].name.tr,
                        style: Get.textTheme.bodyLarge,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'assigned for'.tr,
                    style: Get.textTheme.bodyLarge,
                  ),
                  SizedBox(
                    height: 35,
                    width: 100,
                    child: Stack(
                      fit: StackFit.expand,
                      alignment: Alignment.centerRight,
                      children: [
                        for (int i = 0; i < project.userIds.length; i++)
                          StreamBuilder<User?>(
                            stream: Stream.fromFuture(projectController.getUser(
                                userId: project.userIds[i])),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return Container(
                                  height: 10,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10)),
                                  width: 10,
                                  child: const CircularProgressIndicator(),
                                );
                              } else if (snapshot.hasError) {
                                return const Icon(Icons.error);
                              } else if (!snapshot.hasData ||
                                  snapshot.data == null) {
                                return const Icon(Icons.person);
                              } else {
                                return Positioned(
                                  right: i *
                                      24.0, // Điều chỉnh khoảng cách giữa các avatar
                                  child: BuildAvatar(
                                    user: snapshot.data!,
                                  ),
                                );
                              }
                            },
                          ),
                      ],
                    ),
                  )
                ],
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'priority'.tr,
                    style: Get.textTheme.bodyLarge,
                  ),
                  Obx(
                    () => OutlinedButton(
                      style: OutlinedButton.styleFrom(
                          backgroundColor: getPriorityColor(
                              Priority.values[selectPriorityIndex.value]),
                          foregroundColor: Colors.white,
                          side: BorderSide(
                            color: Get.isDarkMode ? Colors.white : Colors.black,
                            width: 2,
                          )),
                      key: _buttonPriorityKey,
                      onPressed: () async {
                        if (isOwner) {
                          final RenderBox button = _buttonPriorityKey
                              .currentContext!
                              .findRenderObject() as RenderBox;
                          final RenderBox overlay = Overlay.of(context)
                              .context
                              .findRenderObject() as RenderBox;
                          final Offset buttonPosition = button
                              .localToGlobal(Offset.zero, ancestor: overlay);
                          await showMenu(
                            context: context,
                            position: RelativeRect.fromRect(
                                Rect.fromPoints(
                                    buttonPosition,
                                    buttonPosition.translate(
                                        button.size.width, button.size.height)),
                                Offset.zero & overlay.size),
                            items: Priority.values
                                .map((e) => PopupMenuItem(
                                      child: Text(e.name.tr),
                                      onTap: () {
                                        changePriorityIndex(e.index);
                                      },
                                    ))
                                .toList(),
                          );
                        }
                      },
                      child: Text(
                        Priority.values[selectPriorityIndex.value].name.tr,
                        style: Get.textTheme.bodyMedium,
                      ),
                    ),
                  )
                ],
              ),
            ),
            const SizedBox(height: 15),
            const Divider(),
            const SizedBox(height: 15),
            OutlinedButton(
                onPressed: () {},
                style: OutlinedButton.styleFrom(
                    backgroundColor: Colors.brown,
                    padding:
                        EdgeInsets.symmetric(horizontal: 50, vertical: 10)),
                child: Text(
                  'Update Project',
                  style: Get.textTheme.bodyLarge!.copyWith(fontSize: 20),
                ))
          ],
        ),
      ),
    );
  }
}
