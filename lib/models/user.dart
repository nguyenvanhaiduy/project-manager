import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class User {
  final String id;
  final String name;
  final String email;
  final Image? image;
  final Color? color;

  User({
    required this.id,
    required this.name,
    required this.email,
    this.image,
    this.color,
  });

  factory User.fromMap({required Map<String, dynamic> data}) {
    return User(
      id: data['id'],
      name: data['name'],
      email: data['email'],
      image: data['image'],
      color: data['color'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': const Uuid().v4(),
      'name': name,
      'email': email,
      'image': image,
      'color': color,
    };
  }
}
