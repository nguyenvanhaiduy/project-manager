import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:project_manager/controllers/drawer_controller.dart';
import 'package:project_manager/views/widgets/widgets.dart';

class TagTile extends StatelessWidget {
  TagTile({super.key, required this.isLogout});

  final bool isLogout;

  final DrawerrController drawerController = Get.find();

  void _handleTagAction() {
    drawerController.changeIndex('1');
    Get.back();
    Get.defaultDialog(onCancel: () => Get.back(), onConfirm: () => Get.back());
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
      ),
      clipBehavior: Clip.hardEdge,
      child: Material(
        child: isLogout
            ? customListTile(
                'tag'.tr,
                '1',
                const ImageIcon(
                  AssetImage('assets/icons/icons8-tag-96.png'),
                ),
                BorderRadius.circular(10),
                () => _handleTagAction(),
                trailing: const Icon(
                  Icons.arrow_forward_ios,
                  size: 20,
                ),
              )
            : Container(),
      ),
    );
  }
}
