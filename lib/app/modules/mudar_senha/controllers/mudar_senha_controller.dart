import 'package:cuidaagente/app/data/models/Usuario.dart';
import 'package:cuidaagente/app/data/repository/usuario_repository.dart';
import 'package:cuidaagente/app/routes/app_pages.dart';
import 'package:cuidaagente/app/utils/getstorages.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MudarSenhaController extends GetxController {
  // Chaves do formulário e controladores dos campos
  UsuarioRepository usuarioRepository = UsuarioRepository();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final currentPasswordController = TextEditingController();
  final newPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  late Usuario usuario;

  // Estados de visibilidade para os campos de senha
  var obscureCurrentPassword = true.obs;
  var obscureNewPassword = true.obs;
  var obscureConfirmPassword = true.obs;

  // Método para atualizar a senha
  Future<void> atualizarSenha() async {
    final novaSenha = newPasswordController.text;

    var rsult = await usuarioRepository.ResetarSenha(
        usuario.email!, novaSenha, usuario.usuarioId!);
    if (rsult) {
      Get.snackbar("Sucesso", "Senha alterada com sucesso!",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white);
      await Get.offAllNamed(Routes.HOME);
    } else {
      Get.snackbar("Erro", "Senha atual incorreta.",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white);
    }
  }

  @override
  void onInit() {
    usuario = Storagers.boxUserLogado.read('user');
    // TODO: implement onInit
    super.onInit();
  }

  @override
  void onClose() {
    // Limpa os controladores ao fechar a tela
    currentPasswordController.dispose();
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }
}
