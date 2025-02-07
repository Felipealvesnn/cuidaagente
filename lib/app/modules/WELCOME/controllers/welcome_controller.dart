import 'package:background_locator_2/background_locator.dart';
import 'package:cuidaagente/app/routes/app_pages.dart';
import 'package:cuidaagente/app/utils/getstorages.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
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

  static Future<void> logout() async {
    try {
      Storagers.boxUserLogado.erase();
      Storagers.boxCpf.erase();
      Storagers.boxToken.erase();
      await Get.offAllNamed(Routes.LOGIN);

      // Cancelar inscrição de tópicos (se necessário)
      // await FirebaseMessaging.instance.unsubscribeFromTopic('todos_usuarios');

      // Apagar o token do dispositivo
      await FirebaseMessaging.instance.deleteToken();

      // Parar listeners de mensagens
      FirebaseMessaging.onMessage.listen((_) {}).cancel();

      // Limpar dados do Storage

      // Parar o rastreamento de localização (se usado)
      await BackgroundLocator.unRegisterLocationUpdate();

      // Redirecionar para a tela de login
    } catch (e) {
      print('Erro ao desativar notificações: $e');
    }
  }

  void increment() => count.value++;
}
