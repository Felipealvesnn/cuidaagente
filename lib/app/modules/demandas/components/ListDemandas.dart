import 'package:cuidaagente/app/modules/demandas/controllers/demandas_controller.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:get/get.dart';
// Importa a tela de detalhes

class ListDemandas extends StatelessWidget {
  final DemandasController controller;

  const ListDemandas({Key? key, required this.controller}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return ListView.builder(
        controller: controller.scrollController, // Usa o ScrollController
        physics: const BouncingScrollPhysics(),
        itemCount: controller.demandasList.length +
            1, // Adiciona 1 para o item de carregamento
        itemBuilder: (context, index) {
          if (index == controller.demandasList.length) {
            // Se chegou ao final da lista, mostra o item de carregamento ou mensagem de fim
            return Obx(() {
              if (controller.isLoadingMore.value) {
                return const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Center(child: CircularProgressIndicator()),
                );
              } else if (!controller.hasMoreDemandas.value) {
                return const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Center(child: Text('Não tem mais demandas')),
                );
              } else {
                return const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Center(child: Text('Carregar mais...')),
                );
              }
            });
          }

          // Escolhe o ícone com base no tipo do veículo
          IconData leadingIcon;
          leadingIcon = Icons.assignment; // Ícone para moto/motoneta

          var demanda = controller.demandasList[index];
          return Card(
            elevation: 3,
            margin: const EdgeInsets.all(8),
            child: ListTile(
              leading: Icon(leadingIcon), // Usa o ícone correto
              title: Text(
                  'Status: ${(demanda.statusDemanda != null ? demanda.statusDemanda!.descricaoStatusDemanda.toUpperCase() : "NAO APROVADO")}'),

              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                      'Despacho demanda: ${(demanda.despachoAcao != null ? demanda.despachoAcao!.toUpperCase() : "")}'),
                  Text(
                      'Realizada: ${DateFormat('dd/MM/yyyy HH:mm').format(demanda.dataCriacaoDemanda!)}'),
                  Text('Orgao: ${demanda.orgao?.nomeAbreviadoOrgao}'),
                ],
              ),
              trailing: (demanda.statusDemanda != null &&
                      demanda.statusDemanda!.descricaoStatusDemanda
                              .toUpperCase() ==
                          "FINALIZADO")
                  ? const Icon(Icons.check, color: Colors.green)
                  : const Icon(Icons.info_outline, color: Colors.red),

              onTap: () {
                // Navega para a página de detalhes da vistoria ao clicar
                // Get.to(() => VistoriaDetalhesView(vistoria: vistoria));
              },
            ),
          );
        },
      );
    });
  }
}
