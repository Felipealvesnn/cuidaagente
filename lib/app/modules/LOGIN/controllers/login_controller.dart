import 'package:cuidaagente/app/data/repository/usuario_repository.dart';
import 'package:cuidaagente/app/routes/app_pages.dart';
import 'package:cuidaagente/app/utils/getstorages.dart';
import 'package:cuidaagente/app/utils/tema.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:local_auth/local_auth.dart';

class LoginPageController extends GetxController {
  RxBool showPassword = true.obs;
  RxBool loading = false.obs;
  RxBool isSwitched = false.obs;

  UsuarioRepository repository = UsuarioRepository();

  void login(String email, String senha) async {
    try {
      loading.value = true;
      final user = await repository.login(email, senha);

      if (user != null && user.ativo!) {
        Storagers.boxUserLogado.write("user", user);
        Storagers.boxCpf.write('boxCpf', user.cpf.toString());
        Storagers.boxToken.write('boxToken', user.token.toString());
        // Extrai todos os orgaoId e salva como uma lista
        final orgaoIds =
            user.orgaoSetorUsuario?.map((orgao) => orgao.orgaoId).toList() ??
                [];
        Storagers.boxUserLogado.write('boxOrgaoIds', orgaoIds);
        print(user.token);

        Get.offAllNamed(Routes.HOME, arguments: [
          {"user": user}
        ]);
      } else if (user != null && !user.ativo!) {
        Get.snackbar(
          "Impossível autenticar",
          "Usuário Inativo",
          icon: Icon(Icons.error_outline, color: Colors.white),
          colorText: Colors.white,
          backgroundColor: Colors.red,
          duration: Duration(seconds: 4),
          snackPosition: SnackPosition.TOP,
        );
      }
    } catch (e) {
      print("Erro ao efetuar login: $e");
      // Trate o erro de acordo com suas necessidades, por exemplo, exibindo uma mensagem de erro.
    } finally {
      loading.value = false;
    }
  }

  Future<void> authenticateWithBiometrics() async {
    final LocalAuthentication localAuth = LocalAuthentication();

    try {
      bool canCheckBiometrics = await localAuth.canCheckBiometrics;

      if (canCheckBiometrics) {
        List<BiometricType> availableBiometrics =
            await localAuth.getAvailableBiometrics();

        if (availableBiometrics.isNotEmpty) {
          final bool isAuthenticated = await localAuth.authenticate(
            localizedReason: 'Por favor autentique para entrar no app',
            options: const AuthenticationOptions(biometricOnly: true),
          );

          if (isAuthenticated) {
            Storagers.boxInicial.write('biometria', true);
            await Get.offAllNamed(Routes.HOME, arguments: false);
          } else {
            return;
          }
        } else {
          // O dispositivo não suporta autenticação por impressão digital
        }
      } else {
        // O dispositivo não suporta autenticação biométrica
      }
    } on PlatformException catch (e) {
      // Lidar com exceções, se houver
      print("Erro na autenticação biométrica: $e");
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
  void onClose() {}
  void increment() => count.value++;
}
