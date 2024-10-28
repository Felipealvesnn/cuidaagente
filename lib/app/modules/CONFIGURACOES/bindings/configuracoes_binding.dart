import 'package:get/get.dart';

import '../controllers/configuracoes_controller.dart';

class ConfiguracoesBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ConfiguracoesController>(
      () => ConfiguracoesController(),
    );
  }
}
