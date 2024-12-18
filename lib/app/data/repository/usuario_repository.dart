import 'package:cuidaagente/app/data/models/PosicaoAgente.dart';
import 'package:cuidaagente/app/data/models/Usuario.dart';
import 'package:cuidaagente/app/data/provider/usuario_provider.dart';

class UsuarioRepository {
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

  Future<bool> ResetarSenha(
      String username, String password, int usuario_id) async {
    Map<String, dynamic>? json =
        await apiclient.resetarSenha(username, password, usuario_id);

    if (json == null) {
      return false;
    } else {
      return true;
    }
  }

  Future<void> sendLogAgenteDemanda(PosicaoAgente log) async {
    try {
      await apiclient.sendLogAgenteDemanda(log);
    } on Exception catch (e) {
      // TODO
    }
  }
}
