import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:cuidaagente/app/data/models/LogAgenteDemanda.dart';
import 'package:cuidaagente/app/data/models/Usuario.dart';
import 'package:cuidaagente/app/data/models/adicionarPontos.dart';
import 'package:cuidaagente/app/data/models/ocorrenciaPost.dart';
import 'package:cuidaagente/app/data/repository/demandar_repository.dart';
import 'package:cuidaagente/app/modules/demandas/controllers/demandas_controller.dart';
import 'package:cuidaagente/app/routes/app_pages.dart';
import 'package:cuidaagente/app/utils/getstorages.dart';
import 'package:cuidaagente/app/utils/ultil.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:image/image.dart' as img; // Importa a biblioteca 'image'
import 'package:path/path.dart' as path;
import 'package:image_picker/image_picker.dart';

final DemandasRepository demandasRepository = DemandasRepository();

class MapaDemandaController extends GetxController {
  TextEditingController motivoController = TextEditingController();
  late double destinationLatitude;
  late double destinationLongitude;
  late int demandaId;
  late int logAgenteDemandaID;
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
  bool ValidarDistanciaBool = false;
  var selectedImages = RxList<File>([]);
  List<ImagensMonitoramento> imagensMonitoramento = [];

  @override
  void onInit() async {
    super.onInit();
    usuario = Storagers.boxUserLogado.read('user');

    // Recebe latitude e longitude dos argumentos
    destinationLatitude = Get.arguments['latitude'] ?? -3.7327;
    destinationLongitude = Get.arguments['longitude'] ?? -38.5267;
    destination = LatLng(destinationLatitude, destinationLongitude);
    demandaId = Get.arguments['demanda_id'];
    logAgenteDemandaID = Get.arguments['logAgenteDemandaID'] ?? 0;
    IniciadaDemanda = Get.arguments['IniciadaDemanda'] ?? false;

    polylinePoints = PolylinePoints();
    await getUserLocation();
    await createRoute();
    //await logDemandaAgente();

    // Inicia o monitoramento da posição
    // positionStream =
    //     Geolocator.getPositionStream().listen((Position position) async {
    //   LatLng newPosition = LatLng(position.latitude, position.longitude);

    //   // Calcula a distância entre a última posição e a nova posição
    //   double distance = Geolocator.distanceBetween(
    //     userLocation.value.latitude,
    //     userLocation.value.longitude,
    //     newPosition.latitude,
    //     newPosition.longitude,
    //   );
    //   // Atualiza somente se a distância for maior que um certo limite (ex: 5 metros)
    //   if (distance > 10) {
    //     userLocation.value = newPosition;
    //     await updateRoute();
    //     await moveCameraToCurrentPosition();
    //     //await enviarPontosRota();
    //   }
    // });
  }

  Future<void> pickImage(ImageSource source) async {
    if (selectedImages.length >= 5) {
      // Adicione uma lógica para mostrar uma mensagem ou alerta de limite de imagens
      Get.snackbar('Limite atingido', 'Você só pode adicionar até 3 imagens.');
      return;
    }

    final pickedFile = await ImagePicker().pickImage(source: source);
    if (pickedFile != null) {
      // Obter o nome da foto
      String fileName = path.basename(pickedFile.path);

      // Carregar a imagem como um Uint8List
      File imageFile = File(pickedFile.path);
      List<int> imageBytes = await imageFile.readAsBytes();

      // Converter para Uint8List
      Uint8List uint8List = Uint8List.fromList(imageBytes);

      // Decodificar a imagem
      img.Image originalImage = img.decodeImage(uint8List)!;

      // Definir a resolução mínima aceitável
      const int minResolutionWidth =
          1280; // Exemplo: resolução mínima de 1280 pixels de largura
      const int minResolutionHeight =
          720; // Exemplo: resolução mínima de 720 pixels de altura

      // Verificar se a imagem tem qualidade suficiente para ser redimensionada
      if (originalImage.width < minResolutionWidth ||
          originalImage.height < minResolutionHeight) {
        // Caso a imagem já tenha uma qualidade baixa, não vamos redimensionar
        Get.snackbar('Imagem de baixa qualidade',
            'A imagem selecionada já está com qualidade baixa e não será redimensionada.');
        selectedImages
            .add(imageFile); // Adiciona a imagem original sem redimensionar
        return;
      }

      // Dimensão alvo para redimensionar a largura
      const int targetWidth = 800;

      // Calcular a nova altura mantendo a proporção da imagem original
      double aspectRatio = originalImage.height / originalImage.width;
      int newHeight = (targetWidth * aspectRatio).toInt();

      // Redimensionar a imagem para a nova largura, mantendo a proporção
      img.Image resizedImage =
          img.copyResize(originalImage, width: targetWidth, height: newHeight);

      // Codificar a imagem redimensionada como JPEG com qualidade ajustada (reduzindo o tamanho do arquivo)
      List<int> resizedBytes = img.encodeJpg(resizedImage, quality: 85);

      // Salvar a imagem redimensionada em um novo arquivo temporário
      File resizedFile = File(pickedFile.path)..writeAsBytesSync(resizedBytes);

      // Adiciona o arquivo redimensionado à lista de imagens selecionadas
      selectedImages.add(resizedFile);

      print('Nome da foto: $fileName'); // Exibe o nome da foto
    }
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

  Future<bool> ValidarDistancia() async {
    await getUserLocation();
    double distance = Geolocator.distanceBetween(
      userLocation.value.latitude,
      userLocation.value.longitude,
      destinationLatitude,
      destinationLongitude,
    );
    if (distance < 50) {
      ValidarDistanciaBool = true;
      return ValidarDistanciaBool;
    } else {
      Get.snackbar(
        'Info',
        'Você precisa estar próximo ao local da demanda para finalizar.',
        snackPosition: SnackPosition.BOTTOM,
      );
      ValidarDistanciaBool = false;
      return ValidarDistanciaBool;
    }
  }

  var Finalizado = true;
  Future<void> finalizarDemanda() async {
    // Exibe o diálogo de carregamento para bloquear a tela

    try {
      if (ValidarDistanciaBool) {
        Get.dialog(
          const Center(
            child: CircularProgressIndicator(),
          ),
          barrierDismissible: false, // Impede que o usuário feche o diálogo
        );

        for (var image in selectedImages) {
          // Lê o arquivo como bytes
          List<int> imageBytes = await image.readAsBytes();

          // Converte para base64
          String base64Image = base64Encode(imageBytes);

          // Obter o nome da foto
          // String fileName = path.basename(image.path);

          // Adiciona a imagem como base64 e o nome ao JSON
          imagensMonitoramento.add(ImagensMonitoramento(
              foto_base64: base64Image, nome_imagem: "NomeIMagem"));
        }

        // Chama o método de finalização da demanda
        await demandasRepository.finalizarDemanda(demandaId,
            motivoController.text, usuario.usuarioId!, imagensMonitoramento);
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
        await Get.offAllNamed(Routes.HOME);
      }
    }
  }

  Future<void> desvincularDemanda() async {
    // Exibe o diálogo de carregamento para bloquear a tela

    try {
      Get.dialog(
        const Center(
          child: CircularProgressIndicator(),
        ),
        barrierDismissible: false, // Impede que o usuário feche o diálogo
      );

      // Chama o método de finalização da demanda
      await demandasRepository.desvincularDemanda(
          logAgenteDemandaID, motivoController.text);
      Finalizado = true;

      // Exibe o Snackbar de confirmação
      Get.snackbar(
        'Demanda desvinculada',
        'A demanda foi desvinculada com sucesso.',
        snackPosition: SnackPosition.BOTTOM,
      );

      // Redireciona para a rota DEMANDAS após finalizar
      //await Get.offAllNamed(Routes.DEMANDAS);
    } catch (e) {
      print(e);
    } finally {
      if (Finalizado) {
        Get.snackbar(
          'Demanda desvinculada',
          'A demanda foi desvinculada com sucesso.',
          snackPosition: SnackPosition.BOTTOM,
        );

        await Get.offAllNamed(Routes.HOME);
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
