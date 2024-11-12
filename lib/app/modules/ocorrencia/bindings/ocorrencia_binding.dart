import 'package:get/get.dart';

import '../controllers/ocorrencia_controller.dart';

class OcorrenciaBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<OcorrenciaController>(
      () => OcorrenciaController(),
    );
  }
}
