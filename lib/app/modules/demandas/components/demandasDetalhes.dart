import 'package:cuidaagente/app/modules/demandas/controllers/demandas_controller.dart';
import 'package:cuidaagente/app/routes/app_pages.dart';
import 'package:cuidaagente/app/utils/ultil.dart';
import 'package:flutter/material.dart';
import 'package:cuidaagente/app/data/models/demandas.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class DemandasDetalhes extends StatelessWidget {
  final Demanda demanda;

  const DemandasDetalhes({
    super.key,
    required this.demanda,
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<DemandasController>();
    final isusuarioBoll = _isUsuarioRelacionado(controller.usuario.usuarioId!);
    final isFinalizado =
        demanda.statusDemanda?.descricaoStatusDemanda.toUpperCase() ==
            "FINALIZADO";

    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                _buildAppBar(
                  leadingIcon: isFinalizado ? Icons.check : Icons.schedule,
                  isFinalizado: isFinalizado,
                  statusText: demanda.statusDemanda?.descricaoStatusDemanda
                          .toUpperCase() ??
                      "NÃO APROVADO",
                  dataCriacaoText: _formatDate(demanda.dataCriacaoDemanda),
                  nomeUsuario: _getNomeUsuarioFinalizado(),
                ),
                _buildDemandasDetails(),
              ],
            ),
          ),
          _buildOpenMapButton(context, isFinalizado, isusuarioBoll),
        ],
      ),
    );
  }

  // Verifica se o usuário está relacionado à demanda
  bool _isUsuarioRelacionado(int usuarioId) {
    return demanda.logAgenteDemanda
            ?.any((element) => element.usuarioId == usuarioId) ??
        false;
  }

  // Obtém o nome do usuário que finalizou a demanda
  String? _getNomeUsuarioFinalizado() {
    return (demanda.logAlteracaoDemanda?.isNotEmpty ?? false)
        ? demanda.logAlteracaoDemanda!.last.usuario_sistema?.nome
        : null;
  }

  // Método para formatar a data
  String _formatDate(DateTime? date) {
    return date != null
        ? DateFormat('dd/MM/yyyy HH:mm').format(date)
        : "Data Indisponível";
  }

  // Método para construir o AppBar com status
  Widget _buildAppBar({
    required IconData leadingIcon,
    required bool isFinalizado,
    required String statusText,
    required String dataCriacaoText,
    String? nomeUsuario,
  }) {
    return SliverAppBar(
      expandedHeight: 200.0,
      pinned: true,
      flexibleSpace: FlexibleSpaceBar(
        background: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _buildStatusRow(leadingIcon, isFinalizado, statusText),
              const SizedBox(height: 8),
              if (nomeUsuario != null)
                Text('Finalizado por: $nomeUsuario',
                    style: const TextStyle(fontSize: 14)),
              _buildTextRow(
                  'Despacho demanda: ${demanda.despachoAcao?.toUpperCase() ?? ""}'),
              _buildTextRow('Realizada: $dataCriacaoText'),
              _buildTextRow(
                  'Órgão: ${demanda.orgao?.nomeAbreviadoOrgao ?? "Indisponível"}'),
            ],
          ),
        ),
      ),
    );
  }

  // Método para exibir o status da demanda com ícone
  Widget _buildStatusRow(IconData icon, bool isFinalizado, String statusText) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon, color: Colors.black),
        const SizedBox(width: 8),
        Text('Status: $statusText',
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
      ],
    );
  }

  // Método para exibir linhas de texto formatadas
  Widget _buildTextRow(String text) {
    return Text(
      text,
      textAlign: TextAlign.center,
      style: const TextStyle(fontSize: 14),
    );
  }

  // Método para construir os detalhes da demanda
  Widget _buildDemandasDetails() {
    return SliverList(
      delegate: SliverChildListDelegate([
        _buildListTile(
            'Local: ${demanda.ocorrencia?.enderecoOcorrencia ?? "N/A"}',
            'Bairro: ${demanda.ocorrencia?.bairroOcorrencia ?? "N/A"}'),
        _buildListTile(
            'Cidade: ${demanda.ocorrencia?.cidadeOcorrencia ?? "N/A"}',
            'Estado: ${demanda.ocorrencia?.ufOcorrencia ?? "N/A"}'),
        _buildListTile(
            'Data da Ocorrência: ${_formatDate(demanda.ocorrencia?.dataAberturaOcorrencia)}',
            'Horário Informado: ${demanda.ocorrencia?.horaInformadaOcorrencia ?? "N/A"}'),
        _buildListTile('Relato do Autor',
            demanda.ocorrencia?.relatoAutorRegistroOcorrencia ?? "N/A"),
        _buildListTile('Relato do Atendente',
            demanda.ocorrencia?.relatoAtendenteOcorrencia ?? "N/A"),
        _buildListTile('Observações Finais',
            demanda.ocorrencia?.observacoesFinaisOcorrencia ?? "N/A"),
      ]),
    );
  }

  // Método para construir o ListTile com estilo
  Widget _buildListTile(String title, String subtitle) {
    return ListTile(
      shape: RoundedRectangleBorder(
        side: BorderSide(color: Colors.grey.withOpacity(0.5), width: 1),
      ),
      title: Text(title),
      subtitle: Text(subtitle),
    );
  }

  // Botão para abrir o mapa com confirmação
  Widget _buildOpenMapButton(
      BuildContext context, bool isFinalizado, bool isusuarioBoll) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 8.0),
      width: MediaQuery.of(context).size.width,
      child: ElevatedButton(
        onPressed: () => _handleOpenMap(context, isFinalizado, isusuarioBoll),
        child: const Text('Abrir Mapa'),
      ),
    );
  }

  // Método para tratar a ação do botão Abrir Mapa
  void _handleOpenMap(
      BuildContext context, bool isFinalizado, bool isusuarioBoll) {
    if (isFinalizado) {
      showSnackbar("Aviso", "Demanda já finalizada");
    } else if (isusuarioBoll) {
      _openMap();
    } else {
      _showConfirmationDialog(context);
    }
  }

  // Método para abrir o mapa diretamente
  void _openMap() {
    Get.toNamed(
      Routes.MAPA_DEMANDA,
      arguments: {
        'latitude': demanda.ocorrencia?.latitude,
        'longitude': demanda.ocorrencia?.longitude,
        'demanda_id': demanda.demandaId,
      },
    );
  }

  // Método para mostrar o diálogo de confirmação
  void _showConfirmationDialog(BuildContext context) {
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
                  _openMap();
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

}
