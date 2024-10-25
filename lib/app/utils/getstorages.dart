import 'package:get_storage/get_storage.dart';

inicializacaoGetStorage() async {
  try {
    //inicialização
    await GetStorage.init("boxUserLogado");
    await GetStorage.init("boxCpf");
    await GetStorage.init("boxToken");
     await GetStorage.init("boxInicial");
  } catch (e) {}
}

class Storagers {
  //instanciação
  static final boxUserLogado = GetStorage('boxUserLogado');
  static final boxCpf = GetStorage('boxCpf');
  static final boxToken = GetStorage('boxToken');
  static final boxInicial = GetStorage("boxInicial");
}

