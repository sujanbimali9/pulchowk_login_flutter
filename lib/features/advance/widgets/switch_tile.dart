import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pulchowk_login/features/controller/app_controller.dart';

class TSwitchTile extends GetView<AppController> {
  const TSwitchTile({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => SwitchListTile.adaptive(
        contentPadding: const EdgeInsets.only(right: 15),
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(15))),
        value: controller.isFilterEnabled.value,
        onChanged: (value) => controller.change(value),
        activeColor: const Color.fromARGB(255, 104, 214, 107),
        tileColor: controller.isFilterEnabled.value
            ? const Color.fromARGB(255, 47, 148, 51)
            : const Color.fromARGB(255, 183, 224, 185),
        title: const Align(
          alignment: Alignment.center,
          child: Text(
            'IP filter',
            style: TextStyle(
                color: Colors.black, fontSize: 20, fontWeight: FontWeight.w500),
          ),
        ),
      ),
    );
  }
}
