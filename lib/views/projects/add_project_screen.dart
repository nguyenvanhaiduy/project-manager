import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:project_manager/controllers/auth/auth_controller.dart';
import 'package:project_manager/controllers/project/project_controller.dart';
import 'package:project_manager/models/project.dart';
import 'package:project_manager/models/user.dart';

class AddProjectScreen extends StatelessWidget {
  AddProjectScreen({super.key});

  final userOwner = Get.find<AuthController>().currentUser.value;
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController startDateController =
      TextEditingController(text: 'start date'.tr);
  final TextEditingController dueDateController =
      TextEditingController(text: 'due date'.tr);
  final TextEditingController emailController = TextEditingController();

  final ProjectController projectController = Get.find();

  final _formKey = GlobalKey<FormState>();
  final _formKey1 = GlobalKey<FormState>();

  final RxInt _selectedPriority = 0.obs;

  void changePriority(int index) {
    _selectedPriority.value = index;
  }

  @override
  Widget build(BuildContext context) {
    final RxList<User> assignedForArr = [userOwner!].obs;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'create project'.tr,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                decoration: BoxDecoration(
                    color: Get.isDarkMode ? Colors.white10 : Colors.white,
                    borderRadius: BorderRadius.circular(20)),
                child: TextFormField(
                  controller: titleController,
                  decoration: InputDecoration(
                    hintText: 'enter project name'.tr,
                    border:
                        const OutlineInputBorder(borderSide: BorderSide.none),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'you must enter your project name'.tr;
                    }
                    return null;
                  },
                ),
              ),
              const SizedBox(height: 20),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                decoration: BoxDecoration(
                    color: Get.isDarkMode ? Colors.white10 : Colors.white,
                    borderRadius: BorderRadius.circular(20)),
                child: TextFormField(
                  controller: descriptionController,
                  decoration: InputDecoration(
                    hintText: 'enter project description'.tr,
                    border:
                        const OutlineInputBorder(borderSide: BorderSide.none),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'you must enter your project description'.tr;
                    }
                    return null;
                  },
                ),
              ),
              const SizedBox(height: 25),
              MediaQuery.of(context).size.width >= 480
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        _customWidget(
                          icon: Icons.edit_calendar_outlined,
                          title: 'Start Date',
                          color: Colors.yellow[700]!,
                          controller: startDateController,
                          onTap: () async {
                            DateTime? pickedDate = await showDatePicker(
                              context: context,
                              firstDate: DateTime(2000),
                              lastDate: DateTime(2100),
                              initialDate: DateTime.now(),
                            );
                            if (pickedDate != null) {
                              TimeOfDay? pickedTime = await showTimePicker(
                                context: context,
                                initialTime: TimeOfDay.now(),
                              );

                              DateTime pickedDateTime = DateTime(
                                pickedDate.year,
                                pickedDate.month,
                                pickedDate.day,
                                pickedTime?.hour ?? DateTime.now().hour,
                                pickedTime?.minute ?? DateTime.now().minute,
                              );
                              startDateController.text =
                                  DateFormat('MM/dd/yyyy, hh:mm a')
                                      .format(pickedDateTime);
                            }
                          },
                          onValidator: (value) {
                            if (value == null ||
                                value.isEmpty ||
                                value == 'start date'.tr) {
                              return 'you must enter your project start date'
                                  .tr;
                            }

                            return null;
                          },
                        ),
                        _customWidget(
                          icon: Icons.edit_calendar_outlined,
                          title: 'Due Date',
                          color: Colors.yellow[700]!,
                          controller: dueDateController,
                          onTap: () async {
                            DateTime? pickedDate = await showDatePicker(
                              context: context,
                              firstDate: DateTime(2000),
                              lastDate: DateTime(2100),
                              initialDate: DateTime.now(),
                            );
                            if (pickedDate != null) {
                              TimeOfDay? pickedTime = await showTimePicker(
                                  context: context,
                                  initialTime: TimeOfDay.now());
                              DateTime pickedDateTime = DateTime(
                                  pickedDate.year,
                                  pickedDate.month,
                                  pickedDate.day,
                                  pickedTime?.hour ?? DateTime.now().hour,
                                  pickedTime?.minute ?? DateTime.now().minute);
                              dueDateController.text =
                                  DateFormat('MM/dd/yyyy, hh:mm a')
                                      .format(pickedDateTime);
                            }
                          },
                          onValidator: (value) {
                            if (value == null ||
                                value.isEmpty ||
                                value == 'due date'.tr) {
                              return 'you must enter your project due date'.tr;
                            }
                            if (startDateController.text.isNotEmpty &&
                                DateFormat('MM/dd/yyyy, hh:mm a')
                                    .parse(value)
                                    .isBefore(DateFormat('MM/dd/yyyy, hh:mm a')
                                        .parse(startDateController.text))) {
                              return 'due date must be after start date'.tr;
                            }
                            return null;
                          },
                        ),
                      ],
                    )
                  : Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _customWidget(
                          icon: Icons.edit_calendar_outlined,
                          title: 'Start Date',
                          color: Colors.yellow[700]!,
                          controller: startDateController,
                          onTap: () async {
                            DateTime? pickedDate = await showDatePicker(
                              context: context,
                              firstDate: DateTime(2000),
                              lastDate: DateTime(2100),
                              initialDate: DateTime.now(),
                            );
                            if (pickedDate != null) {
                              TimeOfDay? pickedTime = await showTimePicker(
                                context: context,
                                initialTime: TimeOfDay.now(),
                              );

                              DateTime pickedDateTime = DateTime(
                                pickedDate.year,
                                pickedDate.month,
                                pickedDate.day,
                                pickedTime?.hour ?? DateTime.now().hour,
                                pickedTime?.minute ?? DateTime.now().minute,
                              );
                              startDateController.text =
                                  DateFormat('MM/dd/yyyy, hh:mm a')
                                      .format(pickedDateTime);
                            }
                          },
                          onValidator: (value) {
                            if (value == null ||
                                value.isEmpty ||
                                value == 'start date'.tr) {
                              return 'you must enter your project start date'
                                  .tr;
                            }
                            // if(startDateController.text.isNotEmpty && DateFormat('MM/dd/yyyy, hh:mm a').parse(value).isbe)
                            return null;
                          },
                        ),
                        const SizedBox(height: 10),
                        _customWidget(
                          icon: Icons.edit_calendar_outlined,
                          title: 'Due Date',
                          color: Colors.yellow[700]!,
                          controller: dueDateController,
                          onTap: () async {
                            DateTime? pickedDate = await showDatePicker(
                              context: context,
                              firstDate: DateTime(2000),
                              lastDate: DateTime(2100),
                              initialDate: DateTime.now(),
                            );
                            if (pickedDate != null) {
                              TimeOfDay? pickedTime = await showTimePicker(
                                  context: context,
                                  initialTime: TimeOfDay.now());
                              DateTime pickedDateTime = DateTime(
                                  pickedDate.year,
                                  pickedDate.month,
                                  pickedDate.day,
                                  pickedTime?.hour ?? DateTime.now().hour,
                                  pickedTime?.minute ?? DateTime.now().minute);
                              dueDateController.text =
                                  DateFormat('MM/dd/yyyy, hh:mm a')
                                      .format(pickedDateTime);
                            }
                          },
                          onValidator: (value) {
                            if (value == null ||
                                value.isEmpty ||
                                value == 'due date'.tr) {
                              return 'you must enter your project due date'.tr;
                            }
                            if (startDateController.text.isNotEmpty &&
                                DateFormat('MM/dd/yyyy, hh:mm a')
                                    .parse(value)
                                    .isBefore(DateFormat('MM/dd/yyyy, hh:mm a')
                                        .parse(startDateController.text))) {
                              return 'due date must be after start date'.tr;
                            }
                            return null;
                          },
                        ),
                      ],
                    ),
              const SizedBox(height: 15),
              const Divider(thickness: 0, height: 0),
              const SizedBox(height: 15),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: Colors.deepPurple[200]!,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(
                        Icons.person_outline,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      'assigned for'.tr,
                      style: Get.textTheme.bodyLarge!.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 15),
              Container(
                  height: 40,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Expanded(
                        // flex: 1,
                        child: Obx(() => ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: assignedForArr.length,
                            itemBuilder: (context, index) {
                              final user = assignedForArr[index];
                              if (user.imageUrl != null) {
                                return CircleAvatar(
                                  backgroundImage: NetworkImage(user.imageUrl!),
                                );
                              } else {
                                return CircleAvatar(
                                  backgroundColor: user.color,
                                  child: Text(user.name[0].toUpperCase()),
                                );
                              }
                            })),
                      ),
                      IconButton.outlined(
                        style: IconButton.styleFrom(
                          backgroundColor:
                              Get.isDarkMode ? Colors.white10 : Colors.white,
                        ),
                        onPressed: () {
                          Get.defaultDialog(
                            title: 'add members'.tr,
                            content: Form(
                              key: _formKey1,
                              child: Column(
                                children: [
                                  TextFormField(
                                    controller: emailController,
                                    decoration: InputDecoration(
                                      hintText: 'enter user email'.tr,
                                    ),
                                    validator: (value) {
                                      final user1 =
                                          assignedForArr.firstWhereOrNull(
                                        (user1) =>
                                            user1.email == emailController.text,
                                      );
                                      if (value == null || value.isEmpty) {
                                        return 'you must enter user email'.tr;
                                      }
                                      if (user1 != null) {
                                        return 'user already exists'.tr;
                                      }
                                      if (!GetUtils.isEmail(value)) {
                                        return 'please enter a valid email'.tr;
                                      }
                                      return null;
                                    },
                                  ),
                                  const SizedBox(height: 10),
                                  TextButton(
                                    onPressed: () async {
                                      if (_formKey1.currentState!.validate()) {
                                        final user =
                                            await projectController.getUser(
                                                email: emailController.text);
                                        if (user != null) {
                                          assignedForArr.add(user);
                                          emailController.clear();
                                          Get.back();
                                        } else {
                                          Get.snackbar(
                                              'Error', 'Error not found',
                                              colorText: Colors.red);
                                        }
                                      }
                                    },
                                    child: Text('add'.tr),
                                  ),
                                ],
                              ),
                              onPopInvoked: (didPop) {
                                emailController.text = '';
                              },
                            ),
                          );
                        },
                        icon: const Icon(Icons.add),
                      ),
                      // Spacer(
                      //   flex: 3,
                      // )
                    ],
                  )),
              const SizedBox(height: 15),
              const Divider(thickness: 0, height: 0),
              const SizedBox(height: 15),
              _customWidget(
                icon: Icons.flag_outlined,
                title: 'priority'.tr,
                color: Colors.green[200]!,
                isTextField: false,
              ),
              const SizedBox(height: 15),
              Container(
                height: 35,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    const SizedBox(width: 20),
                    _customLablePriority(context, Priority.low, () {
                      changePriority(0);
                    }),
                    const SizedBox(width: 20),
                    _customLablePriority(context, Priority.medium, () {
                      changePriority(1);
                    }),
                    const SizedBox(width: 20),
                    _customLablePriority(context, Priority.high, () {
                      changePriority(2);
                    }),
                  ],
                ),
              ),
              const SizedBox(height: 30),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: TextButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      final List<String> userIds = [];
                      for (var user in assignedForArr) {
                        userIds.add(user.id);
                      }
                      await projectController.addProject(
                        Project(
                          title: titleController.text,
                          description: descriptionController.text,
                          status: Status.notStarted,
                          priority: Priority.values[_selectedPriority.value],
                          startDate: DateFormat('MM/dd/yyyy, hh:mm a')
                              .parse(startDateController.text),
                          endDate: DateFormat('MM/dd/yyyy, hh:mm a')
                              .parse(dueDateController.text),
                          taskIds: [],
                          userIds: userIds,
                          owner: userOwner!.id,
                        ),
                      );
                    }
                  },
                  style: TextButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    backgroundColor:
                        Get.isDarkMode ? Colors.black38 : Colors.white,
                    foregroundColor:
                        Get.isDarkMode ? Colors.white : Colors.black,
                  ),
                  child: Container(
                    constraints: const BoxConstraints(
                      minWidth: 100,
                      maxWidth: 300,
                    ),
                    height: kIsWeb ? 50 : 40,
                    // decoration: BoxDecoration(
                    //   color: Colors.white10,
                    //   borderRadius: BorderRadius.circular(10),
                    // ),
                    alignment: Alignment.center,
                    child: Text('create project'.tr,
                        style: Get.textTheme.bodyLarge!.copyWith(
                            fontWeight: FontWeight.bold, fontSize: 18)),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _customWidget(
      {required IconData icon,
      required String title,
      required Color color,
      TextEditingController? controller,
      Function()? onTap,
      String? Function(String?)? onValidator,
      bool isTextField = true}) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 20,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              icon,
            ),
          ),
          const SizedBox(width: 10),
          isTextField
              ? SizedBox(
                  width: 220,
                  child: TextFormField(
                    readOnly: true,
                    controller: controller,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                    ),
                    onTap: onTap,
                    validator: onValidator,
                  ),
                )
              : Text(
                  title,
                  style: Get.textTheme.bodyLarge!.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
        ],
      ),
    );
  }

  Widget _customLablePriority(
      BuildContext context, Priority priority, Function() onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Obx(
        () => Container(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          height: 40,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black, width: 1),
            color: _selectedPriority.value == priority.index
                ? getPriorityColor(priority)
                : null,
            borderRadius: BorderRadius.circular(15),
          ),
          alignment: Alignment.center,
          child: Text(
            priority.name.tr,
            style: Theme.of(context).textTheme.bodySmall!.copyWith(
                  fontWeight: FontWeight.w400,
                  fontSize: 15,
                  color: _selectedPriority.value == priority.index
                      ? Colors.black
                      : null,
                ),
          ),
        ),
      ),
    );
  }

  // String getName(String name) {
  //   return '${name[0].toUpperCase()}${name.substring(1)}';
  // }
}
