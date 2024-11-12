import 'package:cuidaagente/app/data/models/naturezaOcorrencia.dart';
import 'package:cuidaagente/app/data/models/ocorrenciaPost.dart';
import 'package:cuidaagente/app/data/models/tipoOcorrencia.dart';
import 'package:cuidaagente/app/data/provider/ocorrencia_provider.dart';

class OcorrenciaRepository {
  final OcorrenciaProvider apiclient = OcorrenciaProvider();

  // Método para postar uma ocorrência
  Future<Map<String, dynamic>?> postOcorrencia(OcorrenciaPost ocorrencia) async {
    return await apiclient.postOcorrencia(ocorrencia);
  }

  // Método para obter a lista de natureza_ocorrencia
  Future<List<natureza_ocorrencia>> getNatureza() async {
    var response = await apiclient.GetNatureza();

    List<natureza_ocorrencia> naturezaOcorrenciaList = [];
    if (response != null) {
      // Verifica se a resposta é uma lista de mapas (List<Map<String, dynamic>>)
      if (response is List<dynamic>) {
        for (var item in response) {
          // Cada item da lista deve ser um Map<String, dynamic>
          if (item is Map<String, dynamic>) {
            naturezaOcorrenciaList.add(natureza_ocorrencia.fromMap(item));
          }
        }
      }
    }
    return naturezaOcorrenciaList;
  }

  Future<List<tipo_ocorrencia>> getTipoOcorrencia(
      int natureza_ocorrencia_idsync) async {
    var response =
        await apiclient.GetTipoOcorrencia(natureza_ocorrencia_idsync);

    List<tipo_ocorrencia> tipoOcorrenciaList = [];
    if (response != null) {
      // Verifica se a resposta é uma lista de mapas (List<Map<String, dynamic>>)
      if (response is List<dynamic>) {
        for (var item in response) {
          // Cada item da lista deve ser um Map<String, dynamic>
          if (item is Map<String, dynamic>) {
            tipoOcorrenciaList.add(tipo_ocorrencia.fromMap(item));
          }
        }
      }
    }
    return tipoOcorrenciaList;
  }
}
