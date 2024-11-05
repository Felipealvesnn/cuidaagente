import 'dart:isolate';

import 'package:cuidaagente/app/data/models/LogAgenteDemanda.dart';
import 'package:cuidaagente/app/data/models/Usuario.dart';
import 'package:cuidaagente/app/data/models/demandas.dart';
import 'package:cuidaagente/app/data/repository/demandar_repository.dart';
import 'package:cuidaagente/app/utils/getstorages.dart';
import 'package:cuidaagente/app/utils/ultil.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';

class DemandasController extends GetxController {
  final DemandasRepository demandasRepository = DemandasRepository();
  final ScrollController scrollController = ScrollController();
  var isLoadingDemandaInicial = true.obs;
  var demandasList = <Demanda>[].obs;
  var hasMoreDemandas = true.obs;
  var isLoadingMore = false.obs;
  static const String _isolateName = "LocatorIsolate";
  ReceivePort port = ReceivePort();

  var currentPage = 1.obs;
  final int pageSize = 10;
  late Usuario usuario;

  @override
  void onInit() async {
    usuario = await Storagers.boxUserLogado.read('user') as Usuario;

    super.onInit();
    await initializeBackgroundService();

    // Carrega a primeira página de demandas
    await fetchDemandas();

    // Adiciona o listener para o scrollController para detectar quando atingir o final da lista
    scrollController.addListener(() {
      if (scrollController.position.pixels >=
              scrollController.position.maxScrollExtent &&
          hasMoreDemandas.value &&
          !isLoadingMore.value) {
        loadMoreDemandas();
      }
    });
  }

  Future<void> fetchDemandas() async {
    isLoadingDemandaInicial.value = true;
    List<Demanda> demandas = await demandasRepository.getDemandas(
        pageNumber: currentPage.value, pageSize: pageSize);

    if (demandas.isEmpty) {
      hasMoreDemandas.value = false;
    } else {
      demandasList.addAll(demandas);
      currentPage.value++;
    }
    isLoadingDemandaInicial.value = false;
  }

  Future<void> loadMoreDemandas() async {
    isLoadingMore.value = true;
    List<Demanda> demandas = await demandasRepository.getDemandas(
        pageNumber: currentPage.value, pageSize: pageSize);

    if (demandas.isEmpty) {
      hasMoreDemandas.value = false;
    } else {
      demandasList.addAll(demandas);
      currentPage.value++;
    }
    isLoadingMore.value = false;
  }

  @override
  void onClose() {
    scrollController.dispose();
    super.onClose();
  }

  Future<bool> logDemandaAgente(Demanda model) async {
    // Abre um diálogo de carregamento
    Get.dialog(
      const PopScope(
        canPop: false,
        child: Center(
          child: CircularProgressIndicator(), // Indicador de carregamento
        ),
      ),
      barrierDismissible:
          false, // Impede que o usuário feche o diálogo tocando fora
    );

    try {
      Position userLocation = await Geolocator.getCurrentPosition();

      // Cria um novo log com os dados da demanda
      LogAgenteDemanda log = LogAgenteDemanda(
        usuarioId: usuario.usuarioId, // ID do usuário logado
        latitude: userLocation.latitude, // Latitude do dispositivo
        longitude: userLocation.longitude, // Longitude do dispositivo
        demandaId: model.demandaId, // ID da demanda
        dataIniciado: DateTime.now(), // Data de início do atendimento
      );

      // Envia o log para o servidor
      var resultado = await demandasRepository.sendLogAgenteDemanda(log);
      return resultado;
    } finally {
      Get.back(); // Fecha o diálogo de carregamento ao final da execução
    }
  }
}
