import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../controllers/mapa_demanda_controller.dart';
import 'package:map_launcher/map_launcher.dart';

class MapaDemanda extends GetView<MapaDemandaController> {
  const MapaDemanda({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mapa de Demanda'),
      ),
      body: Obx(() {
        if (controller.userLocation.value.latitude == 0.0 &&
            controller.userLocation.value.longitude == 0.0) {
          return const Center(child: CircularProgressIndicator());
        }

        return Obx(() => GoogleMap(
              myLocationButtonEnabled: true,
              initialCameraPosition: CameraPosition(
                target: controller.userLocation.value,
                zoom: 14,
              ),
              markers: {
                Marker(
                    markerId: const MarkerId('userLocation'),
                    position: controller.userLocation.value),
                Marker(
                    markerId: const MarkerId('destination'),
                    position: controller.destination),
              },
              polylines: controller.polylines,
              onMapCreated: (GoogleMapController mapController) {
                controller.mapController = mapController;
              },
            ));
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final origin = Coords(
            controller.userLocation.value.latitude,
            controller.userLocation.value.longitude,
          );
          final destination = Coords(
            controller.destination.latitude,
            controller.destination.longitude,
          );

          // Verifica quais mapas estão disponíveis
          final availableMaps = await MapLauncher.installedMaps;

          if (availableMaps.isNotEmpty) {
            // Mostra a lista de mapas para o usuário escolher
            await showModalBottomSheet(
              context: context,
              builder: (context) {
                return SafeArea(
                  child: Wrap(
                    children: [
                      const ListTile(
                        title: Text(
                          'Escolha seu mapa',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      ...availableMaps.map((map) {
                        return ListTile(
                          onTap: () {
                            // Abre o mapa selecionado com a rota de navegação
                            map.showDirections(
                              origin: origin,
                              destination: destination,
                              directionsMode: DirectionsMode.driving,
                            );
                            Get.back(); // Fecha o modal
                          },
                          title: Text(map.mapName),
                          leading: SvgPicture.asset(
                            map.icon,
                            height: 30.0,
                            width: 30.0,
                          ),
                        );
                      }),
                    ],
                  ),
                );
              },
            );
          } else {
            Get.snackbar(
              'Erro',
              'Nenhum aplicativo de mapa encontrado.',
              snackPosition: SnackPosition.BOTTOM,
            );
          }
        },
        child: const Icon(Icons.directions),
      ),
    );
  }
}
