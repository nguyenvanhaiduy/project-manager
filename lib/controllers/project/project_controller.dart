import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:project_manager/controllers/auth/auth_controller.dart';
import 'package:project_manager/models/project.dart';
import 'package:project_manager/models/user.dart';
import 'package:rxdart/rxdart.dart' as rx;

class ProjectController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final AuthController authController = Get.find();
  Rx<List<Project>> projects = Rx<List<Project>>([]);

  @override
  void onInit() {
    super.onInit();
    projects.bindStream(fetchProjects());
  }

  Stream<List<Project>> fetchProjects() {
    return _firestore
        .collection('projects')
        .where('owner', isEqualTo: authController.currentUser.value!.id)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => Project.fromMap(data: doc.data()))
              .toList(),
        )
        .mergeWith([
      _firestore
          .collection('projects')
          .where('users', arrayContains: authController.currentUser.value!.id)
          .snapshots()
          .map((snapshot) => snapshot.docs
              .map((doc) => Project.fromMap(data: doc.data()))
              .toList())
    ]).map((list) => list.toSet().toList());
  }

  Future<void> addProject(Project project) async {
    try {
      Get.dialog(
        barrierDismissible: false,
        const Center(
          child: CircularProgressIndicator(),
        ),
      );
      await _firestore.collection('projects').add(project.toMap());
      Get.back();
      Get.closeAllSnackbars();
      Get.snackbar('Success', 'Add project success', colorText: Colors.green);
    } catch (e) {
      Get.back();
      Get.closeAllSnackbars();
      Get.snackbar('Error', 'Failed to add project', colorText: Colors.red);
    }
  }

  Future<void> updateProject(Project project) async {
    try {
      if (project.owner != authController.currentUser.value!.id) {
        Get.snackbar('Error', 'You are not the owner of this project',
            colorText: Colors.red);
        return;
      } else {
        await _firestore
            .collection('projects')
            .doc(project.id)
            .update(project.toMap());
        Get.snackbar('Success', 'Update project success',
            colorText: Colors.green);
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to update project', colorText: Colors.red);
    }
  }

  Future<void> deleteProject(String projectId, String projectOwner) async {
    try {
      if (projectOwner != authController.currentUser.value!.id) {
        Get.snackbar('Error', 'You are not the owner of this project',
            colorText: Colors.red);
        return;
      } else {
        await _firestore.collection('projects').doc(projectId).delete();
        Get.snackbar('Success', 'Delete project success',
            colorText: Colors.green);
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to delete project', colorText: Colors.red);
    }
  }

  Future<User?> getUser({
    String? userId,
    String? email,
  }) async {
    try {
      if (userId != null) {
        final doc = await _firestore
            .collection('users')
            .where('id', isEqualTo: userId)
            .get();
        return User.fromMap(data: doc.docs.first.data());
      } else if (email != null) {
        final doc = await _firestore
            .collection('users')
            .where('email', isEqualTo: email)
            .get();
        return User.fromMap(data: doc.docs.first.data());
      }
    } catch (e) {
      print('Load user failed: $e');
    }
    return null;
  }
}
