import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pulchowk_login/background.dart';
import 'package:pulchowk_login/hive.dart';
import 'package:pulchowk_login/permission.dart';
import 'login.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await handlePermisson();
  const notification = Permission.notification;
  await notification.request();
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
    final data = Storage.getPData();
    username = data['username']!;
    password = data['password']!;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pulchowk Login'),
        actions: [
          TextButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const FilterScreen(),
                ));
              },
              child: const Text('Advance'))
        ],
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
                        autocorrect: false,
                        autofocus: false,
                        enableSuggestions: false,
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
                        autofocus: false,
                        enableSuggestions: false,
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
                                    await Storage.addPData({
                                      'username': username,
                                      'password': password
                                    });
                                    setState(() {});
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

class FilterScreen extends StatefulWidget {
  const FilterScreen({super.key});

  @override
  State<FilterScreen> createState() => _FilterScreenState();
}

class _FilterScreenState extends State<FilterScreen> {
  late TextEditingController _textEditingController;

  @override
  void initState() {
    _textEditingController = TextEditingController();
    super.initState();
  }

  bool value = Storage.isFilterEnabled();

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('pulchowk login'),
      ),
      body: Align(
        alignment: Alignment.center,
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 5),
              padding: const EdgeInsets.symmetric(horizontal: 3, vertical: 5),
              decoration: BoxDecoration(
                  color: value
                      ? const Color.fromARGB(255, 47, 148, 51)
                      : const Color.fromARGB(255, 183, 224, 185),
                  borderRadius: const BorderRadius.all(Radius.circular(10))),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Expanded(
                    child: Center(
                      child: Text(
                        'IP filter',
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 20,
                            fontWeight: FontWeight.w500),
                      ),
                    ),
                  ),
                  Switch.adaptive(
                      activeColor: const Color.fromARGB(255, 104, 214, 107),
                      value: value,
                      onChanged: (v) async {
                        await Future.delayed(const Duration(milliseconds: 100),
                            () async {
                          await Storage.change(v);
                          setState(() {
                            value = v;
                          });
                        });
                      })
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.7,
                    child: TextField(
                      expands: false,
                      enableSuggestions: false,
                      autofocus: false,
                      decoration: const InputDecoration(
                          contentPadding: EdgeInsets.symmetric(
                              vertical: 13, horizontal: 10),
                          isDense: true,
                          border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5)))),
                      controller: _textEditingController,
                    ),
                  ),
                  IconButton.outlined(
                      style: IconButton.styleFrom(
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                          ),
                          backgroundColor:
                              const Color.fromARGB(255, 198, 215, 202)),
                      onPressed: () async {
                        if (_textEditingController.text.isNotEmpty) {
                          await Storage.addIp(_textEditingController.text);
                          _textEditingController.clear();
                          setState(() {});
                        }
                      },
                      icon: const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 5.0),
                        child: Text(
                          'AddIP',
                          style:
                              TextStyle(color: Color.fromARGB(255, 52, 62, 52)),
                        ),
                      ))
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.black),
                  borderRadius: const BorderRadius.all(Radius.circular(10))),
              child: ListView(
                shrinkWrap: true,
                children: Storage.getIp()
                    .map(
                      (ip) => ListTile(
                        title: Text(ip),
                        trailing: IconButton(
                          onPressed: () async {
                            await Storage.deleteIP(ip);
                            setState(() {});
                          },
                          icon: const Icon(
                            Icons.delete,
                            color: Colors.red,
                          ),
                        ),
                      ),
                    )
                    .toList(),
              ),
            )
          ],
        ),
      ),
    );
  }
}
