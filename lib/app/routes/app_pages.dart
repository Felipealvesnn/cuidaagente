import 'package:get/get.dart';

import '../modules/LOGIN/bindings/login_binding.dart';
import '../modules/LOGIN/views/login_view.dart';
import '../modules/WELCOME/bindings/welcome_binding.dart';
import '../modules/WELCOME/views/welcome_view.dart';
import '../modules/demandas/bindings/demandas_binding.dart';
import '../modules/demandas/views/demandas_view.dart';
import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.DEMANDAS;

  static final routes = [
    GetPage(
      name: _Paths.HOME,
      page: () => const HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: _Paths.DEMANDAS,
      page: () => const DemandasView(),
      binding: DemandasBinding(),
    ),
    GetPage(
      name: _Paths.WELCOME,
      page: () => const WelcomeView(),
      binding: WelcomeBinding(),
    ),
    GetPage(
      name: _Paths.LOGIN,
      page: () => const LoginView(),
      binding: LoginBinding(),
    ),
  ];
}
