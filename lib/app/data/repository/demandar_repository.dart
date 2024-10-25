import 'package:cuidaagente/app/data/models/demandas.dart';
import 'package:cuidaagente/app/data/provider/demandas_provider.dart';

class DemandasRepository {
  final DemandasProvider demandasClient = DemandasProvider();

  Future<List<Demanda>> getDemandas() async {
    try {
      // Obtém a resposta do provedor (assumindo que é uma lista de JSON)
      dynamic response = await demandasClient.getDemandas();

      // Verifica se o retorno é uma lista de objetos JSON
      if (response is List) {
        List<Demanda> demandasList = response.map((json) => Demanda.fromMap(json)).toList();
        return demandasList;
      }  else {
        throw Exception("Tipo inesperado de resposta: ${response.runtimeType}");
      }
    } catch (e) {
      rethrow;
    }
  }
}
