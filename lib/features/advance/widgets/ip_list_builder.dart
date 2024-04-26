import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:pulchowk_login/features/controller/app_controller.dart';

class TIpListBuilder extends StatelessWidget {
  const TIpListBuilder({
    super.key,
    required this.controller,
  });

  final AppController controller;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: LayoutBuilder(
        builder: (context, constraints) {
          return Column(
            children: [
              Obx(
                () => Visibility(
                  visible: controller.ipList.isNotEmpty,
                  child: Container(
                      constraints:
                          BoxConstraints(maxHeight: constraints.maxHeight - 20),
                      margin: const EdgeInsets.only(
                          left: 20, right: 20, bottom: 20),
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.black),
                          borderRadius:
                              const BorderRadius.all(Radius.circular(10))),
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
    );
  }
}
