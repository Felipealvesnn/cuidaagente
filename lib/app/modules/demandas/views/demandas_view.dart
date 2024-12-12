import 'package:cuidaagente/app/data/models/StatusDemanda.dart';
import 'package:cuidaagente/app/modules/demandas/components/BottomNavigationvarDemanda.dart';
import 'package:cuidaagente/app/modules/demandas/components/ListDemandas.dart';
import 'package:cuidaagente/app/modules/demandas/components/MyDrawer.dart';
import 'package:cuidaagente/app/routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:intl/intl.dart';
import '../controllers/demandas_controller.dart';

class DemandasView extends GetView<DemandasController> {
  DemandasView({super.key});

  @override
  Widget build(BuildContext context) {
    double tamanho = 100;
    return Scaffold(
      drawer: const MyDrawer(),
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(
          tamanho, // Define a altura do AppBar
        ),
        child: ClipRRect(
          borderRadius: const BorderRadius.only(
            bottomLeft: Radius.circular(1.0),
            bottomRight: Radius.circular(1.0),
          ),
          child: SizedBox(
            height: tamanho, // Ajusta a altura do AppBar
            child: AppBar(
              actions: [
                IconButton(
                  icon: const Icon(Icons.filter_list),
                  onPressed: () => showFilterModal(context),
                ),
              ],
              title: const Text(
                'Demandas',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              centerTitle: true,
              elevation: 50, // Adiciona a elevação (sombra)
              shadowColor:
                  Colors.black.withOpacity(0.5), // Personaliza a cor da sombra
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.toNamed(Routes.OCORRENCIA);
        },
        shape: RoundedRectangleBorder(
          borderRadius:
              BorderRadius.circular(28.0), // Ajuste o valor se necessário
        ),
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
        //params
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: const BottomNavigationvarDemanda(),
      body: RefreshIndicator(
        onRefresh: () async {
          await controller.Refresh();
        },
        child: Obx(() {
          if (controller.isLoadingDemandaInicial.value) {
            // Mostra o indicador de carregamento enquanto está carregando
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('Carregando demandas...'),
                  SizedBox(height: 20),
                  CircularProgressIndicator(),
                ],
              ),
            );
          }

          if (controller.demandasTela.isEmpty) {
            // Mostra a mensagem somente após o carregamento estar completo
            return Column(
              children: [
                Obx(() => (controller.FiltroPesquisado.value)
                    ? _buildSelectedFilters()
                    : const SizedBox.shrink()),
                Expanded(
                  child: ListView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    children: const [
                      Center(
                        child: Padding(
                          padding: EdgeInsets.only(top: 20.0),
                          child: Text(
                            'Nenhuma demanda encontrada.',
                            style: TextStyle(fontSize: 20),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          }

          // Exibe a lista de vistorias
          return Column(
            children: [
              Obx(() => (controller.FiltroPesquisado.value)
                  ? _buildSelectedFilters()
                  : const SizedBox.shrink()),
              Expanded(child: ListDemandas(controller: controller)),
            ],
          );
        }),
      ),
    );
  }

  Widget _buildSelectedFilters() {
    return Container(
      padding: const EdgeInsets.all(8.0),
      child: Wrap(
        spacing: 8.0,
        runSpacing: 4.0,
        children: [
          if (controller.idOcorrenciaController.text.isNotEmpty)
            Chip(
              label: Text(controller.idOcorrenciaController.text),
              deleteIcon: const Icon(Icons.clear),
              onDeleted: () => controller.clearIdDemanda(),
            ),
          // Verifica e exibe o filtro de status
          if (controller.selectestatus.value != null)
            Chip(
              label:
                  Text(controller.selectestatus.value!.descricaoStatusDemanda),
              deleteIcon: const Icon(Icons.clear),
              onDeleted: () => controller.clearSelectedStatus(),
            ),

          // Verifica e exibe o filtro de data inicial
          if (controller.dataInicioController.text.isNotEmpty)
            Chip(
              label: Text('Início: ${controller.dataInicioController.text}'),
              deleteIcon: const Icon(Icons.clear),
              onDeleted: () => controller.clearDataInicio(),
            ),

          // Verifica e exibe o filtro de data final
          if (controller.dataFimController.text.isNotEmpty)
            Chip(
              label: Text('Fim: ${controller.dataFimController.text}'),
              deleteIcon: const Icon(Icons.clear),
              onDeleted: () => controller.clearDataFim(),
            ),
        ],
      ),
    );
  }

  final modalKey = GlobalKey();

  void showFilterModal(BuildContext context) {
    Get.bottomSheet(
      backgroundColor: Colors.white,
      Padding(
        key: modalKey,
        padding: MediaQuery.of(context).viewInsets,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: GetBuilder<DemandasController>(
            builder: (controller) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Filtros',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: controller.idOcorrenciaController,
                    decoration: const InputDecoration(
                      labelText: 'Id da ocorrência',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType:
                        TextInputType.number, // Mostra o teclado numérico
                    inputFormatters: [
                      FilteringTextInputFormatter
                          .digitsOnly, // Permite apenas números
                    ],
                  ),

                  const SizedBox(height: 16),

                  // Campo para selecionar data inicial
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: controller.dataInicioController,
                          decoration: const InputDecoration(
                            labelText: 'Data Inicial',
                            border: OutlineInputBorder(),
                          ),
                          readOnly: true, // Impede edição manual
                          onTap: () async {
                            DateTime? pickedDate = await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime(2000),
                              lastDate: DateTime.now(),
                            );
                            if (pickedDate != null) {
                              controller.dataInicioController.text =
                                  DateFormat('dd/MM/yyyy').format(pickedDate);
                            }
                          },
                        ),
                      ),
                      const SizedBox(width: 16),

                      // Campo para selecionar data final
                      Expanded(
                        child: TextFormField(
                          controller: controller.dataFimController,
                          decoration: const InputDecoration(
                            labelText: 'Data Final',
                            border: OutlineInputBorder(),
                          ),
                          readOnly: true, // Impede edição manual
                          onTap: () async {
                            DateTime? pickedDate = await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime(2000),
                              lastDate: DateTime.now(),
                            );
                            if (pickedDate != null) {
                              controller.dataFimController.text =
                                  DateFormat('dd/MM/yyyy').format(pickedDate);
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Obx(
                    () => DropdownSearch<StatusDemanda>(
                      selectedItem: controller.selectestatus.value,
                      items: (String filter, dynamic infiniteScrollProps) {
                        return controller.status
                            .where((status) => status.descricaoStatusDemanda
                                .toLowerCase()
                                .contains(filter.toLowerCase()))
                            .toList(); // Retorna a lista de NaturezaSolicitacoes
                      },
                      autoValidateMode: AutovalidateMode.onUserInteraction,
                      compareFn: (StatusDemanda? a, StatusDemanda? b) =>
                          a?.statusDemandaId ==
                          b?.statusDemandaId, // Compara os itens pelo ID
                      itemAsString: (StatusDemanda? status) =>
                          status?.descricaoStatusDemanda ?? '',
                      decoratorProps: const DropDownDecoratorProps(
                        decoration: InputDecoration(
                          labelText: "status da Solicitação",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(12),
                            ),
                          ),
                        ),
                      ),
                      onChanged: (value) {
                        controller.selectestatus.value = value;
                        // controller
                        //     .atualizarTiposSolicitacoes(); // Atualiza os tipos de solicitação
                      },
                      validator: (value) =>
                          value == null ? "Selecione um status" : null,
                      popupProps: const PopupProps.dialog(
                        showSearchBox: true,
                        searchFieldProps: TextFieldProps(
                          decoration: InputDecoration(
                            labelText: 'Pesquisar',
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Botão para aplicar os filtros
                  OverflowBar(
                    spacing: 16,
                    children: [
                      TextButton(
                        onPressed: () {
                          // Lógica para resetar os filtros aqui
                          controller.reseteFiltroSolicitacoes();
                          // Fechar o modal após resetar os filtros
                          Get.back();
                        },
                        child: const Text('Resetar Filtros'),
                      ),
                      ElevatedButton(
                        onPressed: () async {
                          // Validação dos campos
                          String dataInicioText =
                              controller.dataInicioController.text.trim();
                          String dataFimText =
                              controller.dataFimController.text.trim();

                          if (dataInicioText.isEmpty &&
                              dataFimText.isEmpty &&
                              controller.idOcorrenciaController.text.isEmpty &&
                              controller.selectestatus.value == null) {
                            Get.snackbar(
                              'Erro',
                              'Preencha pelo menos um campo para aplicar o filtro.',
                            );
                            return;
                          }

                          await controller.aplicarFiltroSolicitacoes();

                          Future.delayed(const Duration(milliseconds: 500), () {
                            if (modalKey.currentContext != null) {
                              Navigator.of(modalKey.currentContext!).pop();
                            }
                          });
                          Get.back();
                        },
                        child: const Text('Aplicar Filtros'),
                      ),
                    ],
                  ),
                ],
              );
            },
          ),
        ),
      ),
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20),
        ),
      ),
    );
  }
}
