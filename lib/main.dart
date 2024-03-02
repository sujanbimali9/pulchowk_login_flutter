import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:pulchowk_login/background.dart';
import 'package:pulchowk_login/permission.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await handlePermisson();
  await Storage.initializeHive();
  await initializeBackgroundService();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

String username = '';
String password = '';

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    final data = Storage.getData();
    username = data['username']!;
    password = data['password']!;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pulchowk Login'),
      ),
      body: Align(
        alignment: Alignment.center,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 5),
          child: FutureBuilder(
              future: null,
              builder: (context, snapshot) {
                return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Username',
                        style: TextStyle(fontSize: 20),
                      ),
                      TextFormField(
                        initialValue: username,
                        onChanged: (value) => username = value,
                        expands: false,
                        decoration: const InputDecoration(
                            isDense: true,
                            border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)),
                                borderSide: BorderSide(color: Colors.black))),
                      ),
                      const Text(
                        'Password',
                        style: TextStyle(fontSize: 20),
                      ),
                      TextFormField(
                        expands: false,
                        keyboardType: TextInputType.visiblePassword,
                        obscureText: true,
                        initialValue: password,
                        onChanged: (value) => password = value,
                        decoration: const InputDecoration(
                            isDense: true,
                            border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)),
                                borderSide: BorderSide(color: Colors.black))),
                      ),
                      Align(
                        alignment: Alignment.center,
                        child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  maximumSize: const Size(200, 60),
                                  minimumSize: const Size(170, 50)),
                              onPressed: () async {
                                if (username.isNotEmpty &&
                                    password.isNotEmpty) {
                                  final response =
                                      await login(username, password);
                                  if (response.contains(
                                      'You are signed in as {username}')) {
                                    Storage.addData({
                                      'username': username,
                                      'password': password
                                    });
                                  }
                                }
                                final service = FlutterBackgroundService();
                                if (!(await service.isRunning())) {
                                  log('service not running');
                                  await service.startService();
                                }
                              },
                              child: const Text('connect')),
                        ),
                      )
                    ]);
              }),
        ),
      ),
    );
  }
}
