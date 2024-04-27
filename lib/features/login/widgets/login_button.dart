import 'package:flutter/material.dart';
import 'package:pulchowk_login/features/controller/app_controller.dart';

class LoginButton extends StatelessWidget {
  const LoginButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: ElevatedButton(
            onPressed: AppController.instance.loginPressed,
            child: const Text('login')),
      ),
    );
  }
}
