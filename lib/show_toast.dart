import 'dart:developer';
import 'package:fluttertoast/fluttertoast.dart';

class BackgroundService {
  static Future<void> showToast(String message) async {
    try {
      log('${await Fluttertoast.showToast(
        msg: message,
      )}');
    } catch (e) {
      log("Failed to show toast: $e.");
    }
  }
}
