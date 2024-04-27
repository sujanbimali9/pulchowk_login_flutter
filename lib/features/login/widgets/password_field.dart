import 'package:flutter/material.dart';
import 'package:pulchowk_login/features/controller/app_controller.dart';

class PasswordField extends StatelessWidget {
  const PasswordField({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: AppController.instance.passwordController,
      validator: (value) =>
          value == null || value.isEmpty ? 'password is required' : null,
      enableSuggestions: false,
      keyboardType: TextInputType.visiblePassword,
      obscureText: true,
    );
  }
}
