import 'dart:convert';
import 'package:cuidaagente/app/data/global/constants.dart';
import 'package:cuidaagente/app/utils/getstorages.dart';
import 'package:get/get_connect/connect.dart';

class DemandasProvider extends GetConnect {
  Future getDemandas({int pageNumber = 1, int pageSize = 10}) async {
    timeout = const Duration(minutes: 10);
    final headers = {
      "Content-Type": "application/json",
      "Accept": "application/json",
      "Authorization": "sdfsdf" // Ajuste o token conforme necessário
    };
    List<int> parametros = (await Storagers.boxUserLogado.read('boxOrgaoIds') as List<dynamic>).cast<int>();

   // List<int> parametros = [13, 3]; // IDs enviados no corpo da requisição

    // URL com parâmetros de paginação
    var url =
        "${baseUrlw2e}demandas_ocorrencia/Getdemandas_ocorrencia?pageNumber=$pageNumber&pageSize=$pageSize";

    var response = await request(
      url,
      'GET', // Usando POST para enviar o corpo com parâmetros
      body: parametros, // Corpo da requisição contendo os IDs
      headers: headers,
    );

    // Trata a resposta para verificar a mensagem de erro
    if (response.isOk) {
      return response.body;
    } else {
      final responseBody = json.decode(response.bodyString ?? '{}');
      if (responseBody['Message'] == "Número de página inválido.") {
        return []; // Retorna lista vazia se a página é inválida
      }
      throw Exception('Failed to fetch demandas!');
    }
  }
}
