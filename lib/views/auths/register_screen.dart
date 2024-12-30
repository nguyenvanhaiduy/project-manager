import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';

import 'package:project_manager/controllers/auth_controller.dart';
import 'package:project_manager/controllers/theme_controller.dart';
import 'package:project_manager/views/widgets/widgets.dart';

final _authController = Get.find<AuthController>();

class RegisterScreen extends StatelessWidget {
  RegisterScreen({super.key});

  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _jobController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _themeController = Get.find<ThemeController>();
  final emailRegex =
      RegExp(r'^[{0-9}{a-z}{A-Z}.]+@[{0-9}{a-z}{A-Z}]+\.[{0-9}{a-z}{A-Z}]+$');
  final Rx<File?> _image = Rx<File?>(null);
  final Rx<Uint8List?> _webImage = Rx<Uint8List?>(null);

  Future<void> _pickImage(ImageSource source) async {
    print(kIsWeb);

    if (kIsWeb && source == ImageSource.gallery) {
      print('running on web');
      try {
        FilePickerResult? result = await FilePicker.platform.pickFiles(
          type: FileType.image,
          allowMultiple: false,
        );
        if (result != null && result.files.isNotEmpty) {
          PlatformFile file = result.files.first;
          if (file.bytes != null) {
            _webImage.value = file.bytes;
            _image.value = null;
          }
        }
      } catch (e) {
        print('Error loading file from web $e');
        Get.snackbar('Error', 'Error loading file: $e');
      }
    } else {
      print('running on web');
      try {
        final pickedFile = await ImagePicker().pickImage(source: source);
        if (pickedFile != null) {
          _image.value = File(pickedFile.path);
          _webImage.value = null;
        }
      } catch (e) {
        print('Error picking iamge: $e');
        Get.snackbar('Error', 'Error picking iamge: $e');
      }
    }
  }

  void _showImageSourceDialog(BuildContext context) {
    Get.dialog(
      barrierDismissible: true,
      Center(
        child: Material(
          borderRadius: BorderRadius.circular(10),
          clipBehavior: Clip.hardEdge,
          child: SizedBox(
            width: 300,
            child: kIsWeb
                ? Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      customTextButton(
                          child: const Icon(Icons.photo_library),
                          title: 'galery'.tr,
                          onPress: () {
                            _pickImage(ImageSource.gallery);
                            Get.back();
                          })
                    ],
                  )
                : Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      customTextButton(
                          child: const Icon(Icons.camera),
                          title: 'camera'.tr,
                          onPress: () {
                            _pickImage(ImageSource.camera);
                            Get.back();
                          }),
                      customTextButton(
                          child: const Icon(Icons.photo_library),
                          title: 'galery'.tr,
                          onPress: () {
                            _pickImage(ImageSource.gallery);
                            Get.back();
                          })
                    ],
                  ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Form(
          key: _formKey,
          child: SizedBox(
            width: 400,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  GestureDetector(
                    onTap: () {
                      _showImageSourceDialog(context);
                    },
                    child: Obx(
                      () {
                        if (_image.value != null) {
                          return CircleAvatar(
                            minRadius: 20,
                            maxRadius: 50,
                            backgroundImage: FileImage(_image.value!),
                          );
                        } else if (kIsWeb) {
                          if (_webImage.value != null) {
                            return CircleAvatar(
                              minRadius: 20,
                              maxRadius: 50,
                              backgroundImage: MemoryImage(_webImage.value!),
                            );
                          }
                        }
                        return const CircleAvatar(
                          minRadius: 20,
                          maxRadius: 50,
                          backgroundImage: AssetImage('assets/images/logo.png'),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 20),
                  customTextField(context, _nameController, 'fullname',
                      Icons.person_outline, (value) {
                    if (value == null || value.isEmpty) {
                      return 'you must enter your full name'.tr;
                    }
                    return null;
                  }, _themeController),
                  const SizedBox(height: 20),
                  customTextField(context, _jobController, 'job', Icons.work,
                      (value) {
                    if (value == null || value.isEmpty) {
                      return 'you must enter your job'.tr;
                    }
                    return null;
                  }, _themeController),
                  const SizedBox(height: 20),
                  // const Spacer(),
                  customTextField(
                    context,
                    _emailController,
                    'email',
                    Icons.email_outlined,
                    (value) {
                      if (value == null || value.isEmpty) {
                        return 'you must enter your email'.tr;
                      }

                      if (!emailRegex.hasMatch(value)) {
                        return 'you must enter a valid email'.tr;
                      }
                      return null;
                    },
                    _themeController,
                    keyboardType: TextInputType.emailAddress,
                  ),
                  const SizedBox(height: 20),

                  Obx(() => customTextField(context, _passwordController,
                          'password', Icons.lock_outline,
                          obscureText: _authController.isShowPassword.value,
                          suffixIcon: _authController.isShowPassword.value
                              ? Icons.remove_red_eye
                              : Icons.remove_red_eye_outlined, (value) {
                        if (value == null || value.isEmpty) {
                          return 'you must enter password'.tr;
                        }
                        if (value.length < 6) {
                          return 'password must be greater than 6 characters'
                              .tr;
                        }
                        return null;
                      }, _themeController)),
                  const SizedBox(height: 20),
                  Obx(
                    () => customTextField(context, _confirmPasswordController,
                        'confirm password'.tr, Icons.lock_outline,
                        obscureText: _authController.isShowPassword.value,
                        suffixIcon: _authController.isShowPassword.value
                            ? Icons.remove_red_eye
                            : Icons.remove_red_eye_outlined, (value) {
                      if (value == null || value.isEmpty) {
                        return 'you must enter confirm password'.tr;
                      }
                      if (value != _passwordController.text) {
                        return 'password and confirm password must be same'.tr;
                      }
                      return null;
                    }, _themeController),
                  ),
                  const SizedBox(height: 20),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    width: double.infinity,
                    height: kIsWeb ? 50 : null,
                    child: ElevatedButton(
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          _authController.goToVerificationScreen(
                            _nameController.text,
                            _jobController.text,
                            _image.value,
                            _webImage.value,
                            _emailController.text,
                            _passwordController.text,
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.all(15)),
                      child: Text('register'.tr),
                    ),
                  ),
                  const SizedBox(height: 20),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('You have already an account?'.tr),
                        MaterialButton(
                          onPressed: () {
                            Get.back();
                          },
                          child: Text('login'.tr),
                        )
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
