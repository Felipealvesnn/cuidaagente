import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/ocorrencia_controller.dart';

class FloatibuttonOcorrencia extends StatelessWidget {
  const FloatibuttonOcorrencia({
    super.key,
    required this.controller,
    required this.formKey,
  });

  final OcorrenciaController controller;
  final GlobalKey<FormState> formKey; // Recebe o formKey

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        // Verifica se o formulário é válido antes de exibir o diálogo
        if (formKey.currentState?.validate() ?? false) {
          // Exibe o diálogo de confirmação antes de salvar
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text("Confirmação"),
                content: const Text("Você deseja salvar a ocorrência?"),
                actions: <Widget>[
                  TextButton(
                    child: const Text("Cancelar"),
                    onPressed: () {
                      Navigator.of(context).pop(); // Fecha o diálogo
                    },
                  ),
                  ElevatedButton(
                    child: const Text("Confirmar"),
                    onPressed: () {
                      Navigator.of(context).pop(); // Fecha o diálogo
                      controller.enviarOcorrencia(); // Chama a função para enviar
                    },
                  ),
                ],
              );
            },
          );
        } else {
          // Exibe uma mensagem caso o formulário não seja válido
          Get.snackbar(
            "Formulário incompleto",
            "Por favor, preencha todos os campos obrigatórios.",
            backgroundColor: Colors.red,
            colorText: Colors.white,
          );
        }
      },
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(28.0),
      ),
      child: const Icon(
        Icons.save,
        color: Colors.white,
      ),
    );
  }
}
