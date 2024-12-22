import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:project_manager/controllers/language_controller.dart';
import 'package:project_manager/controllers/theme_controller.dart';

final ThemeController themeController = Get.find();
final LanguageController languageController = Get.find();

Widget customTextButton(
    {required Widget child,
    required String title,
    required Function() onPress,
    ThemeMode? themeMode,
    String? name}) {
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
