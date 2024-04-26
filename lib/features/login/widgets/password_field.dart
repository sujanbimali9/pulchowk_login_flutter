import 'package:flutter/material.dart';
import 'package:pulchowk_login/features/controller/app_controller.dart';

class PasswordField extends StatelessWidget {
  const PasswordField({
    super.key,
    required this.controller,
  });

  final AppController controller;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller.passwordController,
      validator: (value) =>
          value == null || value.isEmpty ? 'password is required' : null,
      expands: false,
      autofocus: false,
      enableSuggestions: false,
      keyboardType: TextInputType.visiblePassword,
      obscureText: true,
      decoration: const InputDecoration(
          isDense: true,
          border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(10)),
              borderSide: BorderSide(color: Colors.black))),
    );
  }
}
