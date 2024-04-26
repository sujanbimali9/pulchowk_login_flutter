import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pulchowk_login/bindings/bindings.dart';
import 'package:pulchowk_login/features/login/screen/home_screen.dart';
import 'package:pulchowk_login/data/services/permission.dart';
import 'package:pulchowk_login/utils/theme/theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await handlePermisson();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      theme: AppTheme.theme,
      initialBinding: InitialBindings(),
      home: const HomePage(),
    );
  }
}
