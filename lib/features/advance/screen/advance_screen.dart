import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pulchowk_login/features/advance/widgets/add_ip.dart';
import 'package:pulchowk_login/features/advance/widgets/ip_list_builder.dart';
import 'package:pulchowk_login/features/advance/widgets/switch_tile.dart';
import 'package:pulchowk_login/features/controller/app_controller.dart';

class FilterScreen extends GetView<AppController> {
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
            child: Obx(() => TSwitchTile(controller: controller)),
          ),
          TAddIpSection(controller: controller),
          TIpListBuilder(controller: controller),
        ],
      ),
    );
  }
}
