import 'package:flutter/material.dart';

class ArchivedTasksScreen extends StatelessWidget {
  const ArchivedTasksScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        'Archived tasks',
        style: TextStyle(
          fontSize: 25.0,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}