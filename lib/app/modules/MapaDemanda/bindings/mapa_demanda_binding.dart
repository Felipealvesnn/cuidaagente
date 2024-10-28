import 'package:get/get.dart';

import '../controllers/mapa_demanda_controller.dart';

class MapaDemandaBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MapaDemandaController>(
      () => MapaDemandaController(),
    );
  }
}
