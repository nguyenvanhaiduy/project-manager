import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:project_manager/controllers/auth/auth_controller.dart';
import 'package:project_manager/models/project.dart';
import 'package:project_manager/models/user.dart';
import 'package:project_manager/views/widgets/loading_overlay.dart';

class ProjectController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final AuthController _authController = Get.find();
  Rx<List<Project>> projects = Rx<List<Project>>([]);

  @override
  void onInit() {
    super.onInit();
    projects.bindStream(fetchProjects());
  }

  // Stream<List<Project>> fetchProjects() {
  //   return _firestore
  //       .collection('projects')
  //       .where('owner', isEqualTo: _authController.currentUser.value!.id)
  //       .snapshots()
  //       .map(
  //         (snapshot) => snapshot.docs
  //             .map((doc) => Project.fromMap(data: doc.data()))
  //             .toList(),
  //       )
  //       .mergeWith([
  //     _firestore
  //         .collection('projects')
  //         .where('users', arrayContains: _authController.currentUser.value!.id)
  //         .snapshots()
  //         .map((snapshot) => snapshot.docs
  //             .map((doc) => Project.fromMap(data: doc.data()))
  //             .toList())
  //   ]).map((list) => list.toSet().toList());
  // }

  Stream<List<Project>> fetchProjects() {
    Stream<List<Project>> test = _firestore
        .collection('projects')
        .where('users', arrayContains: _authController.currentUser.value!.id)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => Project.fromMap(data: doc.data()))
            .toList());
    print('maximum: ${test.length}');
    return test;
  }

  Future<void> addProject(Project project) async {
    try {
      LoadingOverlay.show();
      await _firestore
          .collection('projects')
          .doc(project.id)
          .set(project.toMap());
      await LoadingOverlay.hide();
      Get.back();
      Get.snackbar('Success', 'Add project success', colorText: Colors.green);
    } catch (e) {
      await LoadingOverlay.hide();
      Get.closeAllSnackbars();
      print('Error: $e');
      Get.snackbar('Error', 'Failed to add project', colorText: Colors.red);
    }
  }

  Future<void> updateProject(Project project) async {
    try {
      print('project: ${project.id}');
      print('${project.owner} equal ${_authController.currentUser.value!.id}');
      if (project.owner != _authController.currentUser.value!.id) {
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
      Get.closeAllSnackbars();
      print('Failed to update project: $e');
      Get.snackbar('Error', 'Failed to update project', colorText: Colors.red);
    }
  }

  Future<void> deleteProject(String projectId, String projectOwner) async {
    try {
      if (projectOwner != _authController.currentUser.value!.id) {
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
