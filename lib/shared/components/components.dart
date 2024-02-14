import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:to_do_app/shared/cubit/cubit.dart';
import 'package:to_do_app/shared/styles/colors.dart';

Widget? defaultFormField({
  required TextEditingController controller,
  required TextInputType type,
  Function? onSubmit,
  Function? onChanged,
  Function? onTap,
  bool isPassword = false,
  required Function validate,
  required String label,
  required IconData prefix,
  required bool hasSuffix,
  IconData? suffix,
  Function? suffixPressed,
  bool isClickable = true,
}) =>
    TextFormField(
      controller: controller,
      keyboardType: type,
      obscureText: isPassword,
      enabled: isClickable,
      onFieldSubmitted: (s) => onSubmit!(s),
      onChanged: (s) => onChanged!(s),
      onTap: () => onTap!(),
      validator: (s) => validate(s),
      decoration: InputDecoration(
        labelText: label,
        icon: hasSuffix ? Icon(suffix) : null,
        prefixIcon: Icon(prefix),
        suffixIcon: suffix != null
            ? IconButton(
                onPressed: () => suffixPressed!(),
                icon: Icon(suffix),
              )
            : null,
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(
            color: darkBlue,
            width: 2.0,
          ),
        ),
        border: const OutlineInputBorder(),
      ),
    );

Widget buildTaskItem(Map model, context) => Dismissible(
      key: Key(model['id'].toString()),
      onDismissed: (direction) {
        AppCubit.get(context).deleteData(id: model['id']);
      },
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Row(
          children: [
            CircleAvatar(
              radius: 40.0,
              backgroundColor: lightBlue,
              child: Text('${model['time']}'),
            ),
            const SizedBox(
              width: 20.0,
            ),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${model['title']}',
                    style: const TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    '${model['date']}',
                    style: const TextStyle(color: Colors.blueGrey),
                  ),
                ],
              ),
            ),
            const SizedBox(
              width: 20.0,
            ),
            IconButton(
              onPressed: () {
                AppCubit.get(context)
                    .updateData(status: 'done', id: model['id']);
              },
              icon: const Icon(
                Icons.check_box,
                color: Colors.green,
              ),
            ),
            IconButton(
              onPressed: () {
                AppCubit.get(context)
                    .updateData(status: 'archived', id: model['id']);
              },
              icon: const Icon(
                Icons.archive,
                color: Colors.black45,
              ),
            ),
          ],
        ),
      ),
    );

Widget tasksBuilder({required List<Map> tasks}) => ConditionalBuilder(
      condition: tasks.isNotEmpty,
      builder: (BuildContext context) => ListView.separated(
        padding: const EdgeInsets.symmetric(
          horizontal: 12.0,
        ),
        itemBuilder: (context, index) => buildTaskItem(tasks[index], context),
        separatorBuilder: (context, index) => const Divider(
          color: darkBlue,
          thickness: 0.5,
        ),
        itemCount: tasks.length,
      ),
      fallback: (context) => const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.menu,
              color: Colors.black12,
              size: 70,
            ),
            Text("No Tasks Yet",
                style: TextStyle(
                  color: Colors.black12,
                  fontSize: 28,
                )),
          ],
        ),
      ),
    );
