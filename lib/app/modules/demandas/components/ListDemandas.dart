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
        physics: const BouncingScrollPhysics(),
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
    final isUsuarioBoll = demanda.logAgenteDemanda?.any(
            (element) => element.usuarioId == controller.usuario.usuarioId) ??
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
                'Status: ${(demanda.statusDemanda != null ? demanda.statusDemanda!.descricaoStatusDemanda.toUpperCase() : "NAO APROVADO")}',
              ),
            ),
          ],
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Realizada: ${DateFormat('dd/MM/yyyy HH:mm').format(demanda.dataCriacaoDemanda!)}',
            ),
            Text(
              'Despacho demanda: ${(demanda.despachoAcao != null ? demanda.despachoAcao!.toUpperCase() : "")}',
            ),
            Text('Orgao: ${demanda.orgao?.nomeAbreviadoOrgao}'),
          ],
        ),
        children: [
          _buildDetalhesOcorrencia(demanda, context, isUsuarioBoll),
        ],
        onExpansionChanged: (expanded) {
          if (expanded) {
            // Ação ao expandir, se necessário
          }
        },
      ),
    );
  }

  Widget _buildDetalhesOcorrencia(
      Demanda demanda, BuildContext context, bool isusuarioBoll) {
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
          _buildRichText('Local: ', demanda.ocorrencia?.enderecoOcorrencia),
          const Divider(),
          _buildRichText('Bairro: ', demanda.ocorrencia?.bairroOcorrencia),
          const Divider(),
          _buildRichText('Cidade: ', demanda.ocorrencia?.cidadeOcorrencia),
          const Divider(),
          _buildRichText(
            'Data da Ocorrência: ',
            DateFormat('dd/MM/yyyy HH:mm')
                .format(demanda.ocorrencia!.dataAberturaOcorrencia!),
          ),
          const Divider(),
          _buildRichText('Relato do Autor: ',
              demanda.ocorrencia?.relatoAutorRegistroOcorrencia),
          const Divider(),
          _buildRichText('Relato do Atendente: ',
              demanda.ocorrencia?.relatoAtendenteOcorrencia),
          const Divider(),
          _buildRichText('Relato do Finais: ',
              demanda.ocorrencia?.observacoesFinaisOcorrencia),
          _buildOpenMapButton(context, isFinalizado, isusuarioBoll, demanda),
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
      bool isusuarioBoll, Demanda demanda) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 8.0),
      width: MediaQuery.of(context).size.width,
      child: ElevatedButton(
        onPressed: () =>
            _handleOpenMap(context, isFinalizado, isusuarioBoll, demanda),
        child: const Text('Abrir Mapa'),
      ),
    );
  }

  void _handleOpenMap(BuildContext context, bool isFinalizado,
      bool isusuarioBoll, Demanda demanda) {
    if (isFinalizado) {
      showSnackbar("Aviso", "Demanda já finalizada");
    } else if (isusuarioBoll) {
      _openMap(demanda);
    } else {
      _showConfirmationDialog(context, demanda);
    }
  }

  void _showConfirmationDialog(BuildContext context, Demanda demanda) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Abrir Mapa'),
          content: const Text('Você deseja se vincular a essa demanda?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Não'),
            ),
            ElevatedButton(
              onPressed: () async {
                Navigator.of(context).pop();

                var resultado = await Get.find<DemandasController>()
                    .logDemandaAgente(demanda);
                if (resultado) {
                  _openMap(demanda);
                } else {
                  showSnackbar(
                      "Erro", "Você já está vinculado a outra demanda");
                }
              },
              child: const Text('Sim'),
            ),
          ],
        );
      },
    );
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
}
