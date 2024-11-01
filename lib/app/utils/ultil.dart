import 'dart:async';
import 'dart:ui';

import 'package:cuidaagente/app/data/models/PosicaoAgente.dart';
import 'package:cuidaagente/app/data/models/Usuario.dart';
import 'package:cuidaagente/app/data/repository/usuario_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart' as ph;

void showSnackbar(String title, String message) {
  Get.snackbar(
    title,
    message,
    snackPosition: SnackPosition.TOP,
    backgroundColor: Colors.white,
    duration: const Duration(seconds: 3),
  );
}

class LocationService {
  // Método para verificar e solicitar permissão
  static Future<bool> checkAndRequestPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Verifica se o serviço de localização está habilitado
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Exibe um alerta para o usuário habilitar o serviço de localização
      Get.snackbar(
        'Serviço Desabilitado',
        'Por favor, habilite o serviço de localização.',
        snackPosition: SnackPosition.BOTTOM,
      );
      return false;
    }

    // Verifica o status da permissão
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      // Solicita permissão de localização
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissão negada
        Get.snackbar(
          'Permissão Negada',
          'É necessário conceder permissão de localização.',
          snackPosition: SnackPosition.BOTTOM,
        );
        _showPermissionDeniedDialog();

        return false;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissão permanentemente negada
      _showPermissionDeniedDialog();
      return false;
    }

    // Permissão concedida
    return true;
  }

  // Exibe um diálogo caso a permissão seja negada permanentemente
  static void _showPermissionDeniedDialog() {
    Get.dialog(
      AlertDialog(
        title: const Text('Permissão Necessária'),
        content: const Text(
            'Para acessar a localização, é necessário conceder permissão. Por favor, vá até as configurações e permita o acesso à localização.'),
        actions: [
          TextButton(
            onPressed: () {
              Get.back(); // Fecha o diálogo
            },
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              Get.back();
              ph.openAppSettings(); // Abre as configurações do aplicativo
            },
            child: const Text('Abrir Configurações'),
          ),
        ],
      ),
    );
  }
}

Future<void> initializeBackgroundService({
  Function(ServiceInstance service)? funcao, // Torna funcao opcional
}) async {
  final service = FlutterBackgroundService();

  await service.configure(
    androidConfiguration: AndroidConfiguration(
      onStart: funcao ?? onStart,
      autoStart: true,
      isForegroundMode: true,// this must match with notification channel you created above.
      initialNotificationTitle: 'AWESOME SERVICE',
      initialNotificationContent: 'Initializing',
    ),
    iosConfiguration: IosConfiguration(
      onForeground: funcao ?? onStart,
      onBackground: onIosBackground,
    ),
  );

  service.startService();
}

bool onIosBackground(ServiceInstance service) {
  // WidgetsFlutterBinding.ensureInitialized();
  return true;
}

void onStart(ServiceInstance service) async {
  DartPluginRegistrant.ensureInitialized();

  bool permissionGranted = await LocationService.checkAndRequestPermission();
  if (!permissionGranted) return null;

  await mandarnotificacao();

  Timer.periodic(const Duration(minutes: 1), (timer) async {
    await mandarnotificacao();
  });
}

Future<void> mandarnotificacao() async {
  Position position = await Geolocator.getCurrentPosition();
  LatLng currentLocation = LatLng(position.latitude, position.longitude);

  // Envie os dados para sua API
  await sendLocationToApi(currentLocation);
}

Future<void> sendLocationToApi(LatLng location) async {
  UsuarioRepository repository = UsuarioRepository();
  await GetStorage.init("boxUserLogado");
  final boxUserLogado = GetStorage('boxUserLogado');
  final usuario = boxUserLogado.read('user');

  var user = usuario is Usuario ? usuario : Usuario.fromJson(usuario);

  PosicaoAgente posicao = PosicaoAgente(
    latitude: location.latitude,
    longitude: location.longitude,
    usuarioId: user.usuarioId,
  );

  await repository.sendLogAgenteDemanda(posicao);
  // Chame a sua API aqui para enviar a localização
  // Exemplo básico de como enviar os dados da localização
}
