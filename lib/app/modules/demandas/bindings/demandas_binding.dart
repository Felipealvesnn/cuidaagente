import 'package:get/get.dart';

import '../controllers/demandas_controller.dart';

class DemandasBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DemandasController>(
      () => DemandasController(),
    );
  }
}
