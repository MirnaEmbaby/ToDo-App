import 'package:flutter/material.dart';
import 'package:to_do_app/shared/components/components.dart';
import 'package:to_do_app/shared/components/constants.dart';
import 'package:to_do_app/shared/styles/colors.dart';

class NewTasksScreen extends StatelessWidget {
  const NewTasksScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.symmetric(
        horizontal: 12.0,
      ),
      itemBuilder: (context, index) => buildTaskItem(tasks[index]),
      separatorBuilder: (context, index) => const Divider(
        color: darkBlue,
        thickness: 0.5,
      ),
      itemCount: tasks.length,
    );
  }
}
