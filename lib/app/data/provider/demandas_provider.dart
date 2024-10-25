import 'package:cuidaagente/app/data/global/constants.dart';
import 'package:get/get_connect/connect.dart';

class DemandasProvider extends GetConnect {
  Future getDemandas() async {
    timeout = const Duration(minutes: 10);
    final headers = {
      "Content-Type": "application/json",
      "Accept": "application/json",
      "Authorization": "sdfsdf" // Ajuste o token conforme necessário
    };

    List<int> parametros = [13, 3]; // Parâmetros que devem ser enviados no corpo da requisição

    final body = parametros; // Corpo da requisição

    var response = await request(
      "${baseUrlw2e}demandas_ocorrencia/Getdemandas_ocorrencia",
      'GET', // Método GET
      body: body, // Corpo da requisição
      headers: headers,
    );

    if (response.statusCode == 200) {
      return response.body;
    } else {
      throw Exception('Failed to fetch demandas!');
    }
  }
}
