import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:project_manager/controllers/auth/auth_controller.dart';
import 'package:project_manager/controllers/project/progress_project_controller.dart';
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
  final _formKey = GlobalKey<FormState>();
  final ProjectController projectController = Get.find();
  final RxList<User?> listUsers = <User>[].obs;

  final progressProjectController = Get.put(
    ProgressProjectController(targetValue: 0.2),
  );

  @override
  Widget build(BuildContext context) {
    final isOwner = project.owner == authController.currentUser.value!.id;
    final TextEditingController titleController =
        TextEditingController(text: project.title);
    final TextEditingController descriptionController =
        TextEditingController(text: project.description);
    final TextEditingController startDateController = TextEditingController(
        text: DateFormat('MM/dd/yyyy, HH:mm').format(project.startDate));
    final TextEditingController dueDateController = TextEditingController(
        text: DateFormat('MM/dd/yyyy, HH:mm').format(project.endDate));

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
        title: const Text('Project Detail'),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              const SizedBox(height: 20),
              customTextField(context, titleController, 'name'.tr, Icons.edit,
                  (value) {
                if (value == null || value.isEmpty) {
                  return 'you must enter your project name'.tr;
                }
                return null;
              }, themeController, readOnly: !isOwner),
              const SizedBox(height: 20),
              customTextField(
                context,
                descriptionController,
                'description'.tr,
                Icons.edit,
                (value) {
                  if (value == null || value.isEmpty) {
                    return 'you must enter your project description'.tr;
                  }
                  return null;
                },
                themeController,
                readOnly: !isOwner,
              ),
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
                        (value) {
                          return null;
                        },
                        onTap: () async {
                          if (isOwner) {
                            DateTime? pickedDate = await showDatePicker(
                                context: context,
                                initialDate: DateTime.now(),
                                firstDate: DateTime(2000),
                                lastDate: DateTime(2100));
                            if (pickedDate != null) {
                              TimeOfDay? pickedTime = await showTimePicker(
                                context: context,
                                initialTime: TimeOfDay.now(),
                              );
                              DateTime pickedDateTime = DateTime(
                                pickedDate.year,
                                pickedDate.hour,
                                pickedDate.day,
                                pickedTime?.hour ?? DateTime.now().hour,
                                pickedTime?.minute ?? DateTime.now().minute,
                              );
                              startDateController.text =
                                  DateFormat('MM/dd/yyyy, HH:mm')
                                      .format(pickedDateTime);
                            }
                          }
                        },
                        themeController,
                        readOnly: true,
                      ),
                    ),
                    Expanded(
                      child: customTextField(
                        context,
                        dueDateController,
                        'due date'.tr,
                        Icons.edit_calendar,
                        (value) {
                          if (DateFormat('MM/dd/yyy, HH:mm')
                              .parse(value!)
                              .isBefore(DateFormat('MM/dd/yyyy, HH:mm')
                                  .parse(startDateController.text))) {
                            return 'due date must be after start date'.tr;
                          }
                          return null;
                        },
                        onTap: () async {
                          if (isOwner) {
                            DateTime? pickedDate = await showDatePicker(
                                context: context,
                                initialDate: DateTime.now(),
                                firstDate: DateTime(2000),
                                lastDate: DateTime(2100));
                            if (pickedDate != null) {
                              TimeOfDay? pickedTime = await showTimePicker(
                                context: context,
                                initialTime: TimeOfDay.now(),
                              );
                              DateTime pickedDateTime = DateTime(
                                pickedDate.year,
                                pickedDate.hour,
                                pickedDate.day,
                                pickedTime?.hour ?? DateTime.now().hour,
                                pickedTime?.minute ?? DateTime.now().minute,
                              );
                              dueDateController.text =
                                  DateFormat('MM/dd/yyyy, HH:mm')
                                      .format(pickedDateTime);
                            }
                          }
                        },
                        themeController,
                        readOnly: true,
                      ),
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
                          // side: BorderSide(
                          //     // color: Get.isDarkMode ? Colors.white : Colors.black,
                          //     // width: 1,
                          //     ),
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
                          style: Get.textTheme.bodyLarge!
                              .copyWith(color: Colors.white),
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
                              stream: Stream.fromFuture(projectController
                                  .getUser(userId: project.userIds[i])),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return Container();
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
                                      size: 17.5,
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
                          // side: BorderSide(
                          //   color: Get.isDarkMode ? Colors.white : Colors.black,
                          //   width: 1,
                          // ),
                        ),
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
                                          button.size.width,
                                          button.size.height)),
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
                          style: Get.textTheme.bodyLarge!.copyWith(
                            color: Colors.white,
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              const SizedBox(height: 15),
              const Divider(),
              const SizedBox(height: 15),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                height: 140,
                decoration: BoxDecoration(
                  color: Get.isDarkMode ? Colors.white10 : Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                        child: Padding(
                      padding: const EdgeInsets.only(left: 20.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 15),
                          Padding(
                            padding: const EdgeInsets.only(right: 0),
                            child: SizedBox(
                              // width: 180,
                              child: Text(
                                'Tiến độ hoàn thành dự án!',
                                style: Get.textTheme.bodyLarge,
                              ),
                            ),
                          ),
                          const SizedBox(height: 15),
                          TextButton(
                              style: TextButton.styleFrom(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 20),
                                // side: const BorderSide(width: 0.5),
                                backgroundColor: Get.isDarkMode
                                    ? Colors.white12
                                    : const Color.fromARGB(255, 207, 234, 248),
                              ),
                              onPressed: () {
                                print(Get.size.width);
                              },
                              child: Text(
                                'Xem chi tiết',
                                style: Get.textTheme.bodyLarge,
                              )),
                          const SizedBox(height: 15),
                        ],
                      ),
                    )),
                    Obx(
                      () => Stack(
                        alignment: Alignment.center,
                        children: [
                          SizedBox(
                            height: 80,
                            width: 80,
                            child: CircularProgressIndicator(
                              value:
                                  progressProjectController.currentValue.value,
                              strokeWidth: 20,
                              semanticsValue: '1',
                              backgroundColor: Get.isDarkMode
                                  ? Colors.white24
                                  : const Color.fromARGB(208, 229, 236, 241),
                              valueColor: const AlwaysStoppedAnimation<Color>(
                                Color.fromARGB(255, 150, 221, 253),
                              ),
                            ),
                          ),
                          Positioned(
                            child: Text(
                                '${(progressProjectController.currentValue.value * 100).toStringAsFixed(0)}%'),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 30),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              isOwner
                  ? OutlinedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          print('test');
                        }
                      },
                      style: OutlinedButton.styleFrom(
                        // backgroundColor: Get.is,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 50, vertical: 10),
                      ),
                      child: Text(
                        'Update Project',
                        style: Get.textTheme.bodyLarge!.copyWith(fontSize: 20),
                      ),
                    )
                  : Container()
            ],
          ),
        ),
      ),
    );
  }
}
