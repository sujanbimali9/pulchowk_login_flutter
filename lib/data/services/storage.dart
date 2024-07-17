import 'package:hive/hive.dart';

class HiveStorage {
  static set defaultHiveStorage(String path) => Hive.defaultDirectory = path;
  static Box<String> get getIpFilterBox => Hive.box(
      name: 'ipFilter',
      directory: Hive.defaultDirectory ??
          '/data/user/0/com.example.pulchowk_login/app_flutter');

  static Box<dynamic> get getDataBox => Hive.box(
      name: 'data',
      directory: Hive.defaultDirectory ??
          '/data/user/0/com.example.pulchowk_login/app_flutter');

  static List<String> get getAlIp => getIpFilterBox.isNotEmpty
      ? getIpFilterBox.getRange(0, getIpFilterBox.length)
      : <String>[];

  static dynamic fromDataBox(String key, {dynamic defaultValue}) =>
      getDataBox.get(key, defaultValue: defaultValue);
  static set deleteIp(int index) => getIpFilterBox.deleteAt(index);
  static set addIp(String ip) => getIpFilterBox.add(ip);
  // static set addIp(String ip) =>
  // !(getAllIp.contains(ip)) ? getIpFilterBox.add(ip) : null;
  static addData(String key, dynamic value) => getDataBox.put(key, value);
  static addAllData(Map<String, dynamic> map) => getDataBox.putAll(map);
}
