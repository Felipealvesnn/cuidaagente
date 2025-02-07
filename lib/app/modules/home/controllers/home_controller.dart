import 'package:cuidaagente/app/data/global/constants.dart';
import 'package:cuidaagente/app/data/models/Usuario.dart';
import 'package:cuidaagente/app/routes/app_pages.dart';
import 'package:cuidaagente/app/utils/getstorages.dart';
import 'package:cuidaagente/app/utils/ultil.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  //TODO: Implement HomeController

  Future verifyAuth() async {
    var biometria = await Storagers.boxInicial.read('biometria') ?? false;
    Usuario user = Usuario();
    final usuario = await Storagers.boxUserLogado.read('user');
    if (usuario != null) {
      user = usuario is Usuario ? usuario : Usuario.fromJson(usuario);
      await Storagers.boxUserLogado.write('user', user);
    }
    //
    if (user.cpf != null) {
      // ADICONA O AGENTE AO GRUPO DE MENSAGENS DO ORGAO DELE
      // List<int> parametros =
      //     (await Storagers.boxUserLogado.read('boxOrgaoIds') as List<dynamic>)
      //         .cast<int>();
      // for (int orgaoId in parametros) {
      //   FirebaseMessaging.instance
      //       .subscribeToTopic('orgao_$orgaoId$nomeCliente');
      // }

      if (biometria ?? false) {
        await Get.offAllNamed(Routes.WELCOME);
        //return await authenticateWithBiometrics();
      }

      await Get.offAllNamed(Routes.DEMANDAS);
    } else {
      await Get.offAllNamed(Routes.LOGIN);

      //return const WelcomeView();
    }
  }

  final count = 0.obs;

  void increment() => count.value++;
}
