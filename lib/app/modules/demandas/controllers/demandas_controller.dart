import 'package:cuidaagente/app/data/models/LogAgenteDemanda.dart';
import 'package:cuidaagente/app/data/models/demandas.dart';
import 'package:cuidaagente/app/data/repository/demandar_repository.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DemandasController extends GetxController {
  final DemandasRepository demandasRepository = DemandasRepository();
  final ScrollController scrollController = ScrollController();
  var isLoadingDemandaInicial = true.obs;
  var demandasList = <Demanda>[].obs;
  var hasMoreDemandas = true.obs;
  var isLoadingMore = false.obs;
  var currentPage = 1.obs;
  final int pageSize = 10;

  @override
  void onInit() async {
    super.onInit();

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
}
