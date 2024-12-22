import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:project_manager/views/auths/login_screen.dart';
import 'package:project_manager/views/projects/project_screen.dart';
import 'package:project_manager/models/user.dart';

class AuthController extends GetxController {
  final auth.FirebaseAuth _auth = auth.FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final _storage = GetStorage();
  var isShowPassword = true.obs;

  Rx<User?> currentUser = Rx<User?>(null);

  @override
  void onInit() {
    super.onInit();
    Future.delayed(const Duration(seconds: 1), () {
      checkIfUserIsLoggedIn();
    });
  }

  void checkIfUserIsLoggedIn() {
    final user = _auth.currentUser;
    if (user != null) {
      String? base64Image = _storage.read('user_${user.uid})_image');
      String? userColorHex = _storage.read('user_${user.uid}_color');
      Color? userColor = userColorHex != null
          ? Color(
              int.parse(userColorHex.substring(1, 7), radix: 16) + 0xFF000000)
          : null;
      currentUser.value = User(
        id: user.uid,
        name: user.displayName ?? '',
        email: user.email!,
        image: base64Image == null
            ? null
            : Image.memory(
                base64Decode(base64Image),
              ),
        color: userColor,
      );
      Get.offAll(() => const ProjectScreen());
    } else {
      Get.offAll(() => LoginScreen());
    }
  }

  Future<void> signInWithEmailAndPassword(String email, String password) async {
    try {
      final credentialUser = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      String? base64Image =
          _storage.read('user_${credentialUser.user!.uid}_image');
      String? userColorHex =
          _storage.read('user_${credentialUser.user!.uid}_color');
      Color? userColor = userColorHex != null
          ? Color(
              int.parse(userColorHex.substring(1, 7), radix: 16) + 0xFF000000)
          : null;
      currentUser.value = User(
        id: credentialUser.user!.uid,
        name: credentialUser.user!.displayName ?? '',
        email: credentialUser.user!.email ?? '',
        image: base64Image == null
            ? null
            : Image.memory(base64Decode(base64Image)),
        color: userColor,
      );
      Get.snackbar('Success', 'Login successful',
          backgroundColor: Colors.green);
      Get.offAll(() => const ProjectScreen());
    } catch (e) {
      Get.snackbar('Error', e.toString(), backgroundColor: Colors.red);
    }
  }

  Future<void> signUpWithEmailAndPassword(
      String name, File? image, String email, String password) async {
    try {
      final credentialUser = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);

      credentialUser.user?.updateDisplayName(name);
      String? base64Image;
      String? randomColorHex;
      Color? randomColor;
      if (image != null) {
        final bytes = await image.readAsBytes();
        base64Image = base64Encode(bytes);
        await _storage.write(
            'user_${credentialUser.user!.uid}_image', base64Image);
      } else {
        randomColor = _generateRandomColor();
        randomColorHex =
            '#${randomColor.value.toRadixString(16).substring(2, 8)}';
        await _storage.write(
          'user_${credentialUser.user!.uid}_color',
          randomColorHex,
        );
      }

      currentUser.value = User(
        id: credentialUser.user!.uid,
        name: name,
        email: email,
        image: base64Image == null
            ? null
            : Image.memory(base64Decode(base64Image)),
        color: randomColor,
      );

      _firestore.collection('users').add({
        'id': _auth.currentUser?.uid,
        'name': name,
        'email': email,
      });
      Get.back();
    } catch (e) {
      Get.snackbar('Error', e.toString(), backgroundColor: Colors.red);
    }
  }

  Future<void> resetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } catch (e) {
      Get.snackbar('Error', e.toString(), backgroundColor: Colors.red);
    }
  }

  Future<void> signOut() async {
    try {
      await _auth.signOut();
      Get.offAll(() => LoginScreen());
    } catch (e) {
      Get.snackbar('Error', e.toString());
    }
  }

  void showPassword() {
    isShowPassword.value = !isShowPassword.value;
  }

  Color _generateRandomColor() {
    final random = Random();
    return Color.fromRGBO(
      random.nextInt(256),
      random.nextInt(256),
      random.nextInt(256),
      1,
    );
  }
}
