import 'dart:ui';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_background_service_android/flutter_background_service_android.dart';
import 'package:logger/logger.dart';
import 'package:network_info_plus/network_info_plus.dart';
import 'package:pulchowk_login/features/controller/app_controller.dart';
import 'package:pulchowk_login/data/repository/login.dart';

final logger = Logger();

Future<void> initializeBackgroundService() async {
  final service = FlutterBackgroundService();
  final iosConfiguration = IosConfiguration(
    onForeground: onStart,
    onBackground: onIosBackground,
  );
  final androidConfiguration = AndroidConfiguration(
    onStart: onStart,
    isForegroundMode: true,
    initialNotificationContent: 'Background Service Initializing',
    foregroundServiceNotificationId: 999,
  );
  service.configure(
      iosConfiguration: iosConfiguration,
      androidConfiguration: androidConfiguration);
}

@pragma('vm:entry-point')
Future<void> onStart(ServiceInstance service) async {
  DartPluginRegistrant.ensureInitialized();

  try {
    if (service is AndroidServiceInstance) {
      service.on('setAsForeground').listen((event) async {
        await service.setAsForegroundService();
        if (await service.isForegroundService()) {
          await service.setForegroundNotificationInfo(
              title: 'Wifi State Service',
              content: 'Listening for wifi state change');
        }
      });
      service.on('stopService').listen((event) async {
        await service.stopSelf();
        await service.setAsForegroundService();
      });
    }
  } catch (e) {
    logger.e(e);
  }

  Connectivity()
      .onConnectivityChanged
      .listen((ConnectivityResult result) async {
    if (result == ConnectivityResult.wifi) {
      final network = NetworkInfo();
      final ip = await network.getWifiIP();

      ip != null
          ? AppController.instance.isFilterEnabled.value
              ? checkIp(ip)
                  ? await login(AppController.instance.userName.value,
                      AppController.instance.password.value)
                  : null
              : await login(AppController.instance.userName.value,
                  AppController.instance.password.value)
          : null;
    }
    if (service is AndroidServiceInstance) {
      if (await service.isForegroundService()) {
        service.setForegroundNotificationInfo(
          title: 'Listening for Wifi State Change',
          content: '$result',
        );
      }
      service.invoke('update');
    }
  });
}

@pragma('vm:entry-point')
Future<bool> onIosBackground(ServiceInstance service) async {
  DartPluginRegistrant.ensureInitialized();
  return true;
}

bool checkIp(String ip) {
  return AppController.instance.ipList.any((e) => ip.contains(e));
}
