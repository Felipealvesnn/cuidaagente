import 'package:cuidaagente/app/routes/app_pages.dart';
import 'package:cuidaagente/app/utils/getstorages.dart';
import 'package:get/get.dart';

class WelcomeController extends GetxController {
  //TODO: Implement WelcomeController

  final count = 0.obs;
  @override
  void onInit() {
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

  static void logout() async {
    Storagers.boxUserLogado.erase();
    Storagers.boxCpf.erase();
    Storagers.boxToken.erase();

    await Get.offAllNamed(Routes.LOGIN);
  }

  void increment() => count.value++;
}
