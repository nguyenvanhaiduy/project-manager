import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:project_manager/controllers/auth_controller.dart';
import 'package:project_manager/controllers/theme_controller.dart';
import 'package:project_manager/views/auths/register_screen.dart';
import 'package:project_manager/views/widgets/custom_drawer.dart';

final _authController = Get.find<AuthController>();

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});

  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final themeController = Get.find<ThemeController>();
  // final _authController = Get.find<AuthController>();

  final emailRegex = RegExp(
    r'^[{0-9}{a-z}{A-Z}.]+@[{0-9}{a-z}{A-Z}]+\.[{0-9}{a-z}{A-Z}]+$',
  );
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      drawer: CustomDrawer(isLogout: false),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Obx(() {
                return _buildUserProfileAvatar();
              }),
              const SizedBox(height: 100),
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
              }, themeController),
              const SizedBox(height: 20),
              Obx(() => customTextField(context, _passwordController,
                      'password', Icons.lock_outline,
                      obscureText: _authController.isShowPassword.value,
                      suffixIcon: _authController.isShowPassword.value
                          ? Icons.remove_red_eye
                          : Icons.remove_red_eye_outlined, (value) {
                    if (value == null || value.isEmpty) {
                      return 'you must enter a password'.tr;
                    }
                    if (value.length < 6) {
                      return 'password must be greater than 6 characters'.tr;
                    }
                    return null;
                  }, themeController)),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _authController.signInWithEmailAndPassword(
                          _emailController.text, _passwordController.text);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.all(15)),
                  child: Text('login'.tr),
                ),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    MaterialButton(
                      onPressed: () {
                        Get.to(() => RegisterScreen());
                      },
                      child: Text('register'.tr),
                    ),
                    MaterialButton(
                      onPressed: () {},
                      child: Text('forgot password'.tr),
                    ),
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

  Widget _buildUserProfileAvatar() {
    if (_authController.currentUser.value?.imageUrl != null) {
      return CircleAvatar(
        minRadius: 30,
        maxRadius: 50,
        backgroundImage:
            NetworkImage(_authController.currentUser.value!.imageUrl!),
        onBackgroundImageError: (_, __) => const Icon(
          Icons.account_circle,
          size: 50,
          color: Colors.grey,
        ),
      );
    } else if (_authController.currentUser.value?.color != null &&
        _authController.currentUser.value?.name != null) {
      return CircleAvatar(
        minRadius: 30,
        maxRadius: 50,
        backgroundColor: _authController.currentUser.value!.color,
        child: Text(
          _authController.currentUser.value!.name[0].toUpperCase(),
          style: const TextStyle(fontSize: 40),
        ),
      );
    } else {
      return const CircleAvatar(
        minRadius: 30,
        maxRadius: 50,
        backgroundImage: AssetImage('assets/images/logo.png'),
      );
    }
  }
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
                  // labelStyle:
                  //     const TextStyle(fontSize: 18, color: Colors.black),
                  contentPadding: const EdgeInsets.all(10),

                  border: const OutlineInputBorder(
                    borderSide: BorderSide.none,
                  ),
                  prefixIcon: Icon(icon),
                  suffixIcon: obscureText == null
                      ? null
                      : IconButton(
                          onPressed: _authController.showPassword,
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
