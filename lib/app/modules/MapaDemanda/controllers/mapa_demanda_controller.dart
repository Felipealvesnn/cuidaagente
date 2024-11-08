import 'dart:async';
import 'package:cuidaagente/app/data/models/LogAgenteDemanda.dart';
import 'package:cuidaagente/app/data/models/Usuario.dart';
import 'package:cuidaagente/app/data/models/adicionarPontos.dart';
import 'package:cuidaagente/app/data/repository/demandar_repository.dart';
import 'package:cuidaagente/app/routes/app_pages.dart';
import 'package:cuidaagente/app/utils/getstorages.dart';
import 'package:cuidaagente/app/utils/ultil.dart';
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
  var polylineCoordinates = <LatLng>[].obs;
  late PolylinePoints polylinePoints;
  var polylines = <Polyline>{}.obs;
  late Usuario usuario;
  StreamSubscription<Position>? positionStream;
  var userLocation = const LatLng(0.0, 0.0).obs; // Localização inicial padrão
  final keymaps = 'AIzaSyAsinfHRMZKKrM5CH7L0IoDpQSIJ2dWios';
  bool IniciadaDemanda = false;

  @override
  void onInit() async {
    super.onInit();
    usuario = Storagers.boxUserLogado.read('user');

    // Recebe latitude e longitude dos argumentos
    destinationLatitude = Get.arguments['latitude'] ?? -3.7327;
    destinationLongitude = Get.arguments['longitude'] ?? -38.5267;
    destination = LatLng(destinationLatitude, destinationLongitude);
    demandaId = Get.arguments['demanda_id'];
    IniciadaDemanda = Get.arguments['IniciadaDemanda'] ?? false;

    polylinePoints = PolylinePoints();
    await getUserLocation();
    await createRoute();
    //await logDemandaAgente();

    // Inicia o monitoramento da posição
    positionStream =
        Geolocator.getPositionStream().listen((Position position) async {
      LatLng newPosition = LatLng(position.latitude, position.longitude);

      // Calcula a distância entre a última posição e a nova posição
      double distance = Geolocator.distanceBetween(
        userLocation.value.latitude,
        userLocation.value.longitude,
        newPosition.latitude,
        newPosition.longitude,
      );
      // Atualiza somente se a distância for maior que um certo limite (ex: 5 metros)
      if (distance > 10) {
        userLocation.value = newPosition;
        await updateRoute();
        await moveCameraToCurrentPosition();
        //await enviarPontosRota();
      }
    });
  }

  Future<void> getUserLocation() async {
    // Primeiro, verifica e solicita permissão
    bool permissionGranted = await LocationService.checkAndRequestPermission();
    if (!permissionGranted) return;

    // Se a permissão for concedida, obtém a posição
    Position position = await Geolocator.getCurrentPosition();
    userLocation.value = LatLng(position.latitude, position.longitude);
  }

  Future<void> createRoute() async {
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      request: PolylineRequest(
        origin: PointLatLng(
            userLocation.value.latitude, userLocation.value.longitude),
        destination: PointLatLng(destination.latitude, destination.longitude),
        mode: TravelMode.driving,
      ),
      googleApiKey: keymaps,
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
      googleApiKey: keymaps,
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

  Future<void> moveCameraToCurrentPosition() async {
    await mapController.animateCamera(
      CameraUpdate.newLatLngZoom(userLocation.value, 20),
    );
  }

  var Finalizado = true;
  Future<void> finalizarDemanda() async {
    // Exibe o diálogo de carregamento para bloquear a tela

    try {
      double distance = Geolocator.distanceBetween(
        userLocation.value.latitude,
        userLocation.value.longitude,
        destinationLatitude,
        destinationLongitude,
      );
      if (distance < 20) {
        Get.dialog(
          const Center(
            child: CircularProgressIndicator(),
          ),
          barrierDismissible: false, // Impede que o usuário feche o diálogo
        );
        // Chama o método de finalização da demanda
        await demandasRepository.finalizarDemanda(
          demandaId,
          motivoController.text,
          usuario.usuarioId!,
        );
        Finalizado = true;
      } else {
        Get.snackbar(
          'Info',
          'Você precisa estar próximo ao local da demanda para finalizar.',
          snackPosition: SnackPosition.BOTTOM,
        );
        Finalizado = false;
        return;
      }

      // Exibe o Snackbar de confirmação
      Get.snackbar(
        'Demanda Finalizada',
        'A demanda foi finalizada com sucesso.',
        snackPosition: SnackPosition.BOTTOM,
      );

      // Redireciona para a rota DEMANDAS após finalizar
      await Get.offAllNamed(Routes.DEMANDAS);
    } catch (e) {
      print(e);
    } finally {
      if (Finalizado) {
        Get.snackbar(
          'Demanda Finalizada',
          'A demanda foi finalizada com sucesso.',
          snackPosition: SnackPosition.BOTTOM,
        );
        await Get.offAllNamed(Routes.DEMANDAS);
      }
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
