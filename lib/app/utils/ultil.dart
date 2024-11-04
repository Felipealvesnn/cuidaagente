import 'dart:async';
import 'package:background_locator_2/background_locator.dart';
import 'package:background_locator_2/settings/android_settings.dart';
import 'package:background_locator_2/settings/locator_settings.dart';
import 'package:cuidaagente/app/data/models/PosicaoAgente.dart';
import 'package:cuidaagente/app/data/models/Usuario.dart';
import 'package:cuidaagente/app/data/repository/usuario_repository.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart' as geo;
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart' as ph;
import 'package:background_locator_2/location_dto.dart';

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
    geo.LocationPermission permission;

    // Verifica se o serviço de localização está habilitado
    serviceEnabled = await geo.Geolocator.isLocationServiceEnabled();
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
    permission = await geo.Geolocator.checkPermission();
    if (permission == geo.LocationPermission.denied) {
      // Solicita permissão de localização
      permission = await geo.Geolocator.requestPermission();
      if (permission == geo.LocationPermission.denied) {
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

    if (permission == geo.LocationPermission.deniedForever) {
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

Future<void> initializeBackgroundService() async {
  await BackgroundLocator.initialize();

  BackgroundLocator.registerLocationUpdate(
    locationCallback,
    initCallback: initCallback,
    disposeCallback: disposeCallback,
    androidSettings: const AndroidSettings(
      accuracy: LocationAccuracy.NAVIGATION,
      interval: 60, // 1 minuto em segundos
      distanceFilter: 0,
      androidNotificationSettings: AndroidNotificationSettings(
        notificationChannelName: 'Rastreamento de Localização',
        notificationTitle: 'Iniciar Rastreamento de Localização',
        notificationMsg: 'Rastrear localização em segundo plano',
        notificationBigMsg:
            'A localização em segundo plano está ativada para manter o aplicativo atualizado com a sua localização. Isso é necessário para que as principais funcionalidades funcionem corretamente quando o aplicativo não está em execução.',
        notificationIcon: '',
        notificationIconColor: Colors.grey,
      ),
    ),
  );
}

// Função chamada quando o serviço de localização é iniciado
void initCallback(Map<String, dynamic> params) {
  print("Serviço de localização iniciado");
}

// Função de callback chamada para cada atualização de localização
void locationCallback(LocationDto locationDto) async {
  LatLng currentLocation = LatLng(locationDto.latitude, locationDto.longitude);
  await sendLocationToApi(currentLocation);
}

// Função de callback chamada quando o serviço é encerrado
void disposeCallback() {
  print("Serviço de localização encerrado");
}

// Função para enviar os dados para a API
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
}
