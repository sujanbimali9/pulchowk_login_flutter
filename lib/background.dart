import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'dart:ui';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_background_service_android/flutter_background_service_android.dart';
import 'package:hive/hive.dart';
import 'package:http/io_client.dart';
import 'package:network_info_plus/network_info_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pulchowk_login/show_toast.dart';

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
      if (ip != null && ip.contains('10.100.5') || ip!.contains('10.0.2')) {
        final data = Storage.getData();
        log(ip);
        await login(data['username']!, data['password']!);
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

Future<String> login(String username, String password) async {
  // Specify the URL for the login endpoint
  final url = Uri.parse('https://10.100.1.1:8090/login.xml');
  log('login');
  // Specify the request body
  final body = {
    'mode': '191',
    'username': username,
    'password': password,
  };

  try {
    var httpClient = HttpClient()
      ..badCertificateCallback = (cert, host, port) => true;
    var ioClient = IOClient(httpClient);

    // Send POST request
    final response = await ioClient.post(
      url,
      body: body,
    ).timeout(const Duration(seconds: 4));
    final responsedata = parseLoginResponse(response.body);
    if (response.statusCode == 200) {
      log(responsedata);
    await  showToast(responsedata);
    } else {
      log('Login failed: ${parseLoginResponse(response.body)}');
   await   showToast(response.body);
    }
    return responsedata;
  } catch (e) {
    log('Error: $e');
  await  showToast('unknown error occured');
    return 'unknown error occured';
  }
}
Future<void> showToast(String message) async {
  log(message);
 await BackgroundService.showToast(message);
}

String parseLoginResponse(String response) {
  String xml = response.trim();
  int start = xml.indexOf("<message><![CDATA[") + "<message><![CDATA[".length;
  int end = xml.indexOf("]]></message>");
  if (start >= 0 && end >= 0) {
    return xml.substring(start, end);
  } else {
    return "Unknown error occurred";
  }
}

class Storage {
  static late HiveInterface hive;
  static late Box<String> box;
  static Future<void> initializeHive() async {
    hive = Hive;
    final path = await getApplicationDocumentsDirectory();
    hive.init(path.path);
    if (!hive.isBoxOpen('password')) {
      box = await hive.openBox('password');
    }
  }

  static Map<String, String> getData() {
    final String username = box.get('username', defaultValue: 'username')!;
    final String password = box.get('password', defaultValue: 'password')!;
    return {'username': username, 'password': password};
  }

  static void addData(Map<String, String> data) {
    box.put('username', data['username']!);
    box.put('password', data['password']!);
  }
}
