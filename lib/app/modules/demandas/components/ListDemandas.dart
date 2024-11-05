import 'package:cuidaagente/app/modules/demandas/components/demandasDetalhes.dart';
import 'package:cuidaagente/app/modules/demandas/controllers/demandas_controller.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:get/get.dart';

class ListDemandas extends StatelessWidget {
  final DemandasController controller;

  const ListDemandas({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return ListView.builder(
        controller: controller.scrollController,
        physics: const BouncingScrollPhysics(),
        itemCount: controller.demandasList.length + 1,
        itemBuilder: (context, index) {
          if (index == controller.demandasList.length) {
            return _buildLoadingOrEndMessage();
          }
          return _buildDemandasCard(index);
        },
      );
    });
  }

  Widget _buildLoadingOrEndMessage() {
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

  Widget _buildDemandasCard(int index) {
    var demanda = controller.demandasList[index];
    final isUsuarioBoll = demanda.logAgenteDemanda?.any(
            (element) => element.usuarioId == controller.usuario.usuarioId) ??
        false;

    return Card(
      color: isUsuarioBoll ? Colors.green[100] : Colors.white,
      elevation: 2,
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: ListTile(
        leading: const Icon(Icons.assignment),
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
        trailing: isUsuarioBoll? const Icon(Icons.info_outline, color: Colors.red)
            : null,
        onTap: () {
          Get.to(() => DemandasDetalhes(demanda: demanda));
        },
      ),
    );
  }
}
