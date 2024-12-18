import 'package:get/get.dart';

import '../controllers/mudar_senha_controller.dart';

class MudarSenhaBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MudarSenhaController>(
      () => MudarSenhaController(),
    );
  }
}
