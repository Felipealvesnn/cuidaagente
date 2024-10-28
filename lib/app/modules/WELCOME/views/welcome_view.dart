import 'package:cuidaagente/app/modules/LOGIN/controllers/login_controller.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/welcome_controller.dart';

class WelcomeView extends GetView<WelcomeController> {
  LoginPageController initial_page_controller = LoginPageController();
   WelcomeView({super.key});
  @override
  Widget build(BuildContext context) {
    initial_page_controller.authenticateWithBiometrics();

    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
         // color: Colors.green,
          image: DecorationImage(
            colorFilter: ColorFilter.mode(
                Colors.black.withOpacity(0.5), BlendMode.dstATop),
            image: const AssetImage(""),
            fit: BoxFit.fill,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                  "BEM-VINDO",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Color.fromARGB(255, 0, 0, 0),
                    fontSize: 34,
                    fontFamily: "Work Sans",
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 20.0),
                const Text(
                  "...",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16.0,
                    color: Color.fromARGB(255, 5, 5, 5),
                  ),
                ),
                const SizedBox(height: 20.0),
                SizedBox(
                  width: Get.width * 0.8,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                          ),
                          onPressed: () async {
                            // Navegar para a próxima tela, por exemplo, a tela de login
                            await initial_page_controller
                                .authenticateWithBiometrics();
                          },
                          child: const Text(
                            "Acessar",
                            style: TextStyle(
                              fontSize: 18.0,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20.0),
                SizedBox(
                  width: Get.width * 0.8,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: TextButton(
                          style: TextButton.styleFrom(
                            backgroundColor: Colors.transparent,
                          ),
                          onPressed: () async {
                            // Navegar para a próxima tela, por exemplo, a tela de login
                            WelcomeController.logout();
                          },
                          child: const Text(
                            "Sair da conta",
                            style: TextStyle(
                                fontSize: 18.0,
                                color: Color.fromARGB(255, 5, 5, 5)),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
