import 'package:cuidaagente/app/data/models/demandas.dart';
import 'package:cuidaagente/app/data/repository/demandar_repository.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DemandasController extends GetxController {
  DemandasRepository demandasRepository = DemandasRepository();
  final ScrollController scrollController = ScrollController();
  var isLoadingDemandaInicial = true.obs;
  var demandasList = <Demanda>[].obs;
  var hasMoreDemandas = true.obs;
  var isLoadingMore = false.obs;

  final count = 0.obs;
  @override
  void onInit() async {
    demandasList.value = await demandasRepository.getDemandas();
    isLoadingDemandaInicial.value = false;
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  void increment() => count.value++;
}
