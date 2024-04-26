import 'dart:io';
import 'package:http/io_client.dart';
import 'package:logger/web.dart';
import 'package:pulchowk_login/utils/helper/show_toast.dart';

Future<String> login(String username, String password) async {
  final logger = Logger();
  final url = Uri.parse('https://10.100.1.1:8090/login.xml');

  logger.d('login');

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
    final response = await ioClient
        .post(
          url,
          body: body,
        )
        .timeout(const Duration(seconds: 4));
    final responsedata = parseLoginResponse(response.body);
    if (response.statusCode == 200) {
      logger.d(responsedata);
      await showToast(responsedata);
    } else {
      logger.e('Login failed: ${parseLoginResponse(response.body)}');
      await showToast(response.body);
    }
    return responsedata;
  } catch (e) {
    logger.e('Error: $e');
    await showToast('unknown error occured');
    return 'unknown error occured';
  }
}

Future<void> showToast(String message) async {
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
