import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:project_manager/controllers/auth_controller.dart';
import 'package:project_manager/controllers/drawer_controller.dart';
import 'package:project_manager/controllers/language_controller.dart';
import 'package:project_manager/controllers/theme_controller.dart';

Widget customTextButton(
    {required Widget child,
    required String title,
    required Function() onPress,
    ThemeMode? themeMode,
    String? name}) {
  final ThemeController themeController = Get.find();
  final LanguageController languageController = Get.find();
  return TextButton(
    style: TextButton.styleFrom(
      shape: const RoundedRectangleBorder(),
      backgroundColor: (themeMode != null
              ? (themeController.themeMode.value == themeMode)
              : (name == languageController.currentLocale.value.languageCode))
          ? const Color.fromARGB(255, 255, 175, 54)
          : null,
    ),
    onPressed: onPress,
    child: Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Row(
        children: [
          child,
          const SizedBox(width: 10),
          Text(title.tr),
        ],
      ),
    ),
  );
}

Widget customListTile(String title, String id, Widget leading,
    BorderRadiusGeometry borderRadiusGeometry, Function() onPressed,
    {Widget? trailing}) {
  final DrawerrController drawerController = Get.find();
  return Obx(
    () => ListTile(
      key: Key(id),
      title: Text(title),
      onTap: onPressed,
      selected: drawerController.selectedIndex.value == id,
      shape: RoundedRectangleBorder(
        borderRadius: borderRadiusGeometry,
      ),
      leading: leading,
      trailing: trailing,
    ),
  );
}

Widget customTextField(
  BuildContext context,
  TextEditingController textEditingController,
  String name,
  IconData icon,
  String? Function(String?) onValid,
  ThemeController themeController, {
  bool? obscureText = false,
  IconData? suffixIcon,
}) {
  final AuthController authController = Get.find();
  return Container(
    decoration: BoxDecoration(
      color: Theme.of(Get.context!).brightness == Brightness.light
          ? Colors.white
          : Colors.white10,
      borderRadius: BorderRadius.circular(20),
    ),
    margin: const EdgeInsets.symmetric(horizontal: 14.0),
    padding: const EdgeInsets.symmetric(vertical: 4),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 15,
          ),
          child: Text(
            name.tr,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ),
        Row(
          children: [
            Expanded(
              child: TextFormField(
                controller: textEditingController,
                obscureText: obscureText ?? false,
                style: TextStyle(
                    color: Theme.of(Get.context!).brightness == Brightness.light
                        ? Colors.black
                        : Colors.white),
                validator: onValid,
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.all(10),
                  border: const OutlineInputBorder(
                    borderSide: BorderSide.none,
                  ),
                  prefixIcon: Icon(icon),
                  suffixIcon: obscureText == null
                      ? null
                      : IconButton(
                          onPressed: authController.showPassword,
                          icon: Icon(
                            suffixIcon,
                            color: Colors.black,
                          ),
                        ),
                ),
              ),
            ),
          ],
        ),
      ],
    ),
  );
}
