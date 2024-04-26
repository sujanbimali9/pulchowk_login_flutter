import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pulchowk_login/bindings.dart';
import 'package:pulchowk_login/storage.dart';
import 'package:pulchowk_login/permission.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await handlePermisson();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      initialBinding: InitialBindings(),
      home: const HomePage(),
    );
  }
}

class HomePage extends GetView<Storage> {
  const HomePage({super.key});

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
                        controller: controller.userNameController,
                        autocorrect: false,
                        autofocus: false,
                        enableSuggestions: false,
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
                        controller: controller.passwordController,
                        expands: false,
                        autofocus: false,
                        enableSuggestions: false,
                        keyboardType: TextInputType.visiblePassword,
                        obscureText: true,
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
                              onPressed: controller.loginPressed,
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

class FilterScreen extends GetView<Storage> {
  const FilterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('pulchowk login'),
      ),
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Obx(() => SwitchListTile.adaptive(
                  contentPadding: const EdgeInsets.only(right: 15),
                  shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(15))),
                  value: controller.isFilterEnabled.value,
                  onChanged: (value) => controller.change(value),
                  activeColor: const Color.fromARGB(255, 104, 214, 107),
                  tileColor: controller.isFilterEnabled.value
                      ? const Color.fromARGB(255, 47, 148, 51)
                      : const Color.fromARGB(255, 183, 224, 185),
                )),
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
                        contentPadding:
                            EdgeInsets.symmetric(vertical: 13, horizontal: 10),
                        isDense: true,
                        border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(5)))),
                    controller: controller.ipFilterController,
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
                      controller.addIp();
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
          Expanded(
            child: LayoutBuilder(
              builder: (context, constraints) {
                return Column(
                  children: [
                    Obx(
                      () => Visibility(
                        visible: controller.ipList.isNotEmpty,
                        child: Container(
                            constraints: BoxConstraints(
                                maxHeight: constraints.maxHeight - 20),
                            margin: const EdgeInsets.only(
                                left: 20, right: 20, bottom: 20),
                            decoration: BoxDecoration(
                                border: Border.all(color: Colors.black),
                                borderRadius: const BorderRadius.all(
                                    Radius.circular(10))),
                            child: ListView.builder(
                              shrinkWrap: true,
                              itemCount: controller.ipList.length,
                              itemBuilder: (context, index) => ListTile(
                                title: Text(controller.ipList[index]),
                                trailing: IconButton(
                                  onPressed: () async {
                                    controller.deleteIP(index);
                                  },
                                  icon: const Icon(
                                    Icons.delete,
                                    color: Colors.red,
                                  ),
                                ),
                              ),
                            )),
                      ),
                    ),
                    const Spacer(),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
