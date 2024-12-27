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


/**
 * 
 * 
 * class AuthController extends GetxController {
  final auth.FirebaseAuth _auth = auth.FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  // Khai báo cloudinary instance
  late Cloudinary _cloudinary;

  // Các thông tin cấu hình Cloudinary
  final String cloudinaryCloudName = 'dcafv0pxk';
  final String cloudinaryApiKey = '644694945142125';
  final String cloudinaryApiSecret = 'pGI2hf7-AP3QsM1gA_rOpQqiTHk';

  var isShowPassword = true.obs;

  Rx<User?> currentUser = Rx<User?>(null);

  @override
  void onInit() {
    super.onInit();
    _cloudinary = Cloudinary.full(
        cloudName: cloudinaryCloudName,
        apiKey: cloudinaryApiKey,
        apiSecret: cloudinaryApiSecret);
    Future.delayed(const Duration(seconds: 1), () {
      checkIfUserIsLoggedIn();
    });
  }

  void checkIfUserIsLoggedIn() async {
    final user = _auth.currentUser;
    print(user);
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
      final userdoc = await _firestore
          .collection('users')
          .doc(credentialUser.user!.uid)
          .get();
      if (userdoc.exists) {
        currentUser.value = User.fromMap(data: userdoc.data()!);
      } else {
        currentUser.value = User(
          id: credentialUser.user!.uid,
          name: credentialUser.user!.displayName ?? '',
          email: credentialUser.user!.email ?? '',
        );
      }
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

      String? imageUrl;
      if (image != null) {
        // Tải ảnh lên Cloudinary
        try {
          // ignore: deprecated_member_use
          final response = await _cloudinary.uploadFile(
            filePath: image.path,
            resourceType: CloudinaryResourceType.image,
          );
          if (response.isSuccessful) {
            imageUrl = response.secureUrl;
          } else {
            Get.snackbar('Error', 'Failed to upload image to Cloudinary',
                backgroundColor: Colors.red);
            return;
          }
        } catch (e) {
          Get.snackbar('Error', 'Failed to upload image to Cloudinary: $e',
              backgroundColor: Colors.red);
          return;
        }
      }
      credentialUser.user?.updateDisplayName(name);
      Color? randomColor = _generateRandomColor();
      final user = credentialUser.user!;
      final newUser = User(
          id: user.uid,
          name: name,
          email: email,
          imageUrl: imageUrl,
          color: randomColor);

      await _firestore
          .collection('users')
          .doc(credentialUser.user!.uid)
          .set(newUser.toMap());
      Get.snackbar('Success', 'Login successful',
          backgroundColor: Colors.green);
      Get.offAll(() => const ProjectScreen());
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
 */