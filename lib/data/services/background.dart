import 'dart:io';
import 'dart:ui';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:logger/logger.dart';
import 'package:network_info_plus/network_info_plus.dart';

import 'package:pulchowk_login/data/repository/login.dart';
import 'package:pulchowk_login/data/services/storage.dart';
import 'package:pulchowk_login/utils/helper/show_toast.dart';

final logger = Logger();

Future<void> initializeBackgroundService() async {
  const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'login', 'Initializing',
      importance: Importance.low,
      description: 'Initializing BackgroundService');

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  if (Platform.isIOS || Platform.isAndroid) {
    await flutterLocalNotificationsPlugin.initialize(
      const InitializationSettings(
        iOS: DarwinInitializationSettings(),
        android: AndroidInitializationSettings('ic_bg_service_small'),
      ),
    );
  }
  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);

  final service = FlutterBackgroundService();

  final androidConfiguration = AndroidConfiguration(
    onStart: onStart,
    autoStart: true,
    isForegroundMode: true,
    notificationChannelId: 'login',
    initialNotificationTitle: 'Background Services',
    initialNotificationContent: 'Initializing',
    foregroundServiceNotificationId: 888,
  );

  final iosConfiguration = IosConfiguration(
    autoStart: true,
    onForeground: onStart,
    onBackground: onIosBackground,
  );

  service.configure(
      iosConfiguration: iosConfiguration,
      androidConfiguration: androidConfiguration);
}

@pragma('vm:entry-point')
Future<void> onStart(ServiceInstance service) async {
  DartPluginRegistrant.ensureInitialized();
  WidgetsFlutterBinding.ensureInitialized();
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  try {
    if (service is AndroidServiceInstance) {
      service.on('setAsForeground').listen((event) async {
        await service.setAsForegroundService();
      });
    }
    service.on('stopService').listen((event) {
      service.stopSelf();
    });
  } catch (e) {
    logger.e(e);
  }

  if (service is AndroidServiceInstance) {
    if (await service.isForegroundService()) {
      Connectivity()
          .onConnectivityChanged
          .listen((ConnectivityResult result) async {
        flutterLocalNotificationsPlugin.show(
          888,
          "listening for wifi change",
          'state is ${result.name}',
          const NotificationDetails(
            android: AndroidNotificationDetails(
              'login',
              'listening for wifi change',
              icon: 'ic_bg_service_small',
              ongoing: true,
            ),
          ),
        );

        logger.d('connectivity is ${result.name}');

        service.setForegroundNotificationInfo(
          title: "listening for wifi change",
          content: "state is ${result.name}",
        );

        if (result == ConnectivityResult.wifi) {
          final network = NetworkInfo();
          final ip = await network.getWifiIP();
          logger.d('ip is $ip');

          if (ip != null) {
            if (HiveStorage.fromDataBox('isFilterEnabled',
                defaultValue: false)) {
              if (checkIp(ip)) {
                logger.e(true);
                BackgroundService.showToast(await login(
                  HiveStorage.fromDataBox('username'),
                  HiveStorage.fromDataBox('password'),
                ));
              }
              logger.e(ip);
            } else {
              BackgroundService.showToast(await login(
                HiveStorage.fromDataBox('username'),
                HiveStorage.fromDataBox('password'),
              ));
            }
          }
        } else {
          BackgroundService.showToast('connected to ${result.name}');
        }
      });

      service.invoke('update');
    }
  }
}

@pragma('vm:entry-point')
Future<bool> onIosBackground(ServiceInstance service) async {
  WidgetsFlutterBinding.ensureInitialized();
  DartPluginRegistrant.ensureInitialized();
  logger.d('iosBackground');
  return true;
}

bool checkIp(String ip) {
  return HiveStorage.getAlIp.any((e) => ip.contains(e));
}
