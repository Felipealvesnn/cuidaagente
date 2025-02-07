import 'package:cuidaagente/app/modules/LOGIN/controllers/login_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/welcome_controller.dart';

class WelcomeView extends GetView<WelcomeController> {
  final LoginPageController initialPageController = LoginPageController();

  WelcomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Se preferir, mova a autenticação para o método initState de um StatefulWidget
    initialPageController.authenticateWithBiometrics();

    return Scaffold(
      body: SafeArea(
        child: Container(
          width: double.infinity,
          // Utilizando um gradiente como fundo. Se preferir imagem, descomente a parte de DecorationImage
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Get.theme.primaryColor,
                Get.theme.primaryColor.withOpacity(0.2)
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            // image: DecorationImage(
            //   image: AssetImage("assets/images/background.jpg"),
            //   fit: BoxFit.cover,
            //   colorFilter: ColorFilter.mode(
            //     Colors.black.withOpacity(0.3),
            //     BlendMode.darken,
            //   ),
            // ),
          ),
          child: Center(
            child: SingleChildScrollView(
              padding:
                  const EdgeInsets.symmetric(horizontal: 32.0, vertical: 16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Caso tenha um logo, insira-o aqui
                  Image.asset(
                    'assets/logo003.png', // Atualize o caminho para o seu asset
                    height: 150,
                  ),
                  const SizedBox(height: 24.0),
                  const Text(
                    "BEM-VINDO",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 36,
                      fontFamily: "Work Sans",
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.2,
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  const Text(
                    "Conecte-se com segurança e facilidade.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 18.0,
                      color: Colors.white70,
                    ),
                  ),
                  const SizedBox(height: 32.0),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16.0),
                        backgroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        elevation: 5,
                      ),
                      onPressed: () async {
                        await initialPageController
                            .authenticateWithBiometrics();
                      },
                      child: Text(
                        "Acessar",
                        style: TextStyle(
                          fontSize: 18.0,
                          color: Get.theme.primaryColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  SizedBox(
                    width: double.infinity,
                    child: TextButton(
                      onPressed: () async {
                        WelcomeController.logout();
                      },
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: const Text(
                        "Sair da conta",
                        style: TextStyle(
                          fontSize: 18.0,
                          color: Colors.white,
                          fontFamily: "Work Sans",
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.2,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
