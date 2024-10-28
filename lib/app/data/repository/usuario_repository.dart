import 'package:cuidaagente/app/data/models/Usuario.dart';
import 'package:cuidaagente/app/data/provider/usuario_provider.dart';

class 

UsuarioRepository {
  final UsuarioProvider apiclient = UsuarioProvider();


//----------------------------------------------------------------------------
  Future<Usuario> login(String username, String password) async {
    Map<String, dynamic>? json = await apiclient.login(username, password);
    Usuario userNullo = Usuario();
    if (json == null) {
      return userNullo;
    } else {
      return Usuario.fromMap(json);
    }
  }
}
