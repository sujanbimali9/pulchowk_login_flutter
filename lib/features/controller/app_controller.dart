import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:logger/logger.dart';
import 'package:logger/web.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pulchowk_login/data/repository/login.dart';
import 'package:pulchowk_login/data/services/background.dart';
import 'package:pulchowk_login/data/services/storage.dart';

class AppController extends GetxController {
  static AppController get instance => Get.find();
  final formKey = GlobalKey<FormState>();

  RxString userName = ''.obs;
  RxString password = ''.obs;
  var ipList = <String>[].obs;
  var isFilterEnabled = false.obs;

  var userNameController = TextEditingController();
  var passwordController = TextEditingController();
  var ipFilterController = TextEditingController();

  final logger = Logger(
      level: Level.debug,
      output: ConsoleOutput(),
      printer: PrettyPrinter(
        colors: true,
        printEmojis: false,
      ),
      filter: DevelopmentFilter());

  @override
  void onInit() {
    initializeHive();
    super.onInit();
  }

  @override
  void onClose() {
    Hive.closeAllBoxes();
    super.onClose();
  }

  void initialize() async {
    initializeHive();
  }

  void refreshData() {
    userName.value = HiveStorage.fromDataBox('username', defaultValue: '');
    password.value = HiveStorage.fromDataBox('password', defaultValue: '');
  }

  void refreshSwitch() {
    isFilterEnabled.value =
        HiveStorage.fromDataBox('isFilterEnabled', defaultValue: false);
  }

  void refreshIp() {
    ipList.value = HiveStorage.getAlIp;
  }

  void refreshAll() {
    refreshData();
    refreshIp();
    refreshSwitch();
  }

  void loginPressed() async {
    if (formKey.currentState!.validate()) {
      final response = await login(
          userNameController.text.trim(), passwordController.text.trim());

      logger.d(response);

      if (response.contains('You are signed in as {username}')) {
        addLoginData();
        final service = FlutterBackgroundService();
        if (!(await service.isRunning())) {
          await initializeBackgroundService();
          service.invoke('stopService');
          service.invoke('setAsForeground');
        }
      }
    }
  }

  Future<void> initializeHive() async {
    logger.d('initialize hive');

    final path = await getApplicationDocumentsDirectory();
    HiveStorage.defaultHiveStorage = path.path;

    refreshAll();

    userNameController.text = userName.value;
    passwordController.text = password.value;

    logger.d('username : ${userName.value} , password : ${password.value}');
  }

  void addLoginData() {
    logger.d('addPData');

    HiveStorage.addAllData({
      'username': userNameController.text.trim(),
      'password': passwordController.text.trim()
    });

    refreshData();
  }

  void deleteIP(int index) {
    HiveStorage.deleteIp = index;
    refreshIp();
  }

  void addIp() {
    logger.d('add Ip');
    if (ipFilterController.text.isNotEmpty &&
        (!ipList.contains(ipFilterController.text.trim()))) {
      HiveStorage.addIp = ipFilterController.text.trim();
      ipFilterController.clear();
      refreshIp();
    }
  }

  void change(bool value) {
    logger.d('change switch value to $value');
    HiveStorage.addData('isFilterEnabled', value);
    refreshSwitch();
  }
}
