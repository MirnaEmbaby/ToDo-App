import 'package:flutter/material.dart';

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
        icon: Icon(suffix),
        prefixIcon: Icon(prefix),
        suffixIcon: suffix != null
            ? IconButton(
                onPressed: () => suffixPressed!(),
                icon: Icon(suffix),
              )
            : null,
        border: const OutlineInputBorder(),
      ),
    );
