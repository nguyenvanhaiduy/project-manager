import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:project_manager/controllers/auth/auth_controller.dart';
import 'package:project_manager/models/project.dart';

class CardCustom extends StatelessWidget {
  CardCustom({super.key, required this.onTap, required this.project});
  final AuthController authController = Get.find();
  final Project project;
  final Function() onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            style: BorderStyle.solid,
            color: Theme.of(context).brightness == Brightness.dark
                ? Colors.white
                : Colors.black,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    project.title,
                    style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                          overflow: TextOverflow.ellipsis,
                        ),
                  ),
                ),
                IconButton(
                  onPressed: () {},
                  icon: const ImageIcon(
                    AssetImage(
                      'assets/icons/icons8-dots-90.png',
                    ),
                    size: 18,
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Container(
                  height: 30,
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  decoration: BoxDecoration(
                    color: getPriorityColor(project.priority),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    project.priority.name,
                    style: Theme.of(context)
                        .textTheme
                        .bodySmall!
                        .copyWith(fontWeight: FontWeight.w400, fontSize: 14),
                  ),
                ),
                const SizedBox(width: 10),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  height: 30,
                  decoration: BoxDecoration(
                    color: getStatusColor(project.status),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    project.status.name,
                    style: Theme.of(context)
                        .textTheme
                        .bodySmall!
                        .copyWith(fontWeight: FontWeight.w400, fontSize: 14),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(Icons.calendar_month),
                    const SizedBox(width: 10),
                    Text(
                      DateFormat.yMMMd().format(project.startDate),
                      style: Theme.of(context)
                          .textTheme
                          .bodySmall!
                          .copyWith(fontSize: 15, fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
                Obx(() {
                  // final users = authController.currentUserList;
                  // final userCount = users.length;
                  final userCount = authController.currentUserList;

                  return SizedBox(
                    height: 35,
                    width: 100,
                    child: Stack(
                      children: [
                        if (userCount > 0)
                          Positioned(
                            left: 0,
                            child: CircleAvatar(
                              radius: 16,
                              backgroundColor: Colors.white,
                              child: Obx(() {
                                if (authController
                                        .currentUser.value!.imageUrl !=
                                    null) {
                                  return CircleAvatar(
                                    radius: 15,
                                    backgroundImage: NetworkImage(authController
                                        .currentUser.value!.imageUrl!),
                                  );
                                } else {
                                  return CircleAvatar(
                                    radius: 15,
                                    backgroundColor:
                                        authController.currentUser.value!.color,
                                    child: Text(
                                      authController.currentUser.value!.name[0]
                                          .toUpperCase(),
                                      // style: const TextStyle(fontSize: 40),
                                    ),
                                  );
                                }
                              }),
                            ),
                          ),
                        if (userCount > 1)
                          Positioned(
                            left:
                                24, // Đẩy avatar thứ hai sang phải một chút để chồng lên avatar thứ nhất
                            child: CircleAvatar(
                              radius: 16,
                              backgroundColor: Colors.white,
                              child: Obx(() {
                                if (authController
                                        .currentUser.value!.imageUrl !=
                                    null) {
                                  return CircleAvatar(
                                    radius: 15,
                                    backgroundImage: NetworkImage(authController
                                        .currentUser.value!.imageUrl!),
                                  );
                                } else {
                                  return CircleAvatar(
                                    radius: 15,
                                    backgroundColor:
                                        authController.currentUser.value!.color,
                                    child: Text(
                                      authController.currentUser.value!.name[0]
                                          .toUpperCase(),
                                      // style: const TextStyle(fontSize: 40),
                                    ),
                                  );
                                }
                              }),
                            ),
                          ),
                        if (userCount > 2)
                          Positioned(
                            left: 48, // Đẩy avatar "+" sang phải hơn nữa
                            child: CircleAvatar(
                              radius: 16,
                              backgroundColor: Colors.grey,
                              child: Center(
                                child: Text(
                                  '${userCount.value - 2}+', // Hiển thị số lượng người dùng chưa hiển thị
                                  style: const TextStyle(color: Colors.white),
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  );
                }),
              ],
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}
