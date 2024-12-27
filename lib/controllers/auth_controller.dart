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
  var isShowPassword = true.obs;

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

  Future<void> signInWithEmailAndPassword(String email, String password) async {
    try {
      final credentialUser = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
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
      Get.snackbar('Success', 'Login Success', backgroundColor: Colors.green);
      Get.offAll(() => const ProjectScreen());
    } catch (e) {
      Get.snackbar('Error', e.toString(), backgroundColor: Colors.red);
    }
  }

  Future<void> signUpWithEmailAndPassword(String name, File? image,
      Uint8List? webImage, String email, String password) async {
    try {
      final credentialUser = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      String? imageUrl;
      credentialUser.user!.updateDisplayName(name);
      if (image != null || webImage != null) {
        try {
          CloudinaryResponse? response;
          if (image != null) {
            response = await _cloudinary.uploadResource(
              CloudinaryUploadResource(
                  filePath: image.path,
                  resourceType: CloudinaryResourceType.auto),
            );
          } else if (webImage != null && !kIsWeb) {
            // final tempDir = await getTemporaryDirectory();
            // final tempFile = File(
            //     '${tempDir.path}/${const Uuid().v4()}${p.extension('file')}');
            // print('tempFile $tempFile');
            // await tempFile.writeAsBytes(webImage);
            // response = await _cloudinary.uploadResource(
            //   CloudinaryUploadResource(
            //       filePath: tempFile.path,
            //       resourceType: CloudinaryResourceType.auto),
            // );
            // tempFile.delete();
            response = await _cloudinary.uploadResource(
              CloudinaryUploadResource(
                fileBytes: webImage,
                resourceType: CloudinaryResourceType.auto,
              ),
            );
          } else if (kIsWeb && webImage != null) {
            response = await _cloudinary.uploadResource(
              CloudinaryUploadResource(
                fileBytes: webImage,
                resourceType: CloudinaryResourceType.auto,
              ),
            );
          }
          if (response != null && response.isSuccessful) {
            imageUrl = response.secureUrl;
            final user = credentialUser.user!;
            User newUser = User(
              id: user.uid,
              name: name,
              email: email,
              imageUrl: imageUrl,
              color: _generateRandomColor(),
            );
            await _firestore
                .collection('users')
                .doc(user.uid)
                .set(newUser.toMap());
            Get.snackbar('Success', 'Login successful',
                backgroundColor: Colors.green);
            Get.offAll(() => const ProjectScreen());
          } else {
            Get.snackbar('Error', 'Failed to upload image to Cloudinary',
                backgroundColor: Colors.red);
          }
        } catch (e) {
          Get.snackbar('Error', 'Failed to upload image to Cloudinary: $e',
              backgroundColor: Colors.red);
        }
      } else {
        final user = credentialUser.user!;
        User newUser = User(
          id: user.uid,
          name: name,
          email: email,
          imageUrl: imageUrl,
          color: _generateRandomColor(),
        );
        await _firestore.collection('users').doc(user.uid).set(newUser.toMap());
        Get.snackbar('Success', 'Login successful',
            backgroundColor: Colors.green);
        Get.offAll(() => const ProjectScreen());
      }
    } catch (e) {
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
