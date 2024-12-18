import 'package:cuidaagente/app/utils/ultil.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/mudar_senha_controller.dart';

class MudarSenhaView extends GetView<MudarSenhaController> {
  const MudarSenhaView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Redefinir Senha'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: SingleChildScrollView(
            child: Form(
              key: controller.formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text(
                    "Alterar Senha",
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),

                  // Senha Atual
                  Obx(() => TextFormField(
                        controller: controller.currentPasswordController,
                        decoration: InputDecoration(
                          labelText: 'Senha Atual',
                          border: const OutlineInputBorder(),
                          prefixIcon: const Icon(Icons.lock_outline),
                          suffixIcon: IconButton(
                            icon: Icon(controller.obscureCurrentPassword.value
                                ? Icons.visibility_off
                                : Icons.visibility),
                            onPressed: () {
                              controller.obscureCurrentPassword.toggle();
                            },
                          ),
                        ),
                        obscureText: controller.obscureCurrentPassword.value,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Por favor, informe a senha atual.';
                          }
                          if (cripTografaMD5Hash(value) !=
                              controller.usuario.senhaUsuario) {
                            return 'Senha atual incorreta.';
                          }
                          return null;
                        },
                      )),
                  const SizedBox(height: 16),

                  // Nova Senha
                  Obx(() => TextFormField(
                        controller: controller.newPasswordController,
                        decoration: InputDecoration(
                          labelText: 'Nova Senha',
                          border: const OutlineInputBorder(),
                          prefixIcon: const Icon(Icons.lock_reset),
                          suffixIcon: IconButton(
                            icon: Icon(controller.obscureNewPassword.value
                                ? Icons.visibility_off
                                : Icons.visibility),
                            onPressed: () {
                              controller.obscureNewPassword.toggle();
                            },
                          ),
                        ),
                        obscureText: controller.obscureNewPassword.value,
                        validator: (value) {
                          if (value == null || value.length < 6) {
                            return 'A nova senha deve ter pelo menos 6 caracteres.';
                          }
                          return null;
                        },
                      )),
                  const SizedBox(height: 16),

                  // Confirme a Nova Senha
                  Obx(() => TextFormField(
                        controller: controller.confirmPasswordController,
                        decoration: InputDecoration(
                          labelText: 'Confirme a Nova Senha',
                          border: const OutlineInputBorder(),
                          prefixIcon: const Icon(Icons.lock),
                          suffixIcon: IconButton(
                            icon: Icon(controller.obscureConfirmPassword.value
                                ? Icons.visibility_off
                                : Icons.visibility),
                            onPressed: () {
                              controller.obscureConfirmPassword.toggle();
                            },
                          ),
                        ),
                        obscureText: controller.obscureConfirmPassword.value,
                        validator: (value) {
                          if (value != controller.newPasswordController.text) {
                            return 'As senhas não coincidem.';
                          }
                          return null;
                        },
                      )),
                  const SizedBox(height: 24),

                  // Botão Salvar
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      icon: const Icon(Icons.check),
                      label: const Text("Salvar Nova Senha"),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.all(16),
                        textStyle: const TextStyle(fontSize: 18),
                      ),
                      onPressed: () async {
                        if (controller.formKey.currentState!.validate()) {
                          await controller.atualizarSenha();
                        }
                      },
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
