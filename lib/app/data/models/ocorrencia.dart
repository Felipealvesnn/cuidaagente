import 'dart:convert';

class Ocorrencia {
  final int? ocorrenciaId;
  final String? cpfUsuarioAbertura;
  final DateTime? dataAberturaOcorrencia;
  final String? protocoloOcorrencia;
  final int? origemOcorrenciaId;
  final int? naturezaOcorrenciaId;
  final int? statusOcorrenciaId;
  final int? tipoOcorrenciaId;
  final DateTime? diaInformadoOcorrencia;
  final String? horaInformadaOcorrencia;
  final String? relatoAutorRegistroOcorrencia;
  final String? relatoAtendenteOcorrencia;
  final String? observacoesFinaisOcorrencia;
  final String? enderecoOcorrencia;
  final String? numeroEnderecoOcorrencia;
  final String? complementoEnderecoOcorrencia;
  final String? bairroOcorrencia;
  final String? cidadeOcorrencia;
  final String? ufOcorrencia;
  final String? cepOcorrencia;
  final int? usuarioId;
  final int? pessoaId;
  final int? classificacaoGravidadeId;
  final double? latitude;
  final double? longitude;
  final bool? visualizado;

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
      ocorrenciaId: map['ocorrenciaId']?.toInt(),
      cpfUsuarioAbertura: map['cpfUsuarioAbertura'],
      dataAberturaOcorrencia: map['data_abertura_ocorrencia'] != null
          ? DateTime.parse(map['data_abertura_ocorrencia'])
          : null,
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
    );
  }

  // Serializar para JSON
  String toJson() => json.encode(toMap());

  // Deserializar de JSON
  factory Ocorrencia.fromJson(String source) =>
      Ocorrencia.fromMap(json.decode(source));
}
