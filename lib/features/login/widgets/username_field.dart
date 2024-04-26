import 'package:flutter/material.dart';
import 'package:pulchowk_login/features/controller/app_controller.dart';

class UsernameField extends StatelessWidget {
  const UsernameField({
    super.key,
    required this.controller,
  });

  final AppController controller;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller.userNameController,
      validator: (value) =>
          value == null || value.isEmpty ? 'username can\'t be empty  ' : null,
      autocorrect: false,
      autofocus: false,
      enableSuggestions: false,
      expands: false,
      decoration: const InputDecoration(
          isDense: true,
          border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(10)),
              borderSide: BorderSide(color: Colors.black))),
    );
  }
}
