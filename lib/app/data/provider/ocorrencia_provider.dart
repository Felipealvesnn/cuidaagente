import 'dart:convert';

import 'package:cuidaagente/app/data/global/constants.dart';
import 'package:cuidaagente/app/data/models/ocorrencia.dart';
import 'package:cuidaagente/app/data/models/ocorrenciaPost.dart';
import 'package:cuidaagente/app/utils/getstorages.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:path_provider/path_provider.dart';

class OcorrenciaProvider extends GetConnect {
  Future<Map<String, dynamic>?> postOcorrencia(OcorrenciaPost ocorrencia) async {
    var token = Storagers.boxToken.read('boxToken') as String;

    var url = "$baseUrlw2e/ocorrenciaAgente/Postocorrencia";
    final headers = {"Authorization": 'Bearer $token'};
    ocorrencia.origem_ocorrencia_id = 7;
    var body = ocorrencia.toMap();
    var logger = Logger();
    logger.d(json.encode(body));
    print(json.encode(body));


    
    var response = await post(
      url,
      body,
      //json.encode(body),
      contentType: 'application/json',
      headers: headers,
    ).timeout(
      const Duration(seconds: 20),
    );

    if (response.statusText == "OK") {
      return response.body;
    } else if (response.statusCode == null) {
      // Trate a falha de conexão aqui
    }

    return response.body;
  }

  Future<List<dynamic>?> GetNatureza() async {
    var token = Storagers.boxToken.read('boxToken') as String;
  
    var url = "$baseUrlw2e/ocorrenciaAgente/NaturezaOcorrencia";
   

    final headers = {"Authorization": 'Bearer $token'};

    var response = await get(
      url,
      contentType: 'application/json',
      headers: headers,
    ).timeout(
      const Duration(seconds: 20),
    );

    if (response.statusText == "OK") {
      return response.body;
    } else if (response.statusCode == null) {
      // Trate a falha de conexão aqui
    }

    return response.body;
  }
   

   Future<List<dynamic>?> GetTipoOcorrencia(int Idnatureza) async {
    var token = Storagers.boxToken.read('boxToken') as String;

    var url = "$baseUrlw2e/ocorrenciaAgente/TipoOcorrencia?idNatureza=$Idnatureza";
    final headers = {"Authorization": 'Bearer $token'};

    var response = await post(
      url,
      json.encode({"idNatureza": Idnatureza}),
      contentType: 'application/json',
      headers: headers,
    ).timeout(
      const Duration(seconds: 20),
    );

    if (response.statusText == "OK") {
      return response.body;
    } else if (response.statusCode == null) {
      // Trate a falha de conexão aqui
    }

    return response.body;
  }

  
 
}
