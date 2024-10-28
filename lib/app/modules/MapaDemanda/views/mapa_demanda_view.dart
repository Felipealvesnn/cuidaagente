import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import '../controllers/mapa_demanda_controller.dart';

class MapaDemanda extends GetView<MapaDemandaController> {
  MapaDemanda({Key? key}) : super(key: key);

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
          final url = Uri.parse(
              'https://www.google.com/maps/dir/?api=1&origin=${controller.userLocation.value.latitude},${controller.userLocation.value.longitude}&destination=${controller.destination.latitude},${controller.destination.longitude}&travelmode=driving');

          if (await canLaunchUrl(url)) {
            await launchUrl(url);
          } else {
            Get.snackbar(
              'Erro',
              'Não foi possível abrir o Google Maps.',
              snackPosition: SnackPosition.BOTTOM,
            );
          }
        },
        child: const Icon(Icons.directions),
      ),
    );
  }
}
