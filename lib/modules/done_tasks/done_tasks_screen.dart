import 'package:flutter/material.dart';

class DoneTasksScreen extends StatelessWidget {
  const DoneTasksScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        'Done tasks',
        style: TextStyle(
          fontSize: 25.0,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}