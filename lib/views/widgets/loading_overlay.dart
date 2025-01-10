import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoadingOverlay {
  static Future<void> show() async {
    await Get.dialog(
      barrierDismissible: false,
      const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  static Future<void> hide() async {
    if (Get.isDialogOpen ?? false) {
      Get.back();
    }
  }
}
