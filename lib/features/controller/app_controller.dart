import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:logger/logger.dart';
import 'package:logger/web.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pulchowk_login/data/repository/login.dart';
import 'package:pulchowk_login/data/services/background.dart';

class AppController extends GetxController {
  static AppController get instance => Get.find();
  final formKey = GlobalKey<FormState>();

  late Box pBox;
  late Box<String> ipBox;

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
  InternalFinalCallback<void> get onDelete {
    Hive.closeAllBoxes();
    return super.onDelete;
  }

  @override
  void onClose() {
    Hive.closeAllBoxes();
    super.onClose();
  }

  void initialize() async {
    initializeHive();
  }
  // @override
  // void onReady() {
  //   log('onready');
  //   initializeHive();
  //   super.onReady();
  // }

  void refreshData() {
    userName.value = pBox.get('username', defaultValue: '');
    password.value = pBox.get('password', defaultValue: '');
  }

  void refreshSwitch() {
    isFilterEnabled.value = pBox.get('isFilterEnabled', defaultValue: false);
  }

  void refreshIp() {
    ipBox.isNotEmpty
        ? ipList.value = ipBox.getRange(0, ipBox.length)
        : ipList.clear();
  }

  void refreshHive() {
    refreshData();
    refreshIp();
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
          // await service.startService();
          service.invoke('setAsForeground');
        }
      }
    }
  }

  Future<void> initializeHive() async {
    logger.d('initialize hive');
    Hive.closeAllBoxes();
    final path = await getApplicationDocumentsDirectory();
    Hive.defaultDirectory = path.path;

    ipBox = Hive.box(name: 'filterIp');
    if (ipBox.isNotEmpty) {
      ipList.addAll(ipBox.getRange(0, ipBox.length));
    }

    pBox = Hive.box(name: 'data');
    userName.value = pBox.get('username', defaultValue: '');
    password.value = pBox.get('password', defaultValue: '');
    isFilterEnabled.value = pBox.get('isFilterEnabled', defaultValue: false);

    userNameController.text = userName.value;
    passwordController.text = password.value;
    logger.d('username : ${userName.value} , password : ${password.value}');
  }

  void addLoginData() {
    logger.d('addPData');
    pBox.putAll({
      'username': userNameController.text.trim(),
      'password': passwordController.text.trim()
    });
    refreshData();
  }

  void deleteIP(int index) {
    try {
      logger.d('delete ${ipBox[index]}');

      ipBox.deleteAt(index);
      refreshIp();
    } catch (e) {
      logger.e(e);
    }
  }

  // void deleteAllBox() {
  //   pBox.deleteFromDisk();
  //   ipBox.deleteFromDisk();
  // }

  void addIp() {
    logger.d('add Ip');
    if (ipFilterController.text.isNotEmpty) {
      ipBox.add(ipFilterController.text.trim());
      ipFilterController.clear();
      refreshIp();
    }
    // update();
  }

  void change(bool value) {
    logger.d('change switch value to $value');
    pBox.put('isFilterEnabled', value);
    refreshSwitch();
  }
}
