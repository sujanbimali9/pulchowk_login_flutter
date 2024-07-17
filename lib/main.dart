import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pulchowk_login/utils/theme/theme.dart';

import 'data/services/permission.dart';
import 'features/controller/app_controller.dart';
import 'features/login/screen/home_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await handlePermisson();
  Get.put(AppController());
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: AppTheme.theme,
      home: const HomePage(),
    );
  }
}
