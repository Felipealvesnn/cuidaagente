import 'dart:async';

import 'package:cuidaagente/app/data/models/LogAgenteDemanda.dart';
import 'package:cuidaagente/app/data/models/Usuario.dart';
import 'package:cuidaagente/app/data/models/demandas.dart';
import 'package:cuidaagente/app/data/repository/demandar_repository.dart';
import 'package:cuidaagente/app/routes/app_pages.dart';
import 'package:cuidaagente/app/utils/getstorages.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';

final DemandasRepository demandasRepository = DemandasRepository();

class MapaDemandaController extends GetxController {
  TextEditingController motivoController = TextEditingController();
  late double destinationLatitude;
  late double destinationLongitude;
  late int demandaId;
  late GoogleMapController mapController;
  late LatLng destination;
  var userLocation = const LatLng(0.0, 0.0).obs; // Localização inicial padrão
  var polylineCoordinates = <LatLng>[].obs;
  late PolylinePoints polylinePoints;
  var polylines = <Polyline>{}.obs;
  StreamSubscription<Position>? positionStream;

  @override
  void onInit() async {
    super.onInit();

    // Recebe latitude e longitude dos argumentos
    destinationLatitude = Get.arguments['latitude'] ?? -3.7327;
    destinationLongitude = Get.arguments['longitude'] ?? -38.5267;
    destination = LatLng(destinationLatitude, destinationLongitude);
    demandaId = Get.arguments['demanda_id'];
    polylinePoints = PolylinePoints();
    await _getUserLocation();
    await createRoute();
    await logDemandaAgente();

    // Inicia o monitoramento da posição
    // positionStream = Geolocator.getPositionStream().listen((Position position) {
    //   userLocation.value = LatLng(position.latitude, position.longitude);
    //     updateRoute();
    //    _moveCameraToCurrentPosition();
    // });
  }

  Future<void> _getUserLocation() async {
    // Solicita permissões e obtém a posição inicial
    Position position = await Geolocator.getCurrentPosition();
    userLocation.value = LatLng(position.latitude, position.longitude);

    // Atualiza a câmera para a posição inicial do usuário
    // moveCameraToCurrentPosition();
  }

  Future<void> createRoute() async {
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      request: PolylineRequest(
        origin: PointLatLng(
            userLocation.value.latitude, userLocation.value.longitude),
        destination: PointLatLng(destination.latitude, destination.longitude),
        mode: TravelMode.driving,
      ),
      googleApiKey: 'AIzaSyAsinfHRMZKKrM5CH7L0IoDpQSIJ2dWios',
    );

    if (result.points.isNotEmpty) {
      for (var point in result.points) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      }

      polylines.add(Polyline(
        polylineId: const PolylineId('route'),
        color: Colors.blue,
        width: 5,
        points: polylineCoordinates,
      ));
    }
  }

  Future<void> updateRoute() async {
    // Atualiza a rota conforme a posição do usuário muda
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      request: PolylineRequest(
        origin: PointLatLng(
            userLocation.value.latitude, userLocation.value.longitude),
        destination: PointLatLng(destination.latitude, destination.longitude),
        mode: TravelMode.driving,
      ),
      googleApiKey: 'AIzaSyAsinfHRMZKKrM5CH7L0IoDpQSIJ2dWios',
    );

    if (result.points.isNotEmpty) {
      polylineCoordinates.clear();
      for (var point in result.points) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      }
      polylines.clear();
      polylines.add(Polyline(
        polylineId: const PolylineId('route'),
        color: Colors.blue,
        width: 5,
        points: polylineCoordinates,
      ));
    }
  }

  void moveCameraToCurrentPosition() {
    mapController.animateCamera(
      CameraUpdate.newLatLngZoom(userLocation.value, 15),
    );
  }

  Future<void> finalizarDemanda() async {
    // Exibe o diálogo de carregamento para bloquear a tela

    Get.dialog(
      const Center(child: CircularProgressIndicator()),
      barrierDismissible: false, // Impede que o usuário feche o diálogo
    );

    try {
      // Chama o método de finalização da demanda
      await demandasRepository.finalizarDemanda(
        demandaId,
        motivoController.text,
      );

      // Exibe o Snackbar de confirmação
      Get.snackbar(
        'Demanda Finalizada',
        'A demanda foi finalizada com sucesso.',
        snackPosition: SnackPosition.BOTTOM,
      );

      // Redireciona para a rota DEMANDAS após finalizar
      await Get.offAllNamed(Routes.DEMANDAS);
    } catch (e) {
      // Trate o erro, caso ocorra
      Get.snackbar(
        'Erro',
        'Ocorreu um erro ao finalizar a demanda.',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      // Fecha o diálogo de carregamento ao final da execução

      Get.back();
      Get.snackbar(
        'Demanda Finalizada',
        'A demanda foi finalizada com sucesso.',
        snackPosition: SnackPosition.BOTTOM,
      );
      await Get.offAllNamed(Routes.DEMANDAS);
    }
  }

  Future<void> logDemandaAgente() async {
    Usuario usuario = await Storagers.boxUserLogado.read('user') as Usuario;

    // Cria um novo log com os dados da demanda
    LogAgenteDemanda log = LogAgenteDemanda(
      usuarioId: usuario.usuarioId, // ID do usuário logado
      latitude: userLocation.value.latitude, // Latitude do dispositivo
      longitude: userLocation.value.longitude, // Longitude do dispositivo
      demandaId: Get.arguments['demanda_id'], // ID da demanda
      dataIniciado: DateTime.now(), // Data de início do atendimento
    );
    // Envia o log para o servidor
    await demandasRepository.sendLogAgenteDemanda(log);
  }

  @override
  void onClose() {
    positionStream?.cancel(); // Encerra o monitoramento ao sair
    super.onClose();
  }
}
