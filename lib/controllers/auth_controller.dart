import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloudinary_sdk/cloudinary_sdk.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:project_manager/models/user.dart';
import 'package:project_manager/views/auths/login_screen.dart';
import 'package:project_manager/views/projects/project_screen.dart';
import 'package:flutter/foundation.dart';

class AuthController extends GetxController {
  final auth.FirebaseAuth _auth = auth.FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late Cloudinary _cloudinary;

  final String cloudinaryCloudName = 'dcafv0pxk';
  final String cloudinaryApiKey = '644694945142125';
  final String cloudinaryApiSecret = 'pGI2hf7-AP3QsM1gA_rOpQqiTHk';

  RxBool isShowPassword = true.obs;

  Rx<User?> currentUser = Rx<User?>(null);

  @override
  void onInit() {
    super.onInit();
    _cloudinary = Cloudinary.full(
      apiKey: cloudinaryApiKey,
      apiSecret: cloudinaryApiSecret,
      cloudName: cloudinaryCloudName,
    );
    Future.delayed(const Duration(seconds: 1), () => checkIfUserIsLoggedIn());
  }

  void checkIfUserIsLoggedIn() async {
    final user = _auth.currentUser;
    if (user != null) {
      final userDoc = await _firestore.collection('users').doc(user.uid).get();
      if (userDoc.exists) {
        final userData = userDoc.data();
        currentUser.value = User.fromMap(data: userData!);
      } else {
        currentUser.value = User(
            id: user.uid,
            name: user.displayName ?? '',
            email: user.email ?? '');
      }
      Get.offAll(() => const ProjectScreen());
    } else {
      Get.offAll(() => LoginScreen());
    }
  }

  Future<String?> _uploadImage(dynamic imageFile) async {
    if (imageFile == null) {
      return null;
    }
    try {
      CloudinaryResponse? response;
      if (imageFile is File) {
        response = await _cloudinary.uploadResource(CloudinaryUploadResource(
          filePath: imageFile.path,
          resourceType: CloudinaryResourceType.auto,
        ));
      } else if (imageFile is Uint8List) {
        response = await _cloudinary.uploadResource(CloudinaryUploadResource(
          fileBytes: imageFile,
          resourceType: CloudinaryResourceType.auto,
        ));
      }
      if (response != null && response.isSuccessful) {
        return response.secureUrl;
      } else {
        Get.snackbar('Error', 'Cloundiary upload failed: ${response?.error}');
        throw Exception('Cloundiary upload failed: ${response?.error}');
      }
    } catch (e) {
      Get.snackbar('Error', 'Error upload image: $e');
      throw Exception('Error upload image: $e');
    }
  }

  Future<void> signInWithEmailAndPassword(String email, String password) async {
    try {
      Get.dialog(
        barrierDismissible: false,
        const Center(
          child: CircularProgressIndicator(),
        ),
      );
      final credentialUser = await _auth
          .signInWithEmailAndPassword(email: email, password: password)
          .timeout(
        const Duration(seconds: 10),
        onTimeout: () {
          Get.back();
          throw TimeoutException('Login time out. Please try again.');
        },
      );

      final userDoc = await _firestore
          .collection('users')
          .doc(credentialUser.user!.uid)
          .get();
      if (userDoc.exists) {
        currentUser.value = User.fromMap(data: userDoc.data()!);
      } else {
        final user = credentialUser.user!;
        currentUser.value = User(
            id: user.uid,
            name: user.displayName ?? '',
            email: user.email ?? '');
      }
      Get.back();
      Get.snackbar('Success', 'Login Success', backgroundColor: Colors.green);
      Get.offAll(() => const ProjectScreen());
    } on TimeoutException catch (e) {
      Get.back();
      Get.closeAllSnackbars();
      Get.snackbar('Error', e.toString(), backgroundColor: Colors.red);
    } catch (e) {
      Get.back();
      Get.closeAllSnackbars();
      Get.snackbar('Error', e.toString(), backgroundColor: Colors.red);
    }
  }

  Future<void> signUpWithEmailAndPassword(String name, File? image,
      Uint8List? webImage, String email, String password) async {
    try {
      Get.dialog(
        barrierDismissible: false,
        const Center(
          child: CircularProgressIndicator(),
        ),
      );
      final credentialUser = await _auth
          .createUserWithEmailAndPassword(email: email, password: password)
          .timeout(
        const Duration(seconds: 10),
        onTimeout: () {
          Get.back();
          throw TimeoutException('Sign up time out. Please try again.');
        },
      );
      String? imageUrl;
      credentialUser.user!.updateDisplayName(name);
      imageUrl = await _uploadImage(image ?? webImage);
      final user = credentialUser.user!;
      User newUser = User(
        id: user.uid,
        name: name,
        email: email,
        imageUrl: imageUrl,
        color: _generateRandomColor(),
      );
      currentUser.value = newUser;
      await _firestore.collection('users').doc(user.uid).set(newUser.toMap());
      Get.back();
      Get.snackbar('Success', 'Login successful',
          backgroundColor: Colors.green);
      Get.offAll(() => const ProjectScreen());
      Get.back();
    } on TimeoutException catch (e) {
      Get.back();
      Get.closeAllSnackbars();
      Get.snackbar('Error', e.toString(), backgroundColor: Colors.red);
    } catch (e) {
      Get.back();
      Get.closeAllSnackbars();
      Get.snackbar('Error', e.toString(), backgroundColor: Colors.red);
    }
  }

  Future<void> resetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
      Get.snackbar('Reset password', 'Please choose new password in email');
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
