import 'package:cuidaagente/app/modules/LOGIN/controllers/login_controller.dart';
import 'package:cuidaagente/app/modules/LOGIN/views/header_widget.dart';
import 'package:cuidaagente/app/routes/app_pages.dart';
import 'package:cuidaagente/app/utils/theme_helper.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:validatorless/validatorless.dart';

class LoginPageView extends GetView<LoginPageController> {
  final double _headerHeight = Get.size.height / 3;
  final formKey = GlobalKey<FormState>();

  TextEditingController myEmailController = TextEditingController();
  TextEditingController myPasswordController = TextEditingController();

  // Controlador para o switch de biometria

  LoginPageView({super.key});
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: _headerHeight,
                child: HeaderWidget(_headerHeight, true,
                    Icons.login_rounded), //let's create a common header widget
              ),
              Container(
                padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                margin: const EdgeInsets.fromLTRB(
                    20, 2, 20, 10), // This will be the login form
                child: Column(
                  children: [
                    const Text(
                      'Ocorrências',
                      style:
                          TextStyle(fontSize: 50, fontWeight: FontWeight.bold),
                    ),
                    const Text(
                      'Faça login na sua conta',
                      style: TextStyle(color: Colors.grey),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 15.0),
                      child: Form(
                        key: formKey,
                        child: Column(
                          children: [
                            Container(
                              decoration:
                                  ThemeHelper().inputBoxDecorationShaddow(),
                              child: TextFormField(
                                decoration: ThemeHelper().textInputDecoration(
                                    'Email / CPF',
                                    'Entre com Email OU CPF registrado'),
                                validator: Validatorless.multiple([
                                  Validatorless.required("campo obrigatório !"),
                                  // Validatorless.email("E-mail Inválido"),
                                ]),
                                keyboardType: TextInputType.text,
                                autofocus: false,
                                controller: myEmailController,
                              ),
                            ),
                            const SizedBox(height: 15.0),
                            Container(
                              decoration:
                                  ThemeHelper().inputBoxDecorationShaddow(),
                              child: Obx(
                                () => TextFormField(
                                  validator: Validatorless.multiple([
                                    Validatorless.required("Senha Obrigatória"),
                                    Validatorless.min(3,
                                        "Senha precisa ter pelo menos 3 caracteres")
                                  ]),
                                  controller: myPasswordController,
                                  autofocus: false,
                                  obscureText: controller.showPassword.value,
                                  decoration: InputDecoration(
                                    suffixIcon: IconButton(
                                      icon: Icon(
                                        controller.showPassword.value
                                            ? Icons.visibility
                                            : Icons.visibility_off,
                                        color: Get.theme.primaryColor,
                                      ),
                                      onPressed: () {
                                        controller.showPassword.value =
                                            !controller.showPassword.value;
                                      },
                                    ),
                                    labelText: "Senha",
                                    hintText: "Entre com sua senha",
                                    fillColor: Colors.white,
                                    filled: true,
                                    contentPadding: const EdgeInsets.fromLTRB(
                                        20, 10, 20, 10),
                                    focusedBorder: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(100.0),
                                        borderSide: const BorderSide(
                                            color: Colors.grey)),
                                    enabledBorder: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(100.0),
                                        borderSide: BorderSide(
                                            color: Colors.grey.shade400)),
                                    errorBorder: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(100.0),
                                        borderSide: const BorderSide(
                                            color: Colors.red, width: 2.0)),
                                    focusedErrorBorder: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(100.0),
                                        borderSide: const BorderSide(
                                            color: Colors.red, width: 2.0)),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 15),
                            Container(
                              margin: const EdgeInsets.fromLTRB(10, 0, 10, 15),
                              alignment: Alignment.topRight,
                              child: GestureDetector(
                                onTap: () {},
                                child: const Text(
                                  "Esqueceu a senha?",
                                  style: TextStyle(
                                    color: Colors.grey,
                                  ),
                                ),
                              ),
                            ),
                            Obx(
                              () => Visibility(
                                visible: !controller.loading.value,
                                replacement: Container(
                                  decoration: ThemeHelper()
                                      .buttonBoxDecoration(context),
                                  child: ElevatedButton(
                                    //style: ThemeHelper().buttonStyle(),
                                    child: const Padding(
                                        padding:
                                            EdgeInsets.fromLTRB(40, 10, 40, 10),
                                        child: CircularProgressIndicator(
                                          color: Colors.white,
                                        )),
                                    onPressed: () {},
                                  ),
                                ),
                                child: Container(
                                  decoration: ThemeHelper()
                                      .buttonBoxDecoration(context),
                                  child: ElevatedButton(
                                    child: Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          40, 10, 40, 10),
                                      child: Text(
                                        'Login'.toUpperCase(),
                                        style: const TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white),
                                      ),
                                    ),
                                    onPressed: () {
                                      if (formKey.currentState!.validate()) {
                                        controller.login(myEmailController.text,
                                            myPasswordController.text);
                                      }
                                    },
                                  ),
                                ),
                              ),
                            ),

                            // Switch para usar biometria
                            Obx(
                              () => SwitchListTile(
                                title: const Text("Usar biometria"),
                                value: controller.isSwitched.value,
                                onChanged: (bool value) {
                                  controller.isSwitched.value = value;
                                  controller.mudarBiometria();
                                  // Adicione sua lógica para ativar/desativar biometria
                                },
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.fromLTRB(10, 20, 10, 20),
                              child: Text.rich(TextSpan(children: [
                                const TextSpan(text: "Não tem uma conta? "),
                                TextSpan(
                                  text: 'Criar',
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () {
                                      // Get.toNamed(Routes.CADASTRO_USUARIO);
                                    },
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .secondary),
                                ),
                              ])),
                            ),

                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 20),
                              child: Image.asset(
                                'assets/logo001.png',
                                cacheWidth: 130,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
        // bottomSheet:  Row(
        //   mainAxisAlignment: MainAxisAlignment.center,
        //   children: [
        //    // Text('Powered by'),
        //     Image.asset('assets/icon/logo_municipio.png'),
        //   ],
        // ),
      ),
    );
  }
}
