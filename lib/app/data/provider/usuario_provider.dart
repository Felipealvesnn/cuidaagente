import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:cuidaagente/app/data/global/constants.dart';
import 'package:cuidaagente/app/data/models/PosicaoAgente.dart';
import 'package:cuidaagente/app/data/models/Usuario.dart';
import 'package:cuidaagente/app/utils/getstorages.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/connect.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get_storage/get_storage.dart';
import 'package:retry/retry.dart';

class UsuarioProvider extends GetConnect {
  Future<Map<String, dynamic>?> login(String email, String senha) async {
    timeout = const Duration(minutes: 10);
    // String? tokenFcm = await FirebaseMessaging.instance.getToken();
    var url = "${baseUrlw2e}UsuarioSistema/LoginUsuario/";
    late Response<dynamic> response;
    var model = json.encode({"login_usuario": email, "senha_usuario": senha});
    // , "tokenFirebase": tokenFcm});
    response = await retry(() async => await post(url, model), retryIf: (e) {
      return e is SocketException ||
          e is TimeoutException ||
          response.statusCode != 200;
    });

    if (response.statusCode == 200) {
      return response.body;
    } else if (response.statusCode == 404) {
      Get.snackbar("Erro ${response.statusCode}",
          "Usuario não encontrado, verifique login e senha",
          colorText: Colors.white,
          backgroundColor: errorColor,
          duration: const Duration(seconds: 10),
          snackPosition: SnackPosition.TOP);
      return response.body;
    } else {
      Get.snackbar("Erro", response.statusCode.toString(),
          colorText: Colors.white,
          backgroundColor: errorColor,
          duration: const Duration(seconds: 10),
          snackPosition: SnackPosition.TOP);
      return response.body;
    }
  }

  Future<void> sendLogAgenteDemanda(PosicaoAgente log) async {
    timeout = const Duration(minutes: 10);
    await GetStorage.init("boxToken");
    var token = Storagers.boxToken.read('boxToken') as String;

    final headers = {
      "Content-Type": "application/json",
      "Accept": "application/json",
      "Authorization": 'Bearer $token' // Ajuste o token conforme necessário
    };
    var url = "${baseUrlw2e}UsuarioSistema/SalvarPosicaoAgente";
    var body = log.toMap();

    var response = await post(
      url,
      body,
      headers: headers,
    );

    if (response.isOk) {
      print("Log enviado com sucesso!");
    } else {
      final responseBody = json.decode(response.bodyString ?? '{}');
      throw Exception(
          responseBody['Message'] ?? 'Falha ao enviar log de agente demanda!');
    }
  }
}
