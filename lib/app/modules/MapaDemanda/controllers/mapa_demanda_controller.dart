import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';

class MapaDemandaController extends GetxController {
  late double destinationLatitude;
  late double destinationLongitude;

  late GoogleMapController mapController;
  late LatLng destination;
  var userLocation = LatLng(-3.7327, -38.5267).obs; // Localização inicial padrão
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

    polylinePoints = PolylinePoints();
    await _getUserLocation();
    await createRoute();

    // Inicia o monitoramento da posição
    positionStream = Geolocator.getPositionStream().listen((Position position) {
      userLocation.value = LatLng(position.latitude, position.longitude);
      // updateRoute();
      // _moveCameraToCurrentPosition();
    });
  }

  Future<void> _getUserLocation() async {
    // Solicita permissões e obtém a posição inicial
    Position position = await Geolocator.getCurrentPosition();
    userLocation.value = LatLng(position.latitude, position.longitude);

    // Atualiza a câmera para a posição inicial do usuário
    _moveCameraToCurrentPosition();
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
        origin: PointLatLng(userLocation.value.latitude, userLocation.value.longitude),
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

  void _moveCameraToCurrentPosition() {
    if (mapController != null) {
      mapController.animateCamera(
        CameraUpdate.newLatLngZoom(userLocation.value, 15),
      );
    }
  }

  @override
  void onClose() {
    positionStream?.cancel(); // Encerra o monitoramento ao sair
    super.onClose();
  }
}
