import 'package:flutter/material.dart';
import 'package:project_manager/models/user.dart';

class BuildAvatar extends StatelessWidget {
  const BuildAvatar({super.key, required this.user});
  final User user;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0), // Khoảng cách giữa các avatar
      child: CircleAvatar(
        radius: 16,
        backgroundColor: Colors.white,
        child: user.imageUrl != null
            ? CircleAvatar(
                radius: 15,
                backgroundImage: NetworkImage(user.imageUrl!),
              )
            : CircleAvatar(
                radius: 15,
                backgroundColor: user.color,
                child: Text(user.name[0].toUpperCase()),
              ),
      ),
    );
  }
}
