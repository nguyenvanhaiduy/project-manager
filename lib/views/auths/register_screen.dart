import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import 'package:project_manager/controllers/auth_controller.dart';
import 'package:project_manager/controllers/theme_controller.dart';
import 'package:project_manager/views/auths/login_screen.dart';
import 'package:project_manager/views/widgets/widgets.dart';

final _authController = Get.find<AuthController>();

// ignore: must_be_immutable
class RegisterScreen extends StatelessWidget {
  RegisterScreen({super.key});

  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _themeController = Get.find<ThemeController>();
  final emailRegex =
      RegExp(r'^[{0-9}{a-z}{A-Z}.]+@[{0-9}{a-z}{A-Z}]+\.[{0-9}{a-z}{A-Z}]+$');
  final Rx<File?> _image = Rx<File?>(null);

  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await ImagePicker().pickImage(source: source);
    if (pickedFile != null) {
      _image.value = File(pickedFile.path);
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
            child: Column(
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
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 50),
              GestureDetector(
                onTap: () {
                  _showImageSourceDialog(context);
                },
                child: Obx(() {
                  if (_image.value != null) {
                    return CircleAvatar(
                      minRadius: 20,
                      maxRadius: 50,
                      backgroundImage: FileImage(_image.value!),
                    );
                  } else {
                    return const CircleAvatar(
                      minRadius: 20,
                      maxRadius: 50,
                      backgroundImage: AssetImage('assets/images/logo.png'),
                    );
                  }
                }),
              ),
              const SizedBox(height: 65),
              customTextField(
                  context, _nameController, 'fullname', Icons.person_outline,
                  (value) {
                if (value == null || value.isEmpty) {
                  return 'you must enter your full name'.tr;
                }
                return null;
              }, _themeController),
              const SizedBox(height: 20),
              // const Spacer(),
              customTextField(
                  context, _emailController, 'email', Icons.email_outlined,
                  (value) {
                if (value == null || value.isEmpty) {
                  return 'you must enter your email'.tr;
                }

                if (!emailRegex.hasMatch(value)) {
                  return 'you must enter a valid email'.tr;
                }
                return null;
              }, _themeController),
              const SizedBox(height: 20),

              Obx(() => customTextField(context, _passwordController,
                      'password', Icons.lock_outline,
                      obscureText: _authController.isShowPassword.value,
                      suffixIcon: _authController.isShowPassword.value
                          ? Icons.remove_red_eye
                          : Icons.remove_red_eye_outlined, (value) {
                    if (value == null || value.isEmpty) {
                      return 'you must enter your password'.tr;
                    }
                    if (value.length < 6) {
                      return 'password must be greater than 6 characters'.tr;
                    }
                    return null;
                  }, _themeController)),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _authController.signUpWithEmailAndPassword(
                        _nameController.text,
                        _image.value,
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
              // const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}

// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:image_picker/image_picker.dart';
// import 'dart:io';

// import 'package:project_manager/controllers/auth_controller.dart';
// import 'package:project_manager/controllers/theme_controller.dart';
// import 'package:project_manager/views/auths/login_screen.dart';

// final _authController = Get.find<AuthController>();

// class RegisterScreen extends StatelessWidget {
//   RegisterScreen({super.key});

//   final _formKey = GlobalKey<FormState>();
//   final _nameController = TextEditingController();
//   final _emailController = TextEditingController();
//   final _passwordController = TextEditingController();
//   final _themeController = Get.find<ThemeController>();
//   final emailRegex = RegExp(
//     r'^[{0-9}{a-z}{A-Z}.]+@[{0-9}{a-z}{A-Z}]+\.[{0-9}{a-z}{A-Z}]+$',
//   );

//   final Rx<File?> _image = Rx<File?>(null);

//   Future<void> _pickImage(ImageSource source) async {
//     final pickedFile = await ImagePicker().pickImage(source: source);
//     if (pickedFile != null) {
//       _image.value = File(pickedFile.path);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(),
//       body: Form(
//         key: _formKey,
//         child: SingleChildScrollView(
//           child: Column(
//             children: [
//               const SizedBox(height: 50),
//               Obx(() {
//                 if (_image.value != null) {
//                   return CircleAvatar(
//                     minRadius: 20,
//                     maxRadius: 50,
//                     backgroundImage: FileImage(_image.value!),
//                   );
//                 } else if (_nameController.text.isNotEmpty) {
//                   return CircleAvatar(
//                     minRadius: 20,
//                     maxRadius: 50,
//                     backgroundColor: Colors.blue, // You can change the color
//                     child: Text(
//                       _nameController.text[0].toUpperCase(),
//                       style: const TextStyle(fontSize: 40, color: Colors.white),
//                     ),
//                   );
//                 } else {
//                   return const CircleAvatar(
//                     minRadius: 20,
//                     maxRadius: 50,
//                     backgroundImage: AssetImage('assets/images/logo.png'),
//                   );
//                 }
//               }),
//               const SizedBox(height: 10),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   IconButton(
//                     icon: const Icon(Icons.camera_alt),
//                     onPressed: () => _pickImage(ImageSource.camera),
//                   ),
//                   IconButton(
//                     icon: const Icon(Icons.photo_library),
//                     onPressed: () => _pickImage(ImageSource.gallery),
//                   ),
//                 ],
//               ),
//               const SizedBox(height: 65),
//               customTextField(
//                   context, _nameController, 'fullname', Icons.person_outline,
//                   (value) {
//                 if (value == null || value.isEmpty) {
//                   return 'you must enter your full name'.tr;
//                 }
//                 return null;
//               }, _themeController),
//               const SizedBox(height: 20),
//               customTextField(
//                   context, _emailController, 'email', Icons.email_outlined,
//                   (value) {
//                 if (value == null || value.isEmpty) {
//                   return 'you must enter your email'.tr;
//                 }

//                 if (!emailRegex.hasMatch(value)) {
//                   return 'you must enter a valid email'.tr;
//                 }
//                 return null;
//               }, _themeController),
//               const SizedBox(height: 20),
//               Obx(() => customTextField(context, _passwordController,
//                       'password', Icons.lock_outline,
//                       obscureText: _authController.isShowPassword.value,
//                       suffixIcon: _authController.isShowPassword.value
//                           ? Icons.remove_red_eye
//                           : Icons.remove_red_eye_outlined, (value) {
//                     if (value == null || value.isEmpty) {
//                       return 'you must enter your password'.tr;
//                     }
//                     if (value.length < 6) {
//                       return 'password must be greater than 6 characters'.tr;
//                     }
//                     return null;
//                   }, _themeController)),
//               const SizedBox(height: 20),
//               Container(
//                 padding: const EdgeInsets.symmetric(horizontal: 15),
//                 width: double.infinity,
//                 child: ElevatedButton(
//                   onPressed: () {
//                     if (_formKey.currentState!.validate()) {
//                       _authController.signUpWithEmailAndPassword(
//                         _nameController.text,
//                         _emailController.text,
//                         _passwordController.text,
//                       );
//                     }
//                   },
//                   style: ElevatedButton.styleFrom(
//                       padding: const EdgeInsets.all(15)),
//                   child: Text('register'.tr),
//                 ),
//               ),
//               const SizedBox(height: 20),
//               Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 15.0),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Text('You have already an account?'.tr),
//                     MaterialButton(
//                       onPressed: () {
//                         Get.back();
//                       },
//                       child: Text('login'.tr),
//                     )
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
