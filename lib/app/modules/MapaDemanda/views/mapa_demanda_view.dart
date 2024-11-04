import 'dart:convert';
import 'package:cuidaagente/app/modules/LOGIN/controllers/login_controller.dart';
import 'package:cuidaagente/app/utils/ultil.dart';
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
            controller.userLocation.value.longitude == 0.0 &&
            controller.polylines.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        return Obx(() => GoogleMap(
              myLocationButtonEnabled: true,
              initialCameraPosition: CameraPosition(
                target: controller.userLocation.value,
                zoom: 14,
              ),
              markers: _buildMarkers(),
              polylines: controller.polylines,
              onMapCreated: (mapController) {
                controller.mapController = mapController;
                controller.moveCameraToCurrentPosition();
              },
            ));
      }),
      floatingActionButton: _buildFloatingButtons(context, controller),
    );
  }

  // Constrói o conjunto de marcadores
  Set<Marker> _buildMarkers() {
    return {
      Marker(
        markerId: const MarkerId('userLocation'),
        position: controller.userLocation.value,
      ),
      Marker(
        markerId: const MarkerId('destination'),
        position: controller.destination,
      ),
    };
  }

  // Constrói os botões flutuantes empilhados
  Widget _buildFloatingButtons(
      BuildContext context, MapaDemandaController controller) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        FloatingActionButton(
          heroTag: "finalizar_demanda",
          onPressed: () => _showFinalizarDemandaModal(context, controller),
          child: const Icon(Icons.check),
          tooltip: 'Finalizar Demanda',
        ),
        const SizedBox(height: 16),
        FloatingActionButton(
          heroTag: "directions_button",
          onPressed: () => _openMapSelection(context),
          child: const Icon(Icons.directions),
          tooltip: 'Abrir Mapa',
        ),
        const SizedBox(height: 16),
        FloatingActionButton(
          heroTag: "directions_button",
          onPressed: ()async => await controller.moveCameraToCurrentPosition(),
          child: const Icon(Icons.map),
          tooltip: 'Abrir Mapa',
        ),
      ],
    );
  }

  // Modal para finalizar demanda com motivo
  Future<void> _showFinalizarDemandaModal(
      BuildContext context, MapaDemandaController contrltetext) async {
    await showModalBottomSheet(
      isScrollControlled: true, // Permite que o modal ocupe o espaço necessário
      context: context,
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            top: 16.0,
            left: 16.0,
            right: 16.0,
            // Ajusta o padding inferior para acomodar o teclado
            bottom: MediaQuery.of(context).viewInsets.bottom + 16.0,
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Finalizar Demanda',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: contrltetext.motivoController,
                  decoration: const InputDecoration(
                    labelText: 'Motivo da Finalização',
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    _showConfirmationDialog(context, contrltetext);
                  },
                  child: const Text('Finalizar'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // Diálogo de confirmação para finalizar demanda
  Future<void> _showConfirmationDialog(
      BuildContext context, MapaDemandaController controler) async {
    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Confirmação'),
          content: const Text('Tem certeza que deseja finalizar a demanda?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Não'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                controler.finalizarDemanda();
              },
              child: const Text('Sim'),
            ),
          ],
        );
      },
    );
  }

  // Função para finalizar a demanda e exibir feedback

  // Abre a seleção de mapas disponíveis
  Future<void> _openMapSelection(BuildContext context) async {
    final origin = Coords(
      controller.userLocation.value.latitude,
      controller.userLocation.value.longitude,
    );
    final destination = Coords(
      controller.destination.latitude,
      controller.destination.longitude,
    );

    final availableMaps = await MapLauncher.installedMaps;

    if (availableMaps.isNotEmpty) {
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
                      map.showDirections(
                        origin: origin,
                        destination: destination,
                        directionsMode: DirectionsMode.driving,
                      );
                      Get.back();
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
      showSnackbar(
        'Erro',
        'Nenhum aplicativo de mapa encontrado.',
      );
    }
  }
}
