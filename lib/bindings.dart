import 'package:get/get.dart';
import 'package:pulchowk_login/storage.dart';

final class InitialBindings extends Bindings {
  @override
  void dependencies() {
    Get.put(Storage());
  }
}
