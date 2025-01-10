import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:project_manager/controllers/project/project_controller.dart';
import 'package:project_manager/views/projects/add_project_screen.dart';
import 'package:project_manager/views/projects/project_detail_screen.dart';
import 'package:project_manager/views/projects/components/card_custom.dart';
import 'package:project_manager/views/widgets/drawer/custom_drawer.dart';

class ProjectScreen extends StatelessWidget {
  ProjectScreen({super.key});

  final ProjectController projectController = Get.find();

  @override
  Widget build(BuildContext context) {
    // final double sizeWidth = MediaQuery.of(context).size.width * 0.05;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'your project'.tr,
        ),
      ),
      drawer: CustomDrawer(),
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // SizedBox(
          //   height: 40,
          //   child: Row(
          //     mainAxisAlignment: MainAxisAlignment.center,
          //     children: [
          //       Spacer(
          //         flex: kIsWeb ? 2 : 1,
          //       ),
          //       Expanded(
          //         flex: 10,
          //         child: Container(
          //           // color: Colors.purple,
          //           child: ListView(
          //             shrinkWrap: true,
          //             padding: const EdgeInsets.symmetric(horizontal: 0),
          //             scrollDirection: Axis.horizontal,
          //             children: [
          //               _customLable(context, label: 'all'.tr, ontap: () {}),
          //               SizedBox(
          //                 width: sizeWidth,
          //               ),
          //               _customLable(context,
          //                   label: 'not start'.tr, ontap: () {}),
          //               SizedBox(
          //                 width: sizeWidth,
          //               ),
          //               _customLable(context,
          //                   label: 'in progress'.tr, ontap: () {}),
          //               SizedBox(
          //                 width: sizeWidth,
          //               ),
          //               _customLable(context,
          //                   label: 'completed'.tr, ontap: () {}),
          //               SizedBox(
          //                 width: sizeWidth,
          //               ),
          //               _customLable(context,
          //                   label: 'late completed'.tr, ontap: () {}),
          //               SizedBox(
          //                 width: sizeWidth,
          //               ),
          //               _customLable(context,
          //                   label: 'unfinished'.tr, ontap: () {}),
          //             ],
          //           ),
          //         ),
          //       ),
          //       Spacer(
          //         flex: 1,
          //       ),
          //     ],
          //   ),
          // ),
          // const SizedBox(height: 10),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: (MediaQuery.of(context).size.width <= 640)
                  ? Obx(() => ListView.separated(
                        itemCount: projectController.projects.value.length,
                        separatorBuilder: (context, index) =>
                            const SizedBox(height: 20),
                        itemBuilder: (context, index) {
                          return CardCustom(
                            project: projectController.projects.value[index],
                            onTap: () {
                              Get.to(() => ProjectDetailScreen(
                                    project:
                                        projectController.projects.value[index],
                                  ));
                            },
                          );
                        },
                      ))
                  : Obx(() => GridView.builder(
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 20,
                          mainAxisSpacing: 20,
                          mainAxisExtent: kIsWeb ? 135 : 145,
                        ),
                        itemCount: projectController.projects.value.length,
                        itemBuilder: (context, index) {
                          return CardCustom(
                            project: projectController.projects.value[index],
                            onTap: () {
                              Get.to(
                                () => ProjectDetailScreen(
                                  project:
                                      projectController.projects.value[index],
                                ),
                              );
                            },
                          );
                        },
                      )),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.to(() => AddProjectScreen());
        },
        tooltip: 'add'.tr,
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: const Icon(
          Icons.add_outlined,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _customLable(BuildContext context,
      {required String label, required Function() ontap}) {
    return InkWell(
      borderRadius: BorderRadius.circular(15),
      splashColor: Colors.green,
      hoverColor: Colors.blue,
      highlightColor: Colors.purple,
      onTap: ontap,
      child: Container(
        height: 30,
        padding: const EdgeInsets.symmetric(horizontal: 15),
        decoration: BoxDecoration(
          color: Colors.red,
          borderRadius: BorderRadius.circular(15),
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: Theme.of(context).textTheme.bodyLarge!,
        ),
      ),
    );
  }
}
