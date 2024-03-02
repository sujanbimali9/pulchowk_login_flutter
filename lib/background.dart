import 'dart:async';
import 'dart:developer';
import 'dart:ui';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_background_service_android/flutter_background_service_android.dart';
import 'package:network_info_plus/network_info_plus.dart';
import 'package:pulchowk_login/hive.dart';
import 'login.dart';

Future<void> initializeBackgroundService() async {
  final service = FlutterBackgroundService();
  IosConfiguration iosConfiguration = IosConfiguration(
      onForeground: onStart, onBackground: onIosBackground, autoStart: true);
  AndroidConfiguration androidConfiguration = AndroidConfiguration(
    onStart: onStart,
    isForegroundMode: true,
    autoStart: true,
    autoStartOnBoot: true,
  );
  service.configure(
      iosConfiguration: iosConfiguration,
      androidConfiguration: androidConfiguration);
}

@pragma('vm:entry-point')
Future<void> onStart(ServiceInstance service) async {
  DartPluginRegistrant.ensureInitialized();
  await Storage.initializeHive();
  if (service is AndroidServiceInstance) {
    service.on('setAsForeground').listen((event) async {
      await service.setAsForegroundService();
      if (await service.isForegroundService()) {
        service.setForegroundNotificationInfo(
            title: 'Wifi State Service',
            content: 'Listening for wifi state change');
      }
    });
    service.on('setAsBackground').listen((event) async {
      await service.setAsBackgroundService();
    });
    service.on('stopService').listen((event) {
      service.stopSelf();
    });
  }
  Connectivity()
      .onConnectivityChanged
      .listen((ConnectivityResult result) async {
    if (result == ConnectivityResult.wifi) {
      final network = NetworkInfo();
      final ip = await network.getWifiIP();
      if (ip != null) {
        final data = Storage.getPData();
        log(ip);
        if (Storage.isFilterEnabled()) {
          log('filter is enabled');
          if (checkIp(ip)) {
            log('ip available');
            await login(data['username']!, data['password']!);
          }
        } else {
          log('filter is disabled');
          await login(data['username']!, data['password']!);
        }
      }
    }
    if (service is AndroidServiceInstance) {
      if (await service.isForegroundService()) {
        service.setForegroundNotificationInfo(
            title: 'Wifi State Service', content: '$result');
      }
      service.invoke('update');
    }
  });
}

@pragma('vm:entry-point')
Future<bool> onIosBackground(ServiceInstance service) async {
  WidgetsFlutterBinding.ensureInitialized();
  DartPluginRegistrant.ensureInitialized();
  return true;
}

bool checkIp(ip) {
  return Storage.getIp().any((e) => e.contains(ip));
}
