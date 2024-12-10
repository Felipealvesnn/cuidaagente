import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:cuidaagente/app/data/models/Usuario.dart';
import 'package:cuidaagente/app/data/models/classificacao_gravidade.dart';
import 'package:cuidaagente/app/data/models/naturezaOcorrencia.dart';
import 'package:cuidaagente/app/data/models/ocorrenciaPost.dart';
import 'package:cuidaagente/app/data/models/tipoOcorrencia.dart';
import 'package:cuidaagente/app/data/repository/ocorrencia_repository.dart';
import 'package:cuidaagente/app/routes/app_pages.dart';
import 'package:cuidaagente/app/utils/getstorages.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:image/image.dart' as img; // Importa a biblioteca 'image'
import 'package:path/path.dart' as path;

class OcorrenciaController extends GetxController {
  var selectedImages = RxList<File>([]);
  TextEditingController enderecoController = TextEditingController();
  TextEditingController numeroController = TextEditingController();
  TextEditingController relatoController = TextEditingController();
  TextEditingController Bairro = TextEditingController();
  OcorrenciaRepository ocorrenciaRepository = OcorrenciaRepository();
  TextEditingController dataController = TextEditingController();
  TextEditingController horaController = TextEditingController();
  List<Map<String, dynamic>> fotosVistoria = [];
  List<ImagensMonitoramento> imagensMonitoramento = [];

  RxList<natureza_ocorrencia> listNatureza = <natureza_ocorrencia>[].obs;
  RxList<tipo_ocorrencia> listTipoOcorrencia = <tipo_ocorrencia>[].obs;
  var selectedLocation = Rx<LatLng?>(null);
  RxList<classificacao_gravidade> listClassificacao_gravidade =
      <classificacao_gravidade>[
    classificacao_gravidade(
        classificacao_gravidade_id: 1,
        descricao_classificacao_gravidade: "BAIXA"),
    classificacao_gravidade(
        classificacao_gravidade_id: 2,
        descricao_classificacao_gravidade: "MEDIA"),
    classificacao_gravidade(
        classificacao_gravidade_id: 3,
        descricao_classificacao_gravidade: "ALTA"),
  ].obs;

  Rx<natureza_ocorrencia?> selectedNatureza = Rx<natureza_ocorrencia?>(null);
  Rx<tipo_ocorrencia?> selectedTipoOcorrencia = Rx<tipo_ocorrencia?>(null);
  Rx<classificacao_gravidade?> selectedClassificacao_gravidade =
      Rx<classificacao_gravidade?>(null);
  late GoogleMapController mapController;

  @override
  void onInit() async {
    super.onInit();
    // Carregar as naturezas de ocorrência ao inicializar o controller
    listNatureza.value = await ocorrenciaRepository.getNatureza();
  }

  Future<void> getTipoOcorrencia(int naturezaId) async {
    selectedTipoOcorrencia.value = null;
    listTipoOcorrencia.value =
        await ocorrenciaRepository.getTipoOcorrencia(naturezaId);
  }

  void selectNatureza(natureza_ocorrencia? natureza) {
    selectedNatureza.value = natureza;
    if (natureza != null) {
      getTipoOcorrencia(natureza.natureza_ocorrencia_id!);
    }
  }

  void selectTipoOcorrencia(tipo_ocorrencia? tipo) {
    selectedTipoOcorrencia.value = tipo;
    if (tipo != null && tipo.classificacao_gravidade_id != null) {
      // Seleciona automaticamente a classificação de gravidade correspondente ao tipo de ocorrência selecionado
      selectedClassificacao_gravidade.value =
          listClassificacao_gravidade.firstWhere(
        (gravidade) =>
            gravidade.classificacao_gravidade_id ==
            tipo.classificacao_gravidade_id,
        orElse: () => classificacao_gravidade(
            classificacao_gravidade_id: 1,
            descricao_classificacao_gravidade: "BAIXA"),
      );
    } else {
      selectedClassificacao_gravidade.value = null;
    }
  }

  Future<void> openMapDialog(BuildContext context) async {
    TextEditingController searchController = TextEditingController();

    await showDialog(
      context: context,
      builder: (context) {
        return PopScope(
          canPop: false,
          child: Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            elevation: 8,
            child: SizedBox(
              width: double.infinity,
              height: 600, // Aumentado para incluir o campo de busca
              child: Column(
                children: [
                  // Cabeçalho do diálogo
                  Container(
                    decoration: BoxDecoration(
                      color: Get.theme.primaryColor,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(16),
                        topRight: Radius.circular(16),
                      ),
                    ),
                    padding: const EdgeInsets.all(16.0),
                    child: const Row(
                      children: [
                        Icon(Icons.map, color: Colors.white),
                        SizedBox(width: 10),
                        Expanded(
                          child: AutoSizeText(
                            maxLines: 1,
                            'Confirme  sua Localização',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: TextField(
                      controller: searchController,
                      decoration: InputDecoration(
                        labelText: 'Buscar endereço',
                        hintText: 'Digite o nome da rua...',
                        helperText:
                            'Exemplo: "Rua ABC, Cidade", "Avenida XYZ, Bairro"',
                        prefixIcon: IconButton(
                          icon: const Icon(Icons.search),
                          onPressed: () async {
                            try {
                              // Busca o local
                              List<Location> locations =
                                  await locationFromAddress(
                                      searchController.text);

                              final targetLocation = locations.first;
                              selectedLocation.value = LatLng(
                                  targetLocation.latitude,
                                  targetLocation.longitude);

                              // Move a câmera para o local buscado
                              mapController.animateCamera(
                                CameraUpdate.newLatLng(selectedLocation.value!),
                              );
                            } catch (e) {
                              Get.snackbar(
                                "info",
                                "Endereço não encontrado.\nExemplo:\n- Rua ABC,\n- Cidade\n- Avenida XYZ,\n- Bairro",
                                duration: const Duration(seconds: 5),
                              );
                            }
                          },
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onSubmitted: (query) async {
                        // Busca o local
                        List<Location> locations =
                            await locationFromAddress(query);
                        if (locations.isNotEmpty) {
                          final targetLocation = locations.first;
                          selectedLocation.value = LatLng(
                              targetLocation.latitude,
                              targetLocation.longitude);

                          // Move a câmera para o local buscado
                          mapController.animateCamera(
                            CameraUpdate.newLatLng(selectedLocation.value!),
                          );
                        } else {
                          Get.snackbar("Erro", "Endereço não encontrado.");
                        }
                      },
                    ),
                  ),
                  Expanded(
                    child: Stack(
                      children: [
                        GoogleMap(
                          initialCameraPosition: CameraPosition(
                            target: selectedLocation.value!,
                            zoom: 16,
                          ),
                          onMapCreated: (GoogleMapController controller) {
                            mapController = controller;
                          },
                          onCameraMove: (position) {
                            selectedLocation.value = position.target;
                          },
                        ),
                        const Center(
                          child: Icon(Icons.location_pin,
                              size: 50, color: Colors.red),
                        ),
                        Positioned(
                          bottom: 20,
                          left: 20,
                          right: 20,
                          child: ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            icon: const Icon(Icons.check_circle,
                                color: Colors.white),
                            label: const Text(
                              'Confirmar Localização',
                              style:
                                  TextStyle(fontSize: 16, color: Colors.white),
                            ),
                            onPressed: () async {
                              await PreencherNomeLocalizacao(
                                selectedLocation.value!.latitude,
                                selectedLocation.value!.longitude,
                              );
                              Get.back();
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    height: 14,
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(16),
                        bottomRight: Radius.circular(16),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  // Função para obter a localização e preencher o campo de endereço
  Future<void> getLocation() async {
    // Exibe o diálogo de carregamento
    Get.dialog(
      const Center(
        child: CircularProgressIndicator(),
      ),
      barrierDismissible: false, // Evita que o usuário feche o diálogo
    );

    try {
      Position position = await Geolocator.getCurrentPosition();

      selectedLocation.value = LatLng(position.latitude, position.longitude);

      // Preenche o endereço com a localização obtida
      await PreencherNomeLocalizacao(position.latitude, position.longitude);
    } catch (e) {
      Get.snackbar("Erro", "Não foi possível obter a localização.");
    } finally {
      // Fecha o diálogo de carregamento
      if (Get.isDialogOpen ?? false) {
        Get.back();
      }
    }
  }

  Future<void> PreencherNomeLocalizacao(
      double latitude, double longitude) async {
    List<Placemark> placemarks =
        await placemarkFromCoordinates(latitude, longitude);

    if (placemarks.isNotEmpty) {
      Placemark placemark = placemarks[0];
      enderecoController.text = placemark.street ?? '';
      numeroController.text = placemark.subThoroughfare ?? '';
      Bairro.text = placemark.subLocality ?? '';
      latitude = latitude;
      longitude = longitude;
    }
  }

  @override
  void onClose() {
    // Libera os controladores de texto quando o controller for fechado
    enderecoController.dispose();
    numeroController.dispose();
    relatoController.dispose();
    super.onClose();
  }

  DateTime? parseData(String data) {
    try {
      return DateFormat("dd/MM/yy").parse(data);
    } catch (e) {
      // Lida com erro de parsing
      print("Erro ao parsear data: $e");
      return null;
    }
  }

  Duration parseDuration(String timeString) {
    List<String> parts = timeString.split(':');
    int hours = int.parse(parts[0]);
    int minutes = int.parse(parts[1]);

    return Duration(hours: hours, minutes: minutes);
  }

  Future<void> enviarOcorrencia() async {
    var usuario = await Storagers.boxUserLogado.read('user') as Usuario;

    // Verifica e realiza parsing apenas se os campos não estiverem vazios
    DateTime? dataInformada =
        dataController.text.isNotEmpty ? parseData(dataController.text) : null;

    Duration? horaInformada = horaController.text.isNotEmpty
        ? parseDuration(horaController.text)
        : null;

    for (var image in selectedImages) {
      // Lê o arquivo como bytes
      List<int> imageBytes = await image.readAsBytes();

      // Converte para base64
      String base64Image = base64Encode(imageBytes);

      // Obter o nome da foto
      String fileName = path.basename(image.path);

      // Adiciona a imagem como base64 e o nome ao JSON
      imagensMonitoramento.add(ImagensMonitoramento(
          foto_base64: base64Image, nome_imagem: "NomeIMagem"));
      print(base64Image);
    }

    // Criação do objeto Ocorrencia
    OcorrenciaPost ocorrencia = OcorrenciaPost(
      latitude: selectedLocation.value!.latitude,
      longitude: selectedLocation.value!.longitude,
      usuario_id: usuario.usuarioId,
      endereco_ocorrencia: enderecoController.text,
      numero_endereco_ocorrencia: numeroController.text,
      bairro_ocorrencia: Bairro.text,
      dia_informado_ocorrencia: dataInformada,
      hora_informada_ocorrencia: horaInformada,
      relato_atendente_ocorrencia: relatoController.text,
      classificacao_gravidade_id:
          selectedClassificacao_gravidade.value?.classificacao_gravidade_id,
      natureza_ocorrencia_id: selectedNatureza.value?.natureza_ocorrencia_id,
      tipo_ocorrencia_id: selectedTipoOcorrencia.value?.tipo_ocorrencia_id,
    );

    if (imagensMonitoramento.isNotEmpty) {
      LogVideoMonitoramento logVideoMonitoramento =
          LogVideoMonitoramento(imagens_monitoramento: imagensMonitoramento);
      print(jsonEncode(logVideoMonitoramento.toMap()));
      ocorrencia.log_VideoMonitoramento = [logVideoMonitoramento];
    }
    //ocorrencia.log_VideoMonitoramento  =[LogVideoMonitoramento()];

    Get.dialog(
      const Center(
        child: CircularProgressIndicator(),
      ),
      barrierDismissible: false, // Impede que o usuário feche o diálogo
    );
    // Enviar a ocorrência usando o repositório
    ocorrenciaRepository.postOcorrencia(ocorrencia).then((response) async {
      if (response != null) {
        Get.snackbar("Sucesso", "Ocorrência enviada com sucesso!");
        limparCampos();
        await Get.offAllNamed(Routes.HOME);
      } else {
        Get.snackbar("Erro", "Falha ao enviar a ocorrência.");
      }
    }).catchError((error) {
      Get.back();
      Get.snackbar("Erro", "Ocorreu um erro: $error");
    });
  }

  // Adicione também um método para limpar os campos após o envio, se necessário
  void limparCampos() {
    enderecoController.clear();
    numeroController.clear();
    dataController.clear();
    horaController.clear();
    relatoController.clear();
    selectedNatureza.value = null;
    selectedTipoOcorrencia.value = null;
    selectedClassificacao_gravidade.value = null;
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
}
