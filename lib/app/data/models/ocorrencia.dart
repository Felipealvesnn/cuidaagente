import 'dart:convert';

import 'package:cuidaagente/app/data/models/log_VideoMonitoramento.dart';

class Ocorrencia {
  int? ocorrenciaId;
  String? cpfUsuarioAbertura;
  DateTime? dataAberturaOcorrencia;
  String? protocoloOcorrencia;
  int? origemOcorrenciaId;
  int? naturezaOcorrenciaId;
  int? statusOcorrenciaId;
  int? tipoOcorrenciaId;
  DateTime? diaInformadoOcorrencia;
  String? horaInformadaOcorrencia;
  String? relatoAutorRegistroOcorrencia;
  String? relatoAtendenteOcorrencia;
  String? observacoesFinaisOcorrencia;
  String? enderecoOcorrencia;
  String? numeroEnderecoOcorrencia;
  String? complementoEnderecoOcorrencia;
  String? bairroOcorrencia;
  String? cidadeOcorrencia;
  String? ufOcorrencia;
  String? cepOcorrencia;
  int? usuarioId;
  int? pessoaId;
  int? classificacaoGravidadeId;
  double? latitude;
  double? longitude;
  bool? visualizado;
  String? TipoOcorrencia;
  List<LogVideoMonitoramento>? logVideoMonitoramento;

  Ocorrencia({
    this.ocorrenciaId,
    this.cpfUsuarioAbertura,
    this.dataAberturaOcorrencia,
    this.protocoloOcorrencia,
    this.origemOcorrenciaId,
    this.naturezaOcorrenciaId,
    this.statusOcorrenciaId,
    this.tipoOcorrenciaId,
    this.diaInformadoOcorrencia,
    this.horaInformadaOcorrencia,
    this.relatoAutorRegistroOcorrencia,
    this.relatoAtendenteOcorrencia,
    this.observacoesFinaisOcorrencia,
    this.enderecoOcorrencia,
    this.numeroEnderecoOcorrencia,
    this.complementoEnderecoOcorrencia,
    this.bairroOcorrencia,
    this.cidadeOcorrencia,
    this.ufOcorrencia,
    this.cepOcorrencia,
    this.usuarioId,
    this.pessoaId,
    this.classificacaoGravidadeId,
    this.latitude,
    this.longitude,
    this.visualizado,
    this.logVideoMonitoramento,
    this.TipoOcorrencia,
  });

  // Converter para Map
  Map<String, dynamic> toMap() {
    return {
      'ocorrenciaId': ocorrenciaId,
      'cpfUsuarioAbertura': cpfUsuarioAbertura,
      'dataAberturaOcorrencia': dataAberturaOcorrencia?.toIso8601String(),
      'protocoloOcorrencia': protocoloOcorrencia,
      'origemOcorrenciaId': origemOcorrenciaId,
      'naturezaOcorrenciaId': naturezaOcorrenciaId,
      'statusOcorrenciaId': statusOcorrenciaId,
      'tipoOcorrenciaId': tipoOcorrenciaId,
      'diaInformadoOcorrencia': diaInformadoOcorrencia?.toIso8601String(),
      'horaInformadaOcorrencia': horaInformadaOcorrencia,
      'relatoAutorRegistroOcorrencia': relatoAutorRegistroOcorrencia,
      'relatoAtendenteOcorrencia': relatoAtendenteOcorrencia,
      'observacoesFinaisOcorrencia': observacoesFinaisOcorrencia,
      'enderecoOcorrencia': enderecoOcorrencia,
      'numeroEnderecoOcorrencia': numeroEnderecoOcorrencia,
      'complementoEnderecoOcorrencia': complementoEnderecoOcorrencia,
      'bairroOcorrencia': bairroOcorrencia,
      'cidadeOcorrencia': cidadeOcorrencia,
      'ufOcorrencia': ufOcorrencia,
      'cepOcorrencia': cepOcorrencia,
      'usuarioId': usuarioId,
      'pessoaId': pessoaId,
      'classificacaoGravidadeId': classificacaoGravidadeId,
      'latitude': latitude,
      'longitude': longitude,
      'visualizado': visualizado,
    };
  }

  // Converter de Map
  factory Ocorrencia.fromMap(Map<String, dynamic> map) {
    return Ocorrencia(
      ocorrenciaId: map['ocorrencia_id']?.toInt(),
      cpfUsuarioAbertura: map['cpfUsuarioAbertura'],
      dataAberturaOcorrencia: map['data_abertura_ocorrencia'] != null
          ? DateTime.parse(map['data_abertura_ocorrencia'])
          : null,
      TipoOcorrencia: map['tipo_ocorrencia']['descricao_tipo_ocorrencia'],
      protocoloOcorrencia: map['protocolo_ocorrencia'],
      origemOcorrenciaId: map['origem_ocorrencia_id']?.toInt(),
      naturezaOcorrenciaId: map['natureza_ocorrencia_id']?.toInt(),
      statusOcorrenciaId: map['status_ocorrencia_id']?.toInt(),
      tipoOcorrenciaId: map['tipo_ocorrencia_id']?.toInt(),
      diaInformadoOcorrencia: map['dia_informado_ocorrencia'] != null
          ? DateTime.parse(map['dia_informado_ocorrencia'])
          : null,
      horaInformadaOcorrencia: map['hora_informada_ocorrencia'],
      relatoAutorRegistroOcorrencia: map['relato_autor_registro_ocorrencia'],
      relatoAtendenteOcorrencia: map['relato_atendente_ocorrencia'],
      observacoesFinaisOcorrencia: map['observacoes_finais_ocorrencia'],
      enderecoOcorrencia: map['endereco_ocorrencia'],
      numeroEnderecoOcorrencia: map['numero_endereco_ocorrencia'],
      complementoEnderecoOcorrencia: map['complemento_endereco_ocorrencia'],
      bairroOcorrencia: map['bairro_ocorrencia'],
      cidadeOcorrencia: map['cidade_ocorrencia'],
      ufOcorrencia: map['uf_ocorrencia'],
      cepOcorrencia: map['cep_ocorrencia'],
      usuarioId: map['usuario_id']?.toInt(),
      pessoaId: map['pessoa_id']?.toInt(),
      classificacaoGravidadeId: map['classificacao_gravidade_id']?.toInt(),
      latitude: map['latitude']?.toDouble(),
      longitude: map['longitude']?.toDouble(),
      visualizado: map['Vizualizado'],
      logVideoMonitoramento: map['log_VideoMonitoramento'] != null
          ? List<LogVideoMonitoramento>.from(map['log_VideoMonitoramento']
              ?.map((x) => LogVideoMonitoramento.fromJson(x)))
          : null,
    );
  }

  // Serializar para JSON
  String toJson() => json.encode(toMap());

  // Deserializar de JSON
  factory Ocorrencia.fromJson(String source) =>
      Ocorrencia.fromMap(json.decode(source));
}
