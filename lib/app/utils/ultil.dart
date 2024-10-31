import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';

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
              openAppSettings(); // Abre as configurações do aplicativo
            },
            child: const Text('Abrir Configurações'),
          ),
        ],
      ),
    );
  }
}
