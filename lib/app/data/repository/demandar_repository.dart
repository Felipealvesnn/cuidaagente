import 'package:cuidaagente/app/data/models/LogAgenteDemanda.dart';
import 'package:cuidaagente/app/data/models/adicionarPontos.dart';
import 'package:cuidaagente/app/data/models/demandas.dart';
import 'package:cuidaagente/app/data/models/ocorrenciaPost.dart';
import 'package:cuidaagente/app/data/provider/demandas_provider.dart';
import 'package:cuidaagente/app/data/models/log_VideoMonitoramento.dart' as log;

class DemandasRepository {
  final DemandasProvider demandasClient = DemandasProvider();

  Future<void> EnviarRotaAgente(adicionarPontos model) async {
    try {
      return await demandasClient.EnviarRotaAgente(model);
    } on Exception catch (e) {
      // TODO
    }
  }

  Future<List<log.ImagensMonitoramento>> getImagens(int id) async {
    List<log.ImagensMonitoramento> listOcorrencias =
        <log.ImagensMonitoramento>[];
    try {
      var response = await demandasClient.getImagens(id);
      if (response != null) {
        if (response is List<log.ImagensMonitoramento>) {
          listOcorrencias = response;
        } else if (response is log.ImagensMonitoramento) {
          listOcorrencias.add(response);
        } else {
          response.forEach((element) {
            listOcorrencias.add(log.ImagensMonitoramento.fromJson(element));
          });
        }
      }
    } catch (e) {}
    return listOcorrencias;
  }
  

   Future<List<Demanda>> getDemandasFiltradas(Map<String, Object?> model
      ) async {
    try {
      // Obtém a resposta do provedor (assumindo que é uma lista de JSON)
      dynamic response = await demandasClient.getDemandasFiltradas(model);

      // Verifica se o retorno é uma lista de objetos JSON
      if (response is List) {
        List<Demanda> demandasList =
            response.map((json) => Demanda.fromMap(json)).toList();
        return demandasList;
      } else {
        throw Exception("Tipo inesperado de resposta: ${response.runtimeType}");
      }
    } catch (e) {
      rethrow;
    }
  }



  Future<List<Demanda>> getDemandas(
      {int pageNumber = 1, int pageSize = 10}) async {
    try {
      // Obtém a resposta do provedor (assumindo que é uma lista de JSON)
      dynamic response = await demandasClient.getDemandas(
          pageNumber: pageNumber, pageSize: pageSize);

      // Verifica se o retorno é uma lista de objetos JSON
      if (response is List) {
        List<Demanda> demandasList =
            response.map((json) => Demanda.fromMap(json)).toList();
        return demandasList;
      } else {
        throw Exception("Tipo inesperado de resposta: ${response.runtimeType}");
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<LogAgenteDemanda> sendLogAgenteDemanda(LogAgenteDemanda log) async {
    try {
      // Envia o log para o provedor
      final value = await demandasClient.sendLogAgenteDemanda(log);
      final logdemand = LogAgenteDemanda.fromMap(value);
      return logdemand;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> finalizarDemanda(int idedemanda, String despacho, int usuarioID,
      List<ImagensMonitoramento> imagensMonitoramento) async {
    try {
      // Envia o log para o provedor
      await demandasClient.finalizarDemanda(
          idedemanda, despacho, usuarioID, imagensMonitoramento);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> desvincularDemanda(int logDemandaId, String despacho) async {
    try {
      // Envia o log para o provedor
      await demandasClient.desvincularDemanda(
        logDemandaId,
        despacho,
      );
    } catch (e) {
      rethrow;
    }
  }
}
