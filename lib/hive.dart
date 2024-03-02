import 'dart:developer';

import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';

class Storage {
  static late HiveInterface hive;
  static late Box pBox;
  static late Box<String> ipBox;
  static Future<void> initializeHive() async {
    hive = Hive;
    final path = await getApplicationDocumentsDirectory();
    hive.init(path.path);

    if (!hive.isBoxOpen('ipBox')) {
      ipBox = await hive.openBox('ipBox');
    }

    if (!hive.isBoxOpen('password')) {
      pBox = await hive.openBox('password');
    }
  }

  static Map<String, String> getPData() {
    final String username = pBox.get('username', defaultValue: 'username')!;
    final String password = pBox.get('password', defaultValue: 'password')!;
    return {'username': username, 'password': password};
  }

  static Future<void> addPData(Map<String, String> data) async {
    await pBox.put('username', data['username']!);
    await pBox.put('password', data['password']!);
    await pBox.close();
    pBox = await hive.openBox('password');
  }

  static List<String> getIp() {
    log('getIP ${ipBox.values.toList()}');
    return ipBox.values.toList();
  }

  static Future<void> deleteIP(String ip) async {
    final int index =
        ipBox.values.toList().indexWhere((element) => element == ip);
    await ipBox.deleteAt(index);
  }

  static bool isFilterEnabled() {
    log('filter ${pBox.get('filterIp', defaultValue: false)}');
    return pBox.get('filterIp', defaultValue: false);
  }

  static Future<void> addIp(String ip) async {
    await ipBox.add(ip);
    if (isFilterEnabled()) {
      ipBox.close();
      if (!ipBox.isOpen) ipBox = await hive.openBox('filteIp');
    }
  }

  static Future<void> change(bool filter) async {
    await pBox.put('filterIp', filter);
    await pBox.close();
    if (!pBox.isOpen) pBox = await hive.openBox('password');
  }
}
