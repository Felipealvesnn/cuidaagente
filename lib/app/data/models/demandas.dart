import 'package:cuidaagente/app/data/models/LogAgenteDemanda.dart';
import 'package:cuidaagente/app/data/models/LogAlteracaoDemanda.dart';
import 'package:cuidaagente/app/data/models/StatusDemanda.dart';
import 'package:cuidaagente/app/data/models/ocorrencia.dart';
import 'package:cuidaagente/app/data/models/ordao.dart';

class Demanda {
  final int? demandaId;
  final int? statusDemandaId;
  final int? acaoDemandaId;
  final int? orgaoId;
  final int? ocorrenciaId;
  final String? protocoloOcorrencia;
  final String? solicitanteOcorrenciaCodigoPessoa;
  final String? solicitanteOcorrenciaCodigoSexo;
  final String? solicitanteOcorrenciaCodigoOrientacaoSexual;
  final int? tipoOcorrenciaId;
  final int? classificacaoGravidadeId;
  final int? naturezaOcorrenciaId;
  final int? origemOcorrenciaId;
  final int? statusOcorrenciaId;
  final String? despachoAcao;
  final DateTime? dataCriacaoDemanda;
  final DateTime? dataFinalizarDemanda;
  final int? usuarioAlteracaoId;
  final Ocorrencia? ocorrencia;
  final Orgao? orgao;
  final StatusDemanda? statusDemanda;
  final List<Log_alteracao_demanda>? logAlteracaoDemanda;
  final List<LogAgenteDemanda>? logAgenteDemanda;

  Demanda({
    this.demandaId,
    this.statusDemandaId,
    this.acaoDemandaId,
    this.orgaoId,
    this.ocorrenciaId,
    this.protocoloOcorrencia,
    this.solicitanteOcorrenciaCodigoPessoa,
    this.solicitanteOcorrenciaCodigoSexo,
    this.solicitanteOcorrenciaCodigoOrientacaoSexual,
    this.tipoOcorrenciaId,
    this.classificacaoGravidadeId,
    this.naturezaOcorrenciaId,
    this.origemOcorrenciaId,
    this.statusOcorrenciaId,
    this.despachoAcao,
    this.dataCriacaoDemanda,
    this.dataFinalizarDemanda,
    this.usuarioAlteracaoId,
    this.ocorrencia,
    this.orgao,
    this.statusDemanda,
    this.logAlteracaoDemanda,
    this.logAgenteDemanda,
  });

  // Método para converter a classe em um Map
  Map<String, dynamic> toMap() {
    return {
      'demanda_id': demandaId,
      'status_demanda_id': statusDemandaId,
      'acao_demanda_id': acaoDemandaId,
      'orgao_id': orgaoId,
      'ocorrencia_id': ocorrenciaId,
      'protocolo_ocorrencia': protocoloOcorrencia,
      'solicitante_ocorrencia_codigo_pessoa': solicitanteOcorrenciaCodigoPessoa,
      'solicitante_ocorrencia_codigo_sexo': solicitanteOcorrenciaCodigoSexo,
      'solicitante_ocorrencia_codigo_orientacao_sexual': solicitanteOcorrenciaCodigoOrientacaoSexual,
      'tipo_ocorrencia_id': tipoOcorrenciaId,
      'classificacao_gravidade_id': classificacaoGravidadeId,
      'natureza_ocorrencia_id': naturezaOcorrenciaId,
      'origem_ocorrencia_id': origemOcorrenciaId,
      'status_ocorrencia_id': statusOcorrenciaId,
      'despacho_acao': despachoAcao,
      'data_criacao_demanda': dataCriacaoDemanda?.toIso8601String(),
      'data_finalizar_demanda': dataFinalizarDemanda?.toIso8601String(),
      'usuario_alteracao_id': usuarioAlteracaoId,
      'ocorrencia': ocorrencia?.toMap(),
      'orgao': orgao?.toMap(),
      'status_demanda': statusDemanda?.toMap(),
      'log_alteracao_demanda': logAlteracaoDemanda?.map((e) => e.toMap()).toList(),
      'log_agente_demanda': logAgenteDemanda?.map((e) => e.toMap()).toList(),
    };
  }

  // Método para converter um Map para uma instância de Demanda
  factory Demanda.fromMap(Map<String, dynamic> map) {
    return Demanda(
      demandaId: map['demanda_id']?.toInt(),
      statusDemandaId: map['status_demanda_id']?.toInt(),
      acaoDemandaId: map['acao_demanda_id']?.toInt(),
      orgaoId: map['orgao_id']?.toInt(),
      ocorrenciaId: map['ocorrencia_id']?.toInt(),
      protocoloOcorrencia: map['protocolo_ocorrencia'],
      solicitanteOcorrenciaCodigoPessoa: map['solicitante_ocorrencia_codigo_pessoa'],
      solicitanteOcorrenciaCodigoSexo: map['solicitante_ocorrencia_codigo_sexo'],
      solicitanteOcorrenciaCodigoOrientacaoSexual: map['solicitante_ocorrencia_codigo_orientacao_sexual'],
      tipoOcorrenciaId: map['tipo_ocorrencia_id']?.toInt(),
      classificacaoGravidadeId: map['classificacao_gravidade_id']?.toInt(),
      naturezaOcorrenciaId: map['natureza_ocorrencia_id']?.toInt(),
      origemOcorrenciaId: map['origem_ocorrencia_id']?.toInt(),
      statusOcorrenciaId: map['status_ocorrencia_id']?.toInt(),
      despachoAcao: map['despacho_acao'],
      dataCriacaoDemanda: map['data_criacao_demanda'] != null
          ? DateTime.parse(map['data_criacao_demanda'])
          : null,
      dataFinalizarDemanda: map['data_finalizar_demanda'] != null
          ? DateTime.parse(map['data_finalizar_demanda'])
          : null,
      usuarioAlteracaoId: map['usuario_alteracao_id']?.toInt(),
      ocorrencia: map['ocorrencia'] != null ? Ocorrencia.fromMap(map['ocorrencia']) : null,
      orgao: map['orgao'] != null ? Orgao.fromMap(map['orgao']) : null,
      statusDemanda: map['status_demanda'] != null ? StatusDemanda.fromMap(map['status_demanda']) : null,
      logAlteracaoDemanda: map['log_alteracao_demanda'] != null
          ? List<Log_alteracao_demanda>.from(
              map['log_alteracao_demanda'].map((x) => Log_alteracao_demanda.fromMap(x)))
          : null,
          logAgenteDemanda : map['logAgenteDemanda'] != null? List<LogAgenteDemanda>.from(
              map['logAgenteDemanda'].map((x) => LogAgenteDemanda.fromMap(x)))
          : null,
    );
  }
}
