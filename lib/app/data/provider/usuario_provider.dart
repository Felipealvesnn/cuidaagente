import 'package:cuidaagente/app/data/global/constants.dart';
import 'package:cuidaagente/app/data/models/Usuario.dart';
import 'package:get/get_connect/connect.dart';


class UsuarioProvider extends GetConnect {
  Future postVistoria(Usuario usu) async {
    timeout = const Duration(minutes: 10);
    final headers = {
      "Content-Type": "application/json",
      "Accept": "application/json",
      "Authorization": "sdfsdf"
    };

    final body = usu.toJson();

     var response = await post(
      "$baseUrlw2e/login", // Nome do cliente adicionado como query parameter
      body,
      headers: headers,
    );

    if (response.statusCode == 200) {
      return response.body;
    } else {
      throw Exception('Failed to load data!');
    }
  }
}
