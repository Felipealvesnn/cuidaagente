import 'package:get/get.dart';

import '../modules/CONFIGURACOES/bindings/configuracoes_binding.dart';
import '../modules/CONFIGURACOES/views/configuracoes_view.dart';
import '../modules/LOGIN/bindings/login_binding.dart';
import '../modules/LOGIN/views/login_view.dart';
import '../modules/MapaDemanda/bindings/mapa_demanda_binding.dart';
import '../modules/MapaDemanda/views/mapa_demanda_view.dart';
import '../modules/WELCOME/bindings/welcome_binding.dart';
import '../modules/WELCOME/views/welcome_view.dart';
import '../modules/demandas/bindings/demandas_binding.dart';
import '../modules/demandas/views/demandas_view.dart';
import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';
import '../modules/mudar_senha/bindings/mudar_senha_binding.dart';
import '../modules/mudar_senha/views/mudar_senha_view.dart';
import '../modules/ocorrencia/bindings/ocorrencia_binding.dart';
import '../modules/ocorrencia/views/ocorrencia_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.HOME;

  static final routes = [
    GetPage(
      name: _Paths.HOME,
      page: () => const HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: _Paths.DEMANDAS,
      page: () => DemandasView(),
      binding: DemandasBinding(),
    ),
    GetPage(
      name: _Paths.WELCOME,
      page: () => WelcomeView(),
      binding: WelcomeBinding(),
    ),
    GetPage(
      name: _Paths.LOGIN,
      page: () => LoginPageView(),
      binding: LoginBinding(),
    ),
    GetPage(
      name: _Paths.CONFIGURACOES,
      page: () => const ConfiguracoesView(),
      binding: ConfiguracoesBinding(),
    ),
    GetPage(
      name: _Paths.MAPA_DEMANDA,
      page: () => MapaDemanda(),
      binding: MapaDemandaBinding(),
    ),
    GetPage(
      name: _Paths.OCORRENCIA,
      page: () => OcorrenciaView(),
      binding: OcorrenciaBinding(),
    ),
    GetPage(
      name: _Paths.MUDAR_SENHA,
      page: () => const MudarSenhaView(),
      binding: MudarSenhaBinding(),
    ),
  ];
}
