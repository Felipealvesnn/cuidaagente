import 'dart:convert';
import 'package:cuidaagente/app/data/global/constants.dart';
import 'package:cuidaagente/app/data/models/LogAgenteDemanda.dart';
import 'package:cuidaagente/app/utils/getstorages.dart';
import 'package:get/get_connect/connect.dart';

class DemandasProvider extends GetConnect {
  Future getDemandas({int pageNumber = 1, int pageSize = 10}) async {
    timeout = const Duration(minutes: 10);
    var token = Storagers.boxToken.read('boxToken') as String;
    timeout = const Duration(minutes: 10);
    final headers = {
      "Content-Type": "application/json",
      "Accept": "application/json",
      "Authorization": 'Bearer $token' // Ajuste o token conforme necessário
    };
    List<int> parametros =
        (await Storagers.boxUserLogado.read('boxOrgaoIds') as List<dynamic>)
            .cast<int>();

    var url =
        "${baseUrlw2e}demandas_ocorrencia/Getdemandas_ocorrencia?pageNumber=$pageNumber&pageSize=$pageSize";

    var response = await request(
      url,
      'GET',
      body: parametros,
      headers: headers,
    );

    if (response.isOk) {
      return response.body;
    } else {
      final responseBody = json.decode(response.bodyString ?? '{}');
      if (responseBody['Message'] == "Número de página inválido.") {
        return [];
      }
      throw Exception('Failed to fetch demandas!');
    }
  }

  Future<void> sendLogAgenteDemanda(LogAgenteDemanda log) async {
    timeout = const Duration(minutes: 10);
    var token = Storagers.boxToken.read('boxToken') as String;
    timeout = const Duration(minutes: 10);
    final headers = {
      "Content-Type": "application/json",
      "Accept": "application/json",
       "Authorization": 'Bearer $token'  // Ajuste o token conforme necessário
    };
    var url = "${baseUrlw2e}demandas_ocorrencia/logAgenteDemanda";
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

  // Método para finalizar uma demanda específica
  Future<void> finalizarDemanda(int demandaId, String despacho, int usuarioID) async {
    timeout = const Duration(minutes: 10);

    // Lê o token armazenado
    var token = Storagers.boxToken.read('boxToken') as String;

    // Cabeçalhos da requisição
    final headers = {
      "Content-Type": "application/json",
      "Accept": "application/json",
       "Authorization": 'Bearer $token' 
    };

    // Monta a URL com os parâmetros como query string
    var url =
        "${baseUrlw2e}demandas_ocorrencia/finalizarDemanda?idedemanda=$demandaId&despacho=$despacho&usuarioID=$usuarioID";

    // Executa a requisição GET para finalizar a demanda com parâmetros na URL

    var response = await request(
      url,
      'POST',
      headers: headers,
    );

    // Verifica a resposta para tratar erros
    if (response.isOk) {
      print("Demanda finalizada com sucesso!");
    } else {
      final responseBody = json.decode(response.bodyString ?? '{}');
      throw Exception(
          responseBody['Message'] ?? 'Falha ao finalizar a demanda!');
    }
  }
}
