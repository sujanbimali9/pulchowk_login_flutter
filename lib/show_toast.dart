import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class BackgroundService {
  static Future<void> showToast(String message) async {
    try {
      log('${await Fluttertoast.showToast(
        msg: message,
        backgroundColor: Colors.transparent,
      )}');
    } catch (e) {
      log("Failed to show toast: $e.");
    }
  }
}
