import 'package:flutter/material.dart';

class NewTasksScreen extends StatelessWidget {
  const NewTasksScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        'New tasks',
        style: TextStyle(
          fontSize: 25.0,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
