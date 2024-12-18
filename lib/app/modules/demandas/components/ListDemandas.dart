import 'package:cuidaagente/app/data/models/LogAgenteDemanda.dart';
import 'package:cuidaagente/app/data/models/demandas.dart';
import 'package:cuidaagente/app/data/models/log_VideoMonitoramento.dart';
import 'package:cuidaagente/app/modules/demandas/components/WidgetFotoDetalhes.dart';
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
        itemCount: controller.demandasTela.length + 1,
        itemBuilder: (context, index) {
          if (index == controller.demandasTela.length) {
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
    var demanda = controller.demandasTela[index];
    // Verifica se ele está ligado a alguma demanda e se nao é essa demanda aqui
    var isUsuarioBolllist = controller.demandasTela.any((fsdf) =>
        fsdf.demandaId !=
                demanda.demandaId && // Verifica se não é a demanda atual
            fsdf.logAgenteDemanda!.any((element) =>
                element.usuarioId == controller.usuario.usuarioId &&
                element.ativo == true) ??
        false);
    // aqui diz se a demanda é do usuario
    final isUsuarioDemandaBoll = demanda.logAgenteDemanda?.any((element) =>
            element.usuarioId == controller.usuario.usuarioId &&
            element.ativo == true) ??
        false;
    return Card(
      color: isUsuarioDemandaBoll ? Colors.green[100] : Colors.white,
      elevation: 2,
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: ExpansionTile(
        initiallyExpanded: false,
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
          Obx(() => _buildDetalhesOcorrencia(
                demanda,
                context,
                isUsuarioDemandaBoll,
                isUsuarioBolllist,
                controller.hasImages.value,
              ))
        ],
        onExpansionChanged: (value) async {
          controller.hasImages.value = false;

          if (value &&
              (demanda.ocorrencia?.logVideoMonitoramento?.first
                          .imagensMonitoramento?.isNotEmpty ==
                      true &&
                  demanda.ocorrencia?.logVideoMonitoramento?.first
                          .imagensMonitoramento?.first.fotoBase64 ==
                      null)) {
            var imagens =
                await controller.carregarimagens(demanda.ocorrenciaId!);
            if (imagens.isNotEmpty) {
              demanda
                  .ocorrencia?.logVideoMonitoramento?.first.imagensMonitoramento
                  ?.clear();
              demanda
                  .ocorrencia?.logVideoMonitoramento?.first.imagensMonitoramento
                  ?.addAll(imagens);
              controller.hasImages.value = true;
            } else {
              controller.hasImages.value = false;
            }
          }
        },
      ),
    );
  }

  Widget _buildDetalhesOcorrencia(Demanda demanda, BuildContext context,
      bool isUsuarioBoll, bool isUsuarioBolllist, bool hasImages) {
    // Variável reativa para verificar se há imagens

    // Obtém as imagens monitoramento, se existirem
    RxList<ImagensMonitoramento>? imagens = demanda
        .ocorrencia?.logVideoMonitoramento?.firstOrNull?.imagensMonitoramento;

    // Atualiza a variável reativa com base na presença de imagens
    // hasImages.value = imagens != null && imagens.isNotEmpty;

    // Verifica se a demanda está finalizada
    final isFinalizado =
        demanda.statusDemanda?.descricaoStatusDemanda.toUpperCase() ==
            "FINALIZADO";

    return Padding(
      padding: const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Center(
            child: Padding(
              padding: EdgeInsets.only(top: 8.0, bottom: 8.0),
              child: Text(
                'Detalhes da Ocorrência',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          _buildRichText('Local: ',
              '${demanda.ocorrencia?.enderecoOcorrencia?.toUpperCase()} - ${demanda.ocorrencia?.numeroEnderecoOcorrencia}'),
          _buildRichText(
              'Bairro: ', demanda.ocorrencia?.bairroOcorrencia?.toUpperCase()),
          _buildRichText(
            'Data da Ocorrência: ',
            DateFormat('dd/MM/yyyy HH:mm')
                .format(demanda.ocorrencia!.dataAberturaOcorrencia!),
          ),
          _buildRichText('Relato do Autor: ',
              demanda.ocorrencia?.relatoAutorRegistroOcorrencia?.toUpperCase()),
          _buildRichText('Relato do Atendente: ',
              demanda.ocorrencia?.relatoAtendenteOcorrencia?.toUpperCase()),
          if (demanda.logAgenteDemanda != null &&
              demanda.logAgenteDemanda!.isNotEmpty)
            _buildRichText(
              'Vinculados: ',
              demanda.logAgenteDemanda!
                  .where((element) =>
                      element.ativo ==
                      true) // Filtra os itens onde ativo é true
                  .map((element) => element.nomeUsuario) // Mapeia para os nomes
                  .join(' - '), // Junta com hífen
            ),

          // Exibe as imagens, se disponíveis
          (hasImages || imagens != null)
              ? WidgetFotoDetalhes(imagens_monitoramento: imagens!)
              : const SizedBox.shrink(),

          _buildOpenMapButton(
              context, isFinalizado, isUsuarioBoll, demanda, isUsuarioBolllist),
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
            : const Text('Visualizar Ocorrencia'),
      ),
    );
  }

  void _handleOpenMap(BuildContext context, bool isFinalizado,
      bool isusuarioBoll, Demanda demanda, bool isUsuarioBolllist) {
    if (isusuarioBoll) {
      _openMap(demanda,
          isusuarioBoll: isusuarioBoll, isUsuarioBolllist: isUsuarioBolllist, isFinalizado: isFinalizado);
    } else {
      _openMap(demanda,
          isusuarioBoll: false, isUsuarioBolllist: isUsuarioBolllist, isFinalizado: isFinalizado);
    }
  }

  void _openMap(Demanda demanda,
      {bool IniciadaDemanda = false,
      bool isusuarioBoll = false,
      bool isUsuarioBolllist = false, bool isFinalizado = false}) {
    Get.toNamed(
      Routes.MAPA_DEMANDA,
      arguments: {
        'latitude': demanda.ocorrencia?.latitude,
        'longitude': demanda.ocorrencia?.longitude,
        'demanda_id': demanda.demandaId,
        'isusuarioBoll': isusuarioBoll,
        'demanda': demanda,
        'isFinalizado': isFinalizado,
        'isUsuarioBolllist': isUsuarioBolllist,
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
