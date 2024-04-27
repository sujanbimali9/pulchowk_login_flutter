import 'package:flutter/material.dart';
import 'package:pulchowk_login/features/controller/app_controller.dart';

class UsernameField extends StatelessWidget {
  const UsernameField({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: AppController.instance.userNameController,
      validator: (value) =>
          value == null || value.isEmpty ? 'username can\'t be empty  ' : null,
    );
  }
}
