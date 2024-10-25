import 'package:cuidaagente/app/routes/app_pages.dart';
import 'package:cuidaagente/app/utils/getstorages.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:local_auth_android/local_auth_android.dart';
import 'package:local_auth_darwin/local_auth_darwin.dart';
import 'package:local_auth/local_auth.dart';

class LoginController extends GetxController {
  //TODO: Implement LoginController

  final count = 0.obs;
  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
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
            authMessages: const <AuthMessages>[IOSAuthMessages(), AndroidAuthMessages(
            signInTitle: 'Autenticação biométrica',
            biometricHint: '',
            ), ],
            options: const AuthenticationOptions(biometricOnly: true),
          );

          if (isAuthenticated) {
            Storagers.boxInicial.write('biometria', true);
            await Get.offAllNamed(Routes.DEMANDAS, arguments: false);
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

  @override
  void onClose() {
    super.onClose();
  }

  void increment() => count.value++;
}
