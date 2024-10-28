import 'package:cuidaagente/app/data/models/Usuario.dart';
import 'package:cuidaagente/app/routes/app_pages.dart';
import 'package:cuidaagente/app/utils/getstorages.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  //TODO: Implement HomeController

  
   Future verifyAuth() async {
    var biometria = await Storagers.boxInicial.read('biometria')?? false;
    Usuario user = Usuario();
    final usuario = await Storagers.boxUserLogado.read('user');
    if (usuario != null) {
      user = usuario is Usuario ? usuario : Usuario.fromJson(usuario);
      await Storagers.boxUserLogado.write('user', user);
    }

    if (user.cpf != null) {
      if (biometria ?? false) {
        await Get.offAllNamed(Routes.WELCOME);
        //return await authenticateWithBiometrics();
      }

      return Get.offAllNamed(Routes.DEMANDAS);
    } else {
      await Get.offAllNamed(Routes.LOGIN);

      //return const WelcomeView();
    }
  }

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

  void increment() => count.value++;
}
