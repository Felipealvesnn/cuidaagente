import 'package:cuidaagente/app/data/models/LogAgenteDemanda.dart';
import 'package:cuidaagente/app/data/models/demandas.dart';
import 'package:cuidaagente/app/data/provider/demandas_provider.dart';

class DemandasRepository {
  final DemandasProvider demandasClient = DemandasProvider();

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

  Future<void> sendLogAgenteDemanda(LogAgenteDemanda log) async {
    try {
      // Envia o log para o provedor
      await demandasClient.sendLogAgenteDemanda(log);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> finalizarDemanda(int idedemanda, String despacho) async {
    try {
      // Envia o log para o provedor
      await demandasClient.finalizarDemanda(idedemanda, despacho);
    } catch (e) {
      rethrow;
    }
  }
}
