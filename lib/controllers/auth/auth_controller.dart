import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloudinary_sdk/cloudinary_sdk.dart';
import 'package:email_otp/email_otp.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
// import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:project_manager/bindings/project_binding.dart';
import 'package:project_manager/controllers/auth/resend_controller.dart';
import 'package:project_manager/views/auths/verification_code.dart';
import 'package:project_manager/models/user.dart';
import 'package:project_manager/views/auths/login_screen.dart';
import 'package:project_manager/views/projects/project_screen.dart';
import 'package:project_manager/views/widgets/loading_overlay.dart';

class AuthController extends GetxController {
  final auth.FirebaseAuth _auth = auth.FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late Cloudinary _cloudinary;

  final String cloudinaryCloudName = 'dcafv0pxk';
  final String cloudinaryApiKey = '644694945142125';
  final String cloudinaryApiSecret = 'pGI2hf7-AP3QsM1gA_rOpQqiTHk';

  RxBool isShowPassword = true.obs;
  RxBool isLogout = true.obs;
  Rx<User?> currentUser = Rx<User?>(null);

  final ResendController resendController = Get.put(ResendController());

  bool get resendActive => resendController.isResendActive.value;
  int get time => resendController.time.value;

  @override
  void onInit() {
    super.onInit();

    EmailOTP.config(
      appName: 'Project Manager',
      otpType: OTPType.numeric,
      otpLength: 5,
      emailTheme: EmailTheme.v3,
      expiry: 60000,
    );

    _cloudinary = Cloudinary.full(
      apiKey: cloudinaryApiKey,
      apiSecret: cloudinaryApiSecret,
      cloudName: cloudinaryCloudName,
    );

    // FirebaseMessaging.instance.getToken().then((token) {
    //   if (token != null) {
    //     _firestore
    //         .collection('users')
    //         .doc(currentUser.value!.id)
    //         .update({'fcmToken': token});
    //   }
    // });

    Future.delayed(const Duration(seconds: 1), () => checkIfUserIsLoggedIn());
  }

  void checkIfUserIsLoggedIn() async {
    final user = _auth.currentUser;
    if (user != null) {
      final userDoc = await _firestore.collection('users').doc(user.uid).get();
      if (userDoc.exists) {
        final userData = userDoc.data();
        currentUser.value = User.fromMap(data: userData!);
        Get.offAll(() => ProjectScreen(), binding: ProjectBinding());
        isLogout.value = false;
      }
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
        Get.back();
        Get.snackbar('Success', 'Login Success', colorText: Colors.green);
        Get.offAll(() => ProjectScreen(), binding: ProjectBinding());
        isLogout.value = false;
      }
    } on TimeoutException catch (e) {
      Get.back();
      Get.closeAllSnackbars();
      Get.snackbar('Error', e.toString(), colorText: Colors.red);
    } catch (e) {
      Get.back();
      Get.closeAllSnackbars();
      Get.snackbar('Error', e.toString(), colorText: Colors.red);
    }
  }

  void goToVerificationScreen(String name, String job, File? image,
      Uint8List? webImage, String email, String password) async {
    Get.dialog(
      barrierDismissible: false,
      const Center(
        child: CircularProgressIndicator(),
      ),
    );

    try {
      final querySnapShot = await _firestore
          .collection('users')
          .where('email', isEqualTo: email)
          .limit(1)
          .get();
      if (querySnapShot.docs.isEmpty) {
        if (await EmailOTP.sendOTP(email: email)) {
          Get.back();
          Get.to(() => VerificationCode(
                email: email,
                name: name,
                job: job,
                image: image,
                webImage: webImage,
                password: password,
              ));
          resendController.startTimer();
        } else {
          Get.back();
        }
      } else {
        Get.closeAllSnackbars();
        Get.back();
        Get.snackbar(
          'Error',
          'Email address already in use',
          colorText: Colors.red,
        );
      }
    } catch (e) {
      Get.closeAllSnackbars();
      Get.back();
      Get.snackbar(
        'Error',
        e.toString(),
        colorText: Colors.red,
      );
    }
  }

  void resendCode(String email) async {
    if (!resendController.isResendActive.value) return;
    await EmailOTP.sendOTP(email: email);
    resendController.resetTimer();
    resendController.startTimer();
  }

  Future<void> signUpWithEmailAndPassword(String name, String job, File? image,
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
        job: job,
        email: email,
        imageUrl: imageUrl,
        color: _generateRandomColor(),
      );
      currentUser.value = newUser;
      await _firestore.collection('users').doc(user.uid).set(newUser.toMap());
      Get.back();
      isLogout.value = false;
      Get.snackbar('Success', 'Login successful', colorText: Colors.green);
      Get.offAll(() => ProjectScreen(), binding: ProjectBinding());
    } on TimeoutException catch (e) {
      Get.back();
      Get.closeAllSnackbars();
      Get.snackbar('Error', e.toString(), colorText: Colors.red);
    } catch (e) {
      Get.back();
      Get.closeAllSnackbars();
      Get.snackbar('Error', e.toString(), colorText: Colors.red);
    }
  }

  Future<void> updateUser(
      {String? name,
      String? job,
      String? phone,
      File? image,
      Uint8List? imageWeb}) async {
    try {
      LoadingOverlay.show();
      String? imageUrl = await _uploadImage(image ?? imageWeb);
      await _auth.currentUser?.updateDisplayName(name);
      if (_auth.currentUser != null) {
        final userId = _auth.currentUser!.uid;
        await _firestore.collection('users').doc(userId).update({
          'name': name,
          'job': job,
          'phone': phone,
          'imageUrl': imageUrl ?? currentUser.value!.imageUrl,
        });
        currentUser.value = User(
          id: userId,
          name: name ?? currentUser.value!.name,
          phone: phone ?? currentUser.value!.phone,
          job: job ?? currentUser.value!.job,
          email: currentUser.value!.email,
          imageUrl: imageUrl ?? currentUser.value!.imageUrl,
          color: currentUser.value!.color,
        );
        await LoadingOverlay.hide();
        Get.closeAllSnackbars();
        Get.snackbar('Success', 'Update information successfull',
            colorText: Colors.green);
      } else {
        await LoadingOverlay.hide();
        Get.closeAllSnackbars();

        Get.snackbar('Error', 'Not found user', colorText: Colors.red);
      }
    } on auth.FirebaseAuthException catch (e) {
      await LoadingOverlay.hide();
      Get.closeAllSnackbars();
      Get.snackbar('Error', e.message ?? 'An error has occurred',
          colorText: Colors.red);
    } catch (e) {
      await LoadingOverlay.hide();
      Get.closeAllSnackbars();
      Get.snackbar('Error', e.toString(), colorText: Colors.red);
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
      isLogout.value = true;
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
