import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pulchowk_login/features/advance/screen/advance_screen.dart';
import 'package:pulchowk_login/features/controller/app_controller.dart';
import 'package:pulchowk_login/features/login/widgets/login_button.dart';
import 'package:pulchowk_login/features/login/widgets/password_field.dart';
import 'package:pulchowk_login/features/login/widgets/username_field.dart';

class HomePage extends GetView<AppController> {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:  const Text('Pulchowk Login'),
        actions: [
          TextButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const FilterScreen()));
              },
              child: const Text('Advance'))
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 5),
        child: Form(
          key: controller.formKey,
          child: Center(
            child: ListView(
              shrinkWrap: true,
              children: const [
                Text('Username', style: TextStyle(fontSize: 20)),
                SizedBox(height: 5),
                UsernameField(),
                SizedBox(height: 10),
                Text('Password', style: TextStyle(fontSize: 20)),
                SizedBox(height: 5),
                PasswordField(),
                SizedBox(height: 10),
                LoginButton()
              ],
            ),
          ),
        ),
      ),
    );
  }
}
