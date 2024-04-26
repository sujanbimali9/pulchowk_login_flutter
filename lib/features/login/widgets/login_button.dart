import 'package:flutter/material.dart';
import 'package:pulchowk_login/features/controller/app_controller.dart';

class LoginButton extends StatelessWidget {
  const LoginButton({
    super.key,
    required this.controller,
  });

  final AppController controller;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: ElevatedButton(
          style: ElevatedButton.styleFrom(
              maximumSize: const Size(200, 60),
              minimumSize: const Size(170, 50)),
          onPressed: controller.loginPressed,
          child: const Text('login')),
    );
  }
}
