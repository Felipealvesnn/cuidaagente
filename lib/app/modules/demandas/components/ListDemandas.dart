import 'package:cuidaagente/app/data/models/LogAgenteDemanda.dart';
import 'package:cuidaagente/app/data/models/demandas.dart';
import 'package:cuidaagente/app/modules/demandas/components/demandasDetalhes.dart';
import 'package:cuidaagente/app/modules/demandas/controllers/demandas_controller.dart';
import 'package:cuidaagente/app/routes/app_pages.dart';
import 'package:cuidaagente/app/utils/ultil.dart';
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
        physics: const AlwaysScrollableScrollPhysics(),
        itemCount: controller.demandasList.length + 1,
        itemBuilder: (context, index) {
          if (index == controller.demandasList.length) {
            return _buildLoadingOrEndMessage();
          }
          return _buildDemandasCard(index, context);
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

  Widget _buildDemandasCard(int index, BuildContext context) {
    var demanda = controller.demandasList[index];
    var isUsuarioBolllist = controller.demandasList.any((fsdf) =>
        fsdf.demandaId !=
                demanda.demandaId && // Verifica se não é a demanda atual
            fsdf.logAgenteDemanda!.any((element) =>
                element.usuarioId == controller.usuario.usuarioId &&
                element.ativo == true) ??
        false);

    final isUsuarioBoll = demanda.logAgenteDemanda?.any((element) =>
            element.usuarioId == controller.usuario.usuarioId &&
            element.ativo == true) ??
        false;
    return Card(
      color: isUsuarioBoll ? Colors.green[100] : Colors.white,
      elevation: 2,
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: ExpansionTile(
        shape: const Border(),
        leading: const Icon(Icons.assignment),
        title: Row(
          children: [
            Expanded(
              child: Text(
                'ID: ${demanda.ocorrenciaId}',
              ),
            ),
          ],
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Aberta: ${DateFormat('dd/MM/yyyy HH:mm').format(demanda.dataCriacaoDemanda!)}',
            ),
            Text(
              'Tipo : ${(demanda.despachoAcao != null ? demanda.despachoAcao!.toUpperCase() : "")}',
            ),
            Text('Orgao: ${demanda.orgao?.nomeAbreviadoOrgao}'),
            Text(
              'Status: ${(demanda.statusDemanda != null ? demanda.statusDemanda!.descricaoStatusDemanda.toUpperCase() : "NAO APROVADO")}',
            ),
          ],
        ),
        children: [
          _buildDetalhesOcorrencia(
              demanda, context, isUsuarioBoll, isUsuarioBolllist),
        ],
        onExpansionChanged: (expanded) {
          if (expanded) {
            // Ação ao expandir, se necessário
          }
        },
      ),
    );
  }

  Widget _buildDetalhesOcorrencia(Demanda demanda, BuildContext context,
      bool isusuarioBoll, bool isUsuarioBolllist) {
    final isFinalizado =
        demanda.statusDemanda?.descricaoStatusDemanda.toUpperCase() ==
            "FINALIZADO";
    return Padding(
      padding: const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.only(top: 8.0, bottom: 8.0),
                child: Text(
                  'Detalhes da ocorrência ',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          _buildRichText('Local: ',
              '${demanda.ocorrencia?.enderecoOcorrencia?.toUpperCase()} - ${demanda.ocorrencia?.numeroEnderecoOcorrencia}'),
          //const Divider(),
          _buildRichText(
              'Bairro: ', demanda.ocorrencia?.bairroOcorrencia?.toUpperCase()),
          // const Divider(),

          // const Divider(),
          _buildRichText(
            'Data da Ocorrência: ',
            DateFormat('dd/MM/yyyy HH:mm')
                .format(demanda.ocorrencia!.dataAberturaOcorrencia!),
          ),
          // const Divider(),
          _buildRichText('Relato do Autor: ',
              demanda.ocorrencia?.relatoAutorRegistroOcorrencia?.toUpperCase()),
          // const Divider(),
          _buildRichText('Relato do Atendente: ',
              demanda.ocorrencia?.relatoAtendenteOcorrencia?.toUpperCase()),
          // const Divider(),

          _buildOpenMapButton(
              context, isFinalizado, isusuarioBoll, demanda, isUsuarioBolllist),
        ],
      ),
    );
  }

  Widget _buildRichText(String label, String? value) {
    return RichText(
      text: TextSpan(
        children: [
          TextSpan(
            text: label,
            style: const TextStyle(
                fontWeight: FontWeight.bold, color: Colors.black),
          ),
          TextSpan(
            text: value ?? 'N/A',
            style: const TextStyle(color: Colors.black),
          ),
        ],
      ),
    );
  }

  Widget _buildOpenMapButton(BuildContext context, bool isFinalizado,
      bool isusuarioBoll, Demanda demanda, bool isUsuarioBolllist) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 8.0),
      width: MediaQuery.of(context).size.width,
      child: ElevatedButton(
        onPressed: () => _handleOpenMap(
            context, isFinalizado, isusuarioBoll, demanda, isUsuarioBolllist),
        child: isusuarioBoll
            ? const Text('Continuar Rota')
            : const Text('Iniciar Demanda'),
      ),
    );
  }

  void _handleOpenMap(BuildContext context, bool isFinalizado,
      bool isusuarioBoll, Demanda demanda, bool isUsuarioBolllist) {
    if (isUsuarioBolllist) {
      showSnackbar("info", "Você já está vinculado a outra demanda");
    } else if (isusuarioBoll) {
      _openMap(demanda);
    } else {
      _showConfirmationDialog(context, demanda, isusuarioBoll);
    }
  }

  void _showConfirmationDialog(
      BuildContext context, Demanda demanda, bool isusuarioBoll) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Iniciar Demanda'),
          content: const Text('Você deseja se vincular a essa demanda?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Não'),
            ),
            ElevatedButton(
              onPressed: () async {
                Navigator.of(context).pop();
                // if (!isusuarioBoll) {
                //   showSnackbar(
                //       "info", "Você já está vinculado a outra demanda");
                //   return;
                // }
                var resultado = await Get.find<DemandasController>()
                    .logDemandaAgente(demanda);
                if (resultado) {
                  await Get.find<DemandasController>()
                      .Refresh(MostrarLogo: false);
                  _openMap(demanda, IniciadaDemanda: true);
                } else {
                  showSnackbar(
                      "info", "Você já está vinculado a outra demanda");
                }
              },
              child: const Text('Sim'),
            ),
          ],
        );
      },
    );
  }

  void _openMap(Demanda demanda, {bool IniciadaDemanda = false}) {
    Get.toNamed(
      Routes.MAPA_DEMANDA,
      arguments: {
        'latitude': demanda.ocorrencia?.latitude,
        'longitude': demanda.ocorrencia?.longitude,
        'demanda_id': demanda.demandaId,
        'IniciadaDemanda': IniciadaDemanda,
        'logAgenteDemandaID': (demanda.logAgenteDemanda != null &&
                demanda.logAgenteDemanda!.isNotEmpty)
            ? demanda.logAgenteDemanda!
                .firstWhere(
                    (element) =>
                        element.usuarioId == controller.usuario.usuarioId &&
                        element.ativo == true,
                    orElse: () => LogAgenteDemanda())
                .id
            : null,
      },
    );
  }
}
