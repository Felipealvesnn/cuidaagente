import 'dart:convert';
import 'package:cuidaagente/app/data/global/constants.dart';
import 'package:cuidaagente/app/data/models/LogAgenteDemanda.dart';
import 'package:cuidaagente/app/data/models/adicionarPontos.dart';
import 'package:cuidaagente/app/data/models/ocorrenciaPost.dart';
import 'package:cuidaagente/app/utils/getstorages.dart';
import 'package:get/get_connect/connect.dart';

class DemandasProvider extends GetConnect {
  Future getDemandasFiltradas(Map<String, Object?> model) async {
    timeout = const Duration(minutes: 10);
    var token = Storagers.boxToken.read('boxToken') as String;
    timeout = const Duration(minutes: 10);
    final headers = {
      "Content-Type": "application/json",
      "Accept": "application/json",
      "Authorization": 'Bearer $token' // Ajuste o token conforme necessário
    };

    var url = "${baseUrlw2e}demandas_ocorrencia/demandasFiltradas";

    var response = await request(
      url,
      'POST',
      body: model,
      headers: headers,
    );

    if (response.isOk) {
      return response.body;
    } else {
      throw Exception('Failed to fetch demandas!');
    }
  }

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

  Future<Map<String, dynamic>> sendLogAgenteDemanda(
      LogAgenteDemanda log) async {
    timeout = const Duration(minutes: 10);
    var token = Storagers.boxToken.read('boxToken') as String;
    timeout = const Duration(minutes: 10);
    final headers = {
      "Content-Type": "application/json",
      "Accept": "application/json",
      "Authorization": 'Bearer $token' // Ajuste o token conforme necessário
    };
    var url = "${baseUrlw2e}demandas_ocorrencia/logAgenteDemanda";
    var body = log.toMap();

    var response = await post(
      url,
      body,
      headers: headers,
    );

    if (response.isOk) {
      final responseBody = json.decode(response.bodyString ?? '{}');
      // if (responseBody == "Log de demanda já existe para este usuário.") {
      //   return true;
      // }
      return responseBody;
      print("Log enviado com sucesso!");
    } else {
      final responseBody = json.decode(response.bodyString ?? '{}');
      return responseBody;

      // throw Exception(
      //     responseBody['Message'] ?? 'Falha ao enviar log de agente demanda!');
    }
  }

  Future<List<dynamic>> getStatusDemandas() async {
    timeout = const Duration(minutes: 10);
    var token = Storagers.boxToken.read('boxToken') as String;
    final headers = {
      "Content-Type": "application/json",
      "Accept": "application/json",
      "Authorization": 'Bearer $token',
    };
    var url = "${baseUrlw2e}ocorrenciaAgente/GetstatusDemandas";

    var response = await get(
      url,
      headers: headers,
    );

    if (response.isOk) {
      final responseBody = json.decode(response.bodyString ?? '[]');
      return responseBody; // Supondo que a API retorne uma lista
    } else {
      throw Exception("Erro ao buscar status de demandas: ${response.body}");
    }
  }

  Future getImagens(int id) async {
    var token = Storagers.boxToken.read('boxToken') as String;

    final headers = {"Authorization": 'Bearer $token'};
    timeout = const Duration(minutes: 10);

    var response = await get("${baseUrlw2e}ocorrenciaAgente/Getmagem?id=$id",
        contentType: 'application/json', headers: headers);

    if (response.statusCode == 200) {
      return response.body;
    } else {}

    return response.body;
  }

  Future<void> EnviarRotaAgente(adicionarPontos adicionarPontos) async {
    var token = Storagers.boxToken.read('boxToken') as String;
    timeout = const Duration(minutes: 10);
    final headers = {
      "Content-Type": "application/json",
      "Accept": "application/json",
      "Authorization": 'Bearer $token' // Ajuste o token conforme necessário
    };
    var url = "${baseUrlw2e}demandas_ocorrencia/AdicionarPontosRodaDemanda";
    var body = adicionarPontos.toMap();

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
  Future<void> finalizarDemanda(int demandaId, String despacho, int usuarioID,
      List<ImagensMonitoramento> imagensMonitoramento) async {
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
    // var url =
    //     "${baseUrlw2e}demandas_ocorrencia/finalizarDemanda?idedemanda=$demandaId&despacho=$despacho&usuarioID=$usuarioID&imagens=$imagensMonitoramento";

    var body = {
      "idedemanda": demandaId,
      "despacho": despacho,
      "usuarioID": usuarioID,
      "imagens": imagensMonitoramento.map((imagem) => imagem.toMap()).toList(),
    };
    print(jsonEncode(body));

    var url = "${baseUrlw2e}demandas_ocorrencia/finalizarDemanda";

    // Executa a requisição GET para finalizar a demanda com parâmetros na URL

    var response = await request(
      url,
      'POST',
      body: body,
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

  Future<void> desvincularDemanda(int logDemandaId, String despacho) async {
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
    // var url =
    //     "${baseUrlw2e}demandas_ocorrencia/finalizarDemanda?idedemanda=$demandaId&despacho=$despacho&usuarioID=$usuarioID&imagens=$imagensMonitoramento";

    var body = {
      "idedemanda": logDemandaId,
      "despacho": despacho,
    };
    print(jsonEncode(body));

    var url = "${baseUrlw2e}demandas_ocorrencia/desvincularDemanda";

    // Executa a requisição GET para finalizar a demanda com parâmetros na URL

    var response = await request(
      url,
      'POST',
      body: body,
      headers: headers,
    );

    // Verifica a resposta para tratar erros
    if (response.isOk) {
      print("Demanda desvinculada com sucesso!");
    } else {
      final responseBody = json.decode(response.bodyString ?? '{}');
      throw Exception(
          responseBody['Message'] ?? 'Falha ao finalizar a demanda!');
    }
  }
}
