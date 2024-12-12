import 'dart:isolate';

import 'package:cuidaagente/app/data/models/LogAgenteDemanda.dart';
import 'package:cuidaagente/app/data/models/StatusDemanda.dart';
import 'package:cuidaagente/app/data/models/Usuario.dart';
import 'package:cuidaagente/app/data/models/demandas.dart';
import 'package:cuidaagente/app/data/models/log_VideoMonitoramento.dart';
import 'package:cuidaagente/app/data/models/ocorrencia.dart';
import 'package:cuidaagente/app/data/repository/demandar_repository.dart';
import 'package:cuidaagente/app/routes/app_pages.dart';
import 'package:cuidaagente/app/utils/getstorages.dart';
import 'package:cuidaagente/app/utils/ultil.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class DemandasController extends GetxController {
  final DemandasRepository demandasRepository = DemandasRepository();
  final ScrollController scrollController = ScrollController();
  TextEditingController dataInicioController = TextEditingController();
  TextEditingController dataFimController = TextEditingController();
  TextEditingController idOcorrenciaController = TextEditingController();

  var selectestatus = Rxn<StatusDemanda>();
  var status = <StatusDemanda>[].obs;
  var FiltroPesquisado = false.obs; // Estado de carregamento
  var isLoadingDemandaInicial = true.obs;
  var demandasList = <Demanda>[];
  var demandasTela = <Demanda>[].obs;
  var hasMoreDemandas = true.obs;
  var isLoadingMore = false.obs;
  final hasImages = false.obs;

  ReceivePort port = ReceivePort();

  var currentPage = 1.obs;
  final int pageSize = 10;
  late Usuario usuario;

  @override
  void onInit() async {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      bool permissionGranted =
          await LocationService.checkAndRequestPermission();
      await requestLocationPermissions();
    });

    usuario = await Storagers.boxUserLogado.read('user') as Usuario;

    super.onInit();
    await initializeBackgroundService();

    demandasRepository.getStatusDemandas().then((value) {
      status.assignAll(value);
    });

    // Carrega a primeira página de demandas
    await fetchDemandas();
    // AdicionscrollControllera o listener para o scrollController para detectar quando atingir o final da lista
    scrollController.addListener(() {
      if (scrollController.position.pixels >=
              scrollController.position.maxScrollExtent &&
          hasMoreDemandas.value &&
          !isLoadingMore.value) {
        loadMoreDemandas();
      }
    });
  }

  Future<List<ImagensMonitoramento>> carregarimagens(int ocorrenciaId) async {
    List<ImagensMonitoramento> imagens =
        await demandasRepository.getImagens(ocorrenciaId);
    return imagens;
  }

  // Limpa os filtros

  void clearIdDemanda() async {
    idOcorrenciaController.clear();
    await aplicarFiltroSolicitacoes();
  }

  void clearSelectedStatus() async {
    selectestatus.value = null;
    await aplicarFiltroSolicitacoes();
  }

  void clearDataInicio() async {
    dataInicioController.clear();
    await aplicarFiltroSolicitacoes();
  }

  void clearDataFim() async {
    dataFimController.clear();
    await aplicarFiltroSolicitacoes();
  }

  bool hasFiltersApplied() {
    return selectestatus.value != null ||
        dataInicioController.text.isNotEmpty ||
        dataFimController.text.isNotEmpty ||
        idOcorrenciaController.text.isNotEmpty;
  }

  Future<void> aplicarFiltroSolicitacoes() async {
    // Define uma chave GlobalKey para o diálogo
    final dialogKey = GlobalKey();

    // Exibe o diálogo de carregamento com o Navigator
    showDialog(
      context: Get.context!,
      barrierDismissible: false, // Impede fechamento ao clicar fora
      builder: (context) {
        return PopScope(
          canPop: false, // Impede o fechamento com botão back
          child: Center(
            key: dialogKey,
            child: const CircularProgressIndicator(),
          ),
        );
      },
    );

    try {
      // Realiza as operações do filtro
      String dataInicioText = dataInicioController.text.trim();
      String dataFimText = dataFimController.text.trim();
      List<int> parametros =
          (await Storagers.boxUserLogado.read('boxOrgaoIds') as List<dynamic>)
              .cast<int>();

      final filtro = {
        "dataInicio": dataInicioText.isNotEmpty
            ? DateFormat('dd/MM/yyyy').parse(dataInicioText).toIso8601String()
            : null,
        "dataFim": dataFimText.isNotEmpty
            ? DateFormat('dd/MM/yyyy').parse(dataFimText).toIso8601String()
            : null,
        "statusId": selectestatus.value?.statusDemandaId,
        "Ocorrencia_id": idOcorrenciaController.text.isNotEmpty
            ? int.parse(idOcorrenciaController.text)
            : null,
        "orgaoIds": parametros,
      };
      if (hasFiltersApplied()) {
        var solicitacoesFiltro =
            await demandasRepository.getDemandasFiltradas(filtro);

        FiltroPesquisado.value = true;
        demandasTela.assignAll(solicitacoesFiltro);
        hasMoreDemandas.value = false;
      } else {
        reseteFiltroSolicitacoes();
      }
    } catch (e) {
      // Exibe mensagem de erro
      Get.snackbar(
        "Erro",
        "Não foi possível aplicar o filtro: ${e.toString()}",
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      // Fecha especificamente o diálogo associado
      Future.delayed(const Duration(seconds: 1), () {
        if (dialogKey.currentContext != null) {
          Navigator.of(dialogKey.currentContext!).pop();
        }
      });
    }
  }

  void reseteFiltroSolicitacoes() {
    dataInicioController.clear();
    dataFimController.clear();
    idOcorrenciaController.clear();
    selectestatus.value = null;

    demandasTela.assignAll(demandasList);
    hasMoreDemandas.value = true;
    FiltroPesquisado.value = false;
  }

  Future<void> fetchDemandas({bool MostrarLogo = true}) async {
    isLoadingDemandaInicial.value = true;
    List<Demanda> demandas = await demandasRepository.getDemandas(
        pageNumber: currentPage.value, pageSize: pageSize);

    if (demandas.isEmpty) {
      hasMoreDemandas.value = false;
    } else {
      demandasList.addAll(demandas);
      demandasTela.addAll(demandasList);

      // Filtra as demandas em que o usuário já está vinculado
      List<Demanda> filteredDemandas = demandasList.where((demanda) {
        return demanda.logAgenteDemanda?.any(
              (element) =>
                  element.usuarioId == usuario.usuarioId &&
                  element.ativo == true,
            ) ??
            false;
      }).toList();

      // Verifica se o usuário já está vinculado a alguma demanda
      if (filteredDemandas.isNotEmpty && MostrarLogo) {
        // Exibe o diálogo para o usuário
        bool? result = await Get.dialog<bool>(
          AlertDialog(
            title: const Text('Demanda em andamento'),
            content: const Text(
                'Você já está seguindo uma ocorrência, deseja voltar ao mapa?'),
            actions: [
              TextButton(
                onPressed: () {
                  Get.back(result: false);
                },
                child: const Text('Não'),
              ),
              ElevatedButton(
                onPressed: () {
                  Get.back(result: true);
                },
                child: const Text('Sim'),
              ),
            ],
          ),
        );

        if (result == true) {
          // Usuário optou por voltar ao mapa
          _openMap(filteredDemandas.first);
        }
      }

      currentPage.value++;
    }
    isLoadingDemandaInicial.value = false;
  }

  Future<void> Refresh({bool MostrarLogo = true}) async {
    currentPage.value = 1;
    hasMoreDemandas.value = true;
    isLoadingDemandaInicial.value = true;
    demandasList.clear();
    demandasTela.clear();
    await fetchDemandas(MostrarLogo: MostrarLogo);
    reseteFiltroSolicitacoes();
  }

  void _openMap(Demanda demanda) {
    Get.toNamed(
      Routes.MAPA_DEMANDA,
      arguments: {
        'latitude': demanda.ocorrencia?.latitude,
        'longitude': demanda.ocorrencia?.longitude,
        'demanda_id': demanda.demandaId,
      },
    );
  }

  Future<void> loadMoreDemandas() async {
    isLoadingMore.value = true;
    List<Demanda> demandas = await demandasRepository.getDemandas(
        pageNumber: currentPage.value, pageSize: pageSize);

    if (demandas.isEmpty) {
      hasMoreDemandas.value = false;
    } else {
      demandasList.addAll(demandas);
      demandasTela.addAll(demandasList);
      currentPage.value++;
    }
    isLoadingMore.value = false;
  }

  @override
  void onClose() {
    scrollController.dispose();
    super.onClose();
  }

  Future<LogAgenteDemanda> logDemandaAgente(Demanda model) async {
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
        ativo: true, // Indica que o atendimento está ativo
      );

      // Envia o log para o servidor
      var resultado = await demandasRepository.sendLogAgenteDemanda(log);
      return resultado;
    } finally {
      Get.back(); // Fecha o diálogo de carregamento ao final da execução
    }
  }
}
