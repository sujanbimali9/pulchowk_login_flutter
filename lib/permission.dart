import 'dart:io';
import 'package:permission_handler/permission_handler.dart';

Future<void> handlePermisson() async {
  const notification = Permission.notification;
  await notification.request();

  final notiStatus = await notification.status;
  if (notiStatus.isGranted) {
    return;
  } else if (notiStatus.isLimited||notiStatus.isRestricted||notiStatus.isProvisional)
  {
    await notification.request();
  } else if (notiStatus.isPermanentlyDenied) {
    exit(0);
  } else {
  }
  // const location = Permission.location;
  // final locationStatus = await location.status;
  // if (locationStatus.isGranted) {
  //   return;
  // } else if (locationStatus.isDenied) {
  //   await location.request();
  // } else if (locationStatus.isPermanentlyDenied) {
  //   exit(0);
  // } else {
  //   await location.request();
  // }
}
