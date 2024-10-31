import 'package:cuidaagente/app/routes/app_pages.dart';
import 'package:cuidaagente/app/utils/ultil.dart';
import 'package:flutter/material.dart';
import 'package:cuidaagente/app/data/models/demandas.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class DemandasDetalhes extends StatelessWidget {
  final Demanda demanda;

  const DemandasDetalhes({
    Key? key,
    required this.demanda,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isFinalizado =
        demanda.statusDemanda?.descricaoStatusDemanda.toUpperCase() ==
            "FINALIZADO";
    final leadingIcon = isFinalizado ? Icons.check : Icons.info_outline;
    final statusText =
        demanda.statusDemanda?.descricaoStatusDemanda.toUpperCase() ??
            "NÃO APROVADO";
    final nomeUsuario = (demanda.logAlteracaoDemanda?.isNotEmpty ?? false)
        ? demanda.logAlteracaoDemanda!.last.usuario_sistema?.nome
        : null;

    final dataCriacaoText = _formatDate(demanda.dataCriacaoDemanda);
    final listTileShape = RoundedRectangleBorder(
      side: BorderSide(color: Colors.grey.withOpacity(0.5), width: 1),
    );

    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                _buildAppBar(
                  leadingIcon,
                  isFinalizado,
                  statusText,
                  dataCriacaoText,
                  nomeUsuario,
                ),
                _buildDemandasDetails(listTileShape),
              ],
            ),
          ),
          _buildOpenMapButton(context, isFinalizado),
        ],
      ),
    );
  }

  // Método para formatar a data
  String _formatDate(DateTime? date) {
    return date != null
        ? DateFormat('dd/MM/yyyy HH:mm').format(date)
        : "Data Indisponível";
  }

  // Método para construir o AppBar com status
  Widget _buildAppBar(IconData leadingIcon, bool isFinalizado,
      String statusText, String dataCriacaoText, String? nomeUsuario) {
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
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    leadingIcon,
                    color: isFinalizado ? Colors.green : Colors.red,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Status: $statusText',
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              if (nomeUsuario != null)
                Text(
                  'Finalizado por: $nomeUsuario',
                  style: const TextStyle(
                    fontSize: 14,
                  ),
                ),
              Text(textAlign: TextAlign.center ,
                  'Despacho demanda: ${demanda.despachoAcao?.toUpperCase() ?? ""}',
                  style: const TextStyle(fontSize: 14)),
              Text('Realizada: $dataCriacaoText',
                  style: const TextStyle(fontSize: 14)),
              Text(
                  'Órgão: ${demanda.orgao?.nomeAbreviadoOrgao ?? "Indisponível"}',
                  style: const TextStyle(fontSize: 14)),
            ],
          ),
        ),
      ),
    );
  }

  // Método para construir os detalhes da demanda
  Widget _buildDemandasDetails(RoundedRectangleBorder shape) {
    return SliverList(
      delegate: SliverChildListDelegate([
        _buildListTile(
            shape,
            'Local: ${demanda.ocorrencia?.enderecoOcorrencia ?? "N/A"}',
            'Bairro: ${demanda.ocorrencia?.bairroOcorrencia ?? "N/A"}'),
        _buildListTile(
            shape,
            'Cidade: ${demanda.ocorrencia?.cidadeOcorrencia ?? "N/A"}',
            'Estado: ${demanda.ocorrencia?.ufOcorrencia ?? "N/A"}'),
        _buildListTile(
            shape,
            'Data da Ocorrência: ${_formatDate(demanda.ocorrencia?.dataAberturaOcorrencia)}',
            'Horário Informado: ${demanda.ocorrencia?.horaInformadaOcorrencia ?? "N/A"}'),
        _buildListTile(shape, 'Relato do Autor',
            demanda.ocorrencia?.relatoAutorRegistroOcorrencia ?? "N/A"),
        _buildListTile(shape, 'Relato do Atendente',
            demanda.ocorrencia?.relatoAtendenteOcorrencia ?? "N/A"),
        _buildListTile(shape, 'Observações Finais',
            demanda.ocorrencia?.observacoesFinaisOcorrencia ?? "N/A"),
      ]),
    );
  }

  // Método para construir o ListTile com estilo
  Widget _buildListTile(
      RoundedRectangleBorder shape, String title, String subtitle) {
    return ListTile(
      shape: shape,
      title: Text(title),
      subtitle: Text(subtitle),
    );
  }

  // Botão para abrir o mapa com confirmação
  Widget _buildOpenMapButton(BuildContext context, bool isFinalizado) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 8.0),
      width: MediaQuery.of(context).size.width,
      child: ElevatedButton(
        onPressed: () => _handleOpenMap(context, isFinalizado),
        child: const Text('Abrir Mapa'),
      ),
    );
  }

  // Método para tratar a ação do botão Abrir Mapa
  void _handleOpenMap(BuildContext context, bool isFinalizado) {
    if (isFinalizado) {
      showSnackbar("Aviso", "Demanda já finalizada");
    } else {
      _showConfirmationDialog(context);
    }
  }

  // Método para mostrar o Snackbar de aviso

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
              onPressed: () {
                Navigator.of(context).pop();
                Get.toNamed(
                  Routes.MAPA_DEMANDA,
                  arguments: {
                    'latitude': demanda.ocorrencia?.latitude,
                    'longitude': demanda.ocorrencia?.longitude,
                    'demanda_id': demanda.demandaId,
                  },
                );
              },
              child: const Text('Sim'),
            ),
          ],
        );
      },
    );
  }
}
