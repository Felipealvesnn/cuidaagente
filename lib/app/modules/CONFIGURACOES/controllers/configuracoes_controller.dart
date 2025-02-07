import 'package:cuidaagente/app/utils/getstorages.dart';
import 'package:get/get.dart';

class ConfiguracoesController extends GetxController {
  //TODO: Implement ConfiguracoesController
  RxBool isBiometriaEnabled = false.obs;

  final count = 0.obs;
  @override
  void onInit() async {
    isBiometriaEnabled.value =
        await Storagers.boxInicial.read('biometria') ?? false;
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  mudarBiometria() async {
    await Storagers.boxInicial.write('biometria', isBiometriaEnabled.value);
  }

  void increment() => count.value++;
}
