import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/configuracoes_controller.dart';

class ConfiguracoesView extends GetView<ConfiguracoesController> {
  const ConfiguracoesView({super.key});

  @override
  Widget build(BuildContext context) {
    bool showAppBar = Get.arguments ?? false;
     controller.isBiometriaEnabled.value = showAppBar;

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Configurações '),
          centerTitle: true,
        ),
        body: Obx(
          () => ListView(
            children: [
              buildListTile(
                title: "Exibir Biometria?",
                value: controller.isBiometriaEnabled.value,
                onChanged: (value) {
                  controller.isBiometriaEnabled.value = value;
                  controller.mudarBiometria();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildListTile({
    required String title,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return ListTile(
      title: Text(title),
      trailing: Switch(
        value: value,
        onChanged: onChanged,
      ),
    );
  }
}
