import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:project_manager/controllers/auth/auth_controller.dart';
import 'package:project_manager/controllers/project/project_controller.dart';
import 'package:project_manager/models/project.dart';
import 'package:project_manager/models/user.dart';

class CardCustom extends StatelessWidget {
  CardCustom({super.key, required this.onTap, required this.project});
  final AuthController authController = Get.find();
  final ProjectController projectController = Get.find();
  final Project project;
  final Function() onTap;
  final RxList<User> assignedForArr = <User>[].obs;

  Future<void> _fetchUsers() async {
    await Future.wait(
      project.userIds.map((userId) async {
        final user = await projectController.getUser(userId: userId);
        if (user != null) {
          assignedForArr.add(user);
        }
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    _fetchUsers();
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
                    project.priority.name.tr,
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
                    project.status.name.tr,
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
                SizedBox(
                  height: 35,
                  width: 100,
                  child: Obx(
                    () => Stack(
                      alignment:
                          Alignment.centerRight, // Căn chỉnh Stack về bên phải
                      children: [
                        if (assignedForArr.length > 2)
                          Positioned(
                            right: assignedForArr.length > 1
                                ? 24.0 * 2
                                : 0, // Điều chỉnh vị trí dựa trên số lượng avatar
                            child: _buildPlusAvatar(assignedForArr.length - 2),
                          ),
                        if (assignedForArr.length > 1)
                          Positioned(
                            right:
                                24.0, //  Đẩy avatar thứ hai sang trái một chút
                            child: _buildAvatar(assignedForArr[1]),
                          ),
                        if (assignedForArr.isNotEmpty)
                          Positioned(
                            right: 0,
                            child: _buildAvatar(assignedForArr[0]),
                          ),
                      ],
                    ),
                  ),
                )
              ],
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  Widget _buildAvatar(User user) {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0), // Khoảng cách giữa các avatar
      child: CircleAvatar(
        radius: 16,
        backgroundColor: Colors.white,
        child: user.imageUrl != null
            ? CircleAvatar(
                radius: 15,
                backgroundImage: NetworkImage(user.imageUrl!),
              )
            : CircleAvatar(
                radius: 15,
                backgroundColor: user.color,
                child: Text(user.name[0].toUpperCase()),
              ),
      ),
    );
  }

  Widget _buildPlusAvatar(int count) {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0),
      child: CircleAvatar(
        radius: 16,
        backgroundColor: Colors.grey,
        child: Center(
          child: Text('${count}+', style: const TextStyle(color: Colors.white)),
        ),
      ),
    );
  }
}
