import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
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
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () {
      //     controller.createRoute();
      //   },
      //   child: const Icon(Icons.directions),
      // ),
    );
  }


}
