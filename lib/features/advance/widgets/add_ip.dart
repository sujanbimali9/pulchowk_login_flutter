import 'package:flutter/material.dart';
import 'package:pulchowk_login/features/controller/app_controller.dart';

class TAddIpSection extends StatelessWidget {
  const TAddIpSection({
    super.key,
    required this.controller,
  });

  final AppController controller;

  @override
  Widget build(BuildContext context) {
    return Padding(
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
                      borderRadius: BorderRadius.all(Radius.circular(5)))),
              controller: controller.ipFilterController,
            ),
          ),
          IconButton.outlined(
              style: IconButton.styleFrom(
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                  backgroundColor: const Color.fromARGB(255, 198, 215, 202)),
              onPressed: () async {
                controller.addIp();
              },
              icon: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 5.0),
                child: Text(
                  'AddIP',
                  style: TextStyle(color: Color.fromARGB(255, 52, 62, 52)),
                ),
              ))
        ],
      ),
    );
  }
}
