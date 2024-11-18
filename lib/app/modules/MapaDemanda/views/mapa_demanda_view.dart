import 'dart:convert';
import 'package:cuidaagente/app/modules/LOGIN/controllers/login_controller.dart';
import 'package:cuidaagente/app/routes/app_pages.dart';
import 'package:cuidaagente/app/utils/ultil.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import '../controllers/mapa_demanda_controller.dart';
import 'package:map_launcher/map_launcher.dart';

class MapaDemanda extends GetView<MapaDemandaController> {
  const MapaDemanda({super.key});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvokedWithResult: (didPop, result) async {
        if (controller.IniciadaDemanda) {
          Get.back(closeOverlays: true);
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Rota Ocorrência'),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.startDocked,
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
      ),
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
    return Padding(
      padding: const EdgeInsets.only(bottom: 26.0),
      child: SpeedDial(
        animationCurve: Curves.easeInOutCubic,
        animatedIcon: AnimatedIcons.menu_close, // Ícone animado de menu
        overlayColor: Colors.black,
        overlayOpacity: 0.4,
        spaceBetweenChildren: 16, // Espaço entre os botões
        children: [
          SpeedDialChild(
            child: const Icon(Icons.check, color: Colors.white),
            backgroundColor: Colors.green,
            label: 'Finalizar Demanda',
            labelStyle: const TextStyle(fontSize: 14),
            onTap: () => _showFinalizarDesvincularModal(context, controller),
          ),
          SpeedDialChild(
            child: const Icon(Icons.photo, color: Colors.white),
            backgroundColor: Colors.orange,
            label: 'Adicionar Fotos',
            labelStyle: const TextStyle(fontSize: 14),
            onTap: () => _showImageSourceSelection(context),
          ),
          SpeedDialChild(
            child: const Icon(Icons.directions, color: Colors.white),
            backgroundColor: Colors.blue,
            label: 'Abrir Mapa',
            labelStyle: const TextStyle(fontSize: 14),
            onTap: () => _openMapSelection(context),
          ),
          SpeedDialChild(
            child: const Icon(Icons.my_location, color: Colors.white),
            backgroundColor: Colors.purple,
            label: 'Mover Câmera',
            labelStyle: const TextStyle(fontSize: 14),
            onTap: () async => await controller.moveCameraToCurrentPosition(),
          ),
        ],
      ),
    );
  }

  // Modal para finalizar demanda com motivo
  Future<void> _showFinalizarDesvincularModal(
      BuildContext context, MapaDemandaController contrltetext) async {
    RxBool isFinalizar =
        true.obs; // Controle para alternar entre finalizar e desvincular

    await showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (context) {
        return Obx(() => Padding(
              padding: EdgeInsets.only(
                top: 16.0,
                left: 16.0,
                right: 16.0,
                bottom: MediaQuery.of(context).viewInsets.bottom + 16.0,
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Alternância entre Finalizar e Desvincular
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ChoiceChip(
                          label: const Text('Finalizar'),
                          selected: isFinalizar.value,
                          onSelected: (selected) {
                            isFinalizar.value = true;
                          },
                        ),
                        const SizedBox(width: 10),
                        ChoiceChip(
                          label: const Text('Desvincular'),
                          selected: !isFinalizar.value,
                          onSelected: (selected) {
                            isFinalizar.value = false;
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Text(
                      isFinalizar.value
                          ? 'Finalizar Demanda'
                          : 'Desvincular da Demanda',
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: contrltetext.motivoController,
                      decoration: InputDecoration(
                        labelText: isFinalizar.value
                            ? 'Motivo da Finalização'
                            : 'Motivo do Desvínculo',
                      ),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () async {
                        if (contrltetext.motivoController.text.isEmpty) {
                          Get.snackbar(
                            "Campo obrigatório",
                            "Por favor, informe o motivo.",
                            backgroundColor: Colors.red,
                            colorText: Colors.white,
                          );
                          return;
                        }

                        if (isFinalizar.value) {
                          // Lógica para Finalizar
                          bool validarDistancia =
                              await Get.find<MapaDemandaController>()
                                  .ValidarDistancia();
                          if (validarDistancia) {
                            Navigator.of(context).pop();
                            await _showConfirmationDialog(
                                context, contrltetext, true);
                          }
                        } else {
                          bool validarDistancia =
                              await Get.find<MapaDemandaController>()
                                  .ValidarDistancia();
                          // Lógica para Desvincular
                          if (validarDistancia) {
                            Navigator.of(context).pop();
                            await _showConfirmationDialog(
                                context, contrltetext, false);
                          }
                        }
                      },
                      child:
                          Text(isFinalizar.value ? 'Finalizar' : 'Desvincular'),
                    ),
                  ],
                ),
              ),
            ));
      },
    );
  }

  void _showImageSourceSelection(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Wrap(
            children: [
              _imageSourceTile(
                icon: Icons.photo_library,
                label: 'Selecionar da galeria',
                source: ImageSource.gallery,
              ),
              _imageSourceTile(
                icon: Icons.camera_alt,
                label: 'Tirar foto',
                source: ImageSource.camera,
              ),
              _buildSelectedImages(context),
            ],
          ),
        );
      },
    );
  }

  ListTile _imageSourceTile({
    required IconData icon,
    required String label,
    required ImageSource source,
  }) {
    return ListTile(
      leading: Icon(icon),
      title: Text(label),
      onTap: () async {
        await controller.pickImage(source);
        // Get.back();
      },
    );
  }

  Widget _buildSelectedImages(BuildContext context) {
    return Obx(
      () {
        return controller.selectedImages.isEmpty
            ? Container()
            : Wrap(
                spacing: 8.0,
                runSpacing: 8.0,
                children: controller.selectedImages.map((imageFile) {
                  return Stack(
                    alignment: Alignment
                        .center, // Alinhar o conteúdo do Stack ao centro
                    children: [
                      ClipOval(
                        child: Image.file(
                          imageFile,
                          height: 100,
                          width: 100,
                          fit: BoxFit.cover,
                        ),
                      ),
                      IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () {
                            Get.dialog(AlertDialog(
                              title: const Text("Confirmar"),
                              content:
                                  const Text("Você deseja excluir a imagem?"),
                              actions: [
                                TextButton(
                                  child: const Text("Cancelar"),
                                  onPressed: () {
                                    Get.back();
                                  },
                                ),
                                TextButton(
                                  child: const Text("Excluir"),
                                  onPressed: () {
                                    controller.selectedImages.remove(imageFile);
                                    Get.back();
                                  },
                                ),
                              ],
                            ));
                          })
                    ],
                  );
                }).toList(),
              );
      },
    );
  }

  // Diálogo de confirmação para finalizar demanda
  Future<void> _showConfirmationDialog(BuildContext context,
      MapaDemandaController controller, bool isFinalizar) async {
    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
              isFinalizar ? 'Confirmar Finalização' : 'Confirmar Desvínculo'),
          content: Text(isFinalizar
              ? 'Deseja finalizar esta demanda?'
              : 'Deseja desvincular da demanda?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Não'),
            ),
            ElevatedButton(
              onPressed: () async {
                Navigator.of(context).pop();
                if (isFinalizar) {
                  await controller.finalizarDemanda();
                } else {
                  await controller
                      .desvincularDemanda(); // Implemente este método
                }
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
