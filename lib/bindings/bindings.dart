import 'package:get/get.dart';
import 'package:pulchowk_login/features/controller/app_controller.dart';

final class InitialBindings extends Bindings {
  @override
  void dependencies() {
    Get.put(AppController());
  }
}
