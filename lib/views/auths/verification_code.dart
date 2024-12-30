import 'dart:io';

import 'package:email_otp/email_otp.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:project_manager/controllers/auth_controller.dart';
import 'package:project_manager/views/widgets/widgets.dart';

class VerificationCode extends StatelessWidget {
  VerificationCode(
      {super.key,
      required this.email,
      required this.name,
      required this.job,
      required this.image,
      required this.webImage,
      required this.password});

  final AuthController authController = Get.find();

  final List<TextEditingController> _controllers =
      List.generate(5, (index) => TextEditingController());

  final String name;
  final String job;
  final File? image;
  final Uint8List? webImage;
  final String email;
  final String password;

  @override
  Widget build(BuildContext context) {
    String code = '';
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'verification code'.tr,
              style: const TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 10),
            Text('we have sent the code verification to'.tr,
                style: const TextStyle(fontSize: 12, color: Colors.grey)),
            const SizedBox(height: 10),
            Text(email),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: List.generate(
                5,
                (index) => customTextFieldVerify(context, _controllers[index],
                    (value) {
                  code =
                      _controllers.map((controller) => controller.text).join();
                }),
              ),
            ),
            const SizedBox(height: 10),
            Obx(
              () => Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Resend code affter ${authController.time ~/ 60}:${authController.time % 60}',
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                OutlinedButton(
                  onPressed: () {
                    authController.resendCode(email);
                  },
                  child: Text('resend'.tr),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (EmailOTP.verifyOTP(otp: code)) {
                      authController.signUpWithEmailAndPassword(
                        name,
                        job,
                        image,
                        webImage,
                        email,
                        password,
                      );
                    } else {
                      Get.snackbar('Error', 'Incorrect code, try again',
                          backgroundColor: Colors.red);
                    }
                  },
                  child: Text('confirm'.tr),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
