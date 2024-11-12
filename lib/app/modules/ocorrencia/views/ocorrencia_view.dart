import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/ocorrencia_controller.dart';

class OcorrenciaView extends GetView<OcorrenciaController> {
  const OcorrenciaView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('OcorrenciaView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'OcorrenciaView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
