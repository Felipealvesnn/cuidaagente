import 'package:cuidaagente/app/routes/app_pages.dart';
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
    // Define o ícone de status principal
    final leadingIcon = (demanda.statusDemanda != null &&
            demanda.statusDemanda!.descricaoStatusDemanda.toUpperCase() ==
                "FINALIZADO")
        ? Icons.check
        : Icons.info_outline;

    // Define o nome do status em maiúsculas ou mostra "NÃO APROVADO" caso esteja nulo
    final statusText = demanda.statusDemanda != null
        ? demanda.statusDemanda!.descricaoStatusDemanda.toUpperCase()
        : "NÃO APROVADO";

    // Formata a data de criação da demanda
    final dataCriacaoText = demanda.dataCriacaoDemanda != null
        ? DateFormat('dd/MM/yyyy HH:mm').format(demanda.dataCriacaoDemanda!)
        : "Data Indisponível";

    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                // Cabeçalho com informações principais da Demanda
                SliverAppBar(
                  expandedHeight: 200.0,
                  pinned: true,
                  flexibleSpace: FlexibleSpaceBar(
                    background: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(leadingIcon,
                                  color: leadingIcon == Icons.check
                                      ? Colors.green
                                      : Colors.red),
                              const SizedBox(width: 8),
                              Text(
                                'Status: $statusText',
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Despacho demanda: ${(demanda.despachoAcao != null ? demanda.despachoAcao!.toUpperCase() : "")}',
                            style: const TextStyle(fontSize: 14),
                          ),
                          Text(
                            'Realizada: $dataCriacaoText',
                            style: const TextStyle(fontSize: 14),
                          ),
                          Text(
                            'Órgão: ${demanda.orgao?.nomeAbreviadoOrgao ?? "Indisponível"}',
                            style: const TextStyle(fontSize: 14),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                SliverList(
                  delegate: SliverChildListDelegate([
                    ListTile(
                      shape: RoundedRectangleBorder(
                        side: BorderSide(
                            color: Colors.grey.withOpacity(0.5), width: 1),
                      ),
                      title: Text(
                          'Local: ${demanda.ocorrencia?.enderecoOcorrencia ?? "N/A"}'),
                      subtitle: Text(
                          'Bairro: ${demanda.ocorrencia?.bairroOcorrencia ?? "N/A"}'),
                    ),
                    ListTile(
                      shape: RoundedRectangleBorder(
                        side: BorderSide(
                            color: Colors.grey.withOpacity(0.5), width: 1),
                      ),
                      title: Text(
                          'Cidade: ${demanda.ocorrencia?.cidadeOcorrencia ?? "N/A"}'),
                      subtitle: Text(
                          'Estado: ${demanda.ocorrencia?.ufOcorrencia ?? "N/A"}'),
                    ),
                    ListTile(
                      shape: RoundedRectangleBorder(
                        side: BorderSide(
                            color: Colors.grey.withOpacity(0.5), width: 1),
                      ),
                      title: Text(
                          'Data da Ocorrência: ${demanda.ocorrencia?.dataAberturaOcorrencia != null ? DateFormat('dd/MM/yyyy HH:mm').format(demanda.ocorrencia!.dataAberturaOcorrencia!) : "N/A"}'),
                      subtitle: Text(
                          'Horário Informado: ${demanda.ocorrencia?.horaInformadaOcorrencia ?? "N/A"}'),
                    ),
                    ListTile(
                      shape: RoundedRectangleBorder(
                        side: BorderSide(
                            color: Colors.grey.withOpacity(0.5), width: 1),
                      ),
                      title: const Text('Relato do Autor'),
                      subtitle: Text(
                          demanda.ocorrencia?.relatoAutorRegistroOcorrencia ??
                              "N/A"),
                    ),
                    ListTile(
                      shape: RoundedRectangleBorder(
                        side: BorderSide(
                            color: Colors.grey.withOpacity(0.5), width: 1),
                      ),
                      title: const Text('Relato do Atendente'),
                      subtitle: Text(
                          demanda.ocorrencia?.relatoAtendenteOcorrencia ??
                              "N/A"),
                    ),
                    ListTile(
                      shape: RoundedRectangleBorder(
                        side: BorderSide(
                            color: Colors.grey.withOpacity(0.5), width: 1),
                      ),
                      title: const Text('Observações Finais'),
                      subtitle: Text(
                          demanda.ocorrencia?.observacoesFinaisOcorrencia ??
                              "N/A"),
                    ),
                  ]),
                ),
                // Botão para abrir o mapa
              ],
            ),
          ),
          Container(
            padding:
                const EdgeInsets.symmetric(vertical: 16.0, horizontal: 8.0),
            width: MediaQuery.of(context).size.width,
            child: ElevatedButton(
              onPressed: () {
                // Navegar para a página de mapa no futuro
                Get.toNamed(
                  Routes.MAPA_DEMANDA,
                  arguments: {
                    'latitude': demanda.ocorrencia?.latitude,
                    'longitude': demanda.ocorrencia?.longitude
                  },
                );
              },
              child: const Text('Abrir Mapa'),
            ),
          ),
        ],
      ),
    );
  }
}
