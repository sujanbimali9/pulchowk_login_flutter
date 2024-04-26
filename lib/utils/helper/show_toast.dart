import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:logger/logger.dart';

class BackgroundService {
  static Future<void> showToast(String message) async {
    final logger = Logger();
    try {
      logger.d('${await Fluttertoast.showToast(
        msg: message,
        backgroundColor: Colors.grey.withOpacity(0.5),
        textColor: Colors.black,
        toastLength: Toast.LENGTH_SHORT,
      )}');
    } catch (e) {
      logger.e("Failed to show toast: $e.");
    }
  }
}
