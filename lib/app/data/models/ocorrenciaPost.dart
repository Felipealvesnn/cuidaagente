class OcorrenciaPost {
  int? ocorrencia_id;
  String? cpfUsuarioAbertura;
  DateTime? data_abertura_ocorrencia;
  String? protocolo_ocorrencia;
  int? origem_ocorrencia_id;
  int? natureza_ocorrencia_id;
  int? status_ocorrencia_id;
  int? tipo_ocorrencia_id;
  DateTime? dia_informado_ocorrencia;
  Duration? hora_informada_ocorrencia;
  String? relato_autor_registro_ocorrencia;
  String? relato_atendente_ocorrencia;
  String? observacoes_finais_ocorrencia;
  String? endereco_ocorrencia;
  String? numero_endereco_ocorrencia;
  String? complemento_endereco_ocorrencia;
  String? bairro_ocorrencia;
  String? cidade_ocorrencia;
  String? uf_ocorrencia;
  String? cep_ocorrencia;
  int? usuario_id;
  int? pessoa_id;
  int? classificacao_gravidade_id;
  double? latitude;
  double? longitude;
  DateTime? dataEvento;
  List<LogVideoMonitoramento>? log_VideoMonitoramento;

  OcorrenciaPost({
    this.ocorrencia_id,
    this.cpfUsuarioAbertura,
    this.data_abertura_ocorrencia,
    this.protocolo_ocorrencia,
    this.origem_ocorrencia_id,
    this.natureza_ocorrencia_id,
    this.status_ocorrencia_id,
    this.tipo_ocorrencia_id,
    this.dia_informado_ocorrencia,
    this.hora_informada_ocorrencia,
    this.relato_autor_registro_ocorrencia,
    this.relato_atendente_ocorrencia,
    this.observacoes_finais_ocorrencia,
    this.endereco_ocorrencia,
    this.numero_endereco_ocorrencia,
    this.complemento_endereco_ocorrencia,
    this.bairro_ocorrencia,
    this.cidade_ocorrencia,
    this.uf_ocorrencia,
    this.cep_ocorrencia,
    this.usuario_id,
    this.pessoa_id,
    this.classificacao_gravidade_id,
    this.latitude,
    this.longitude,
    this.dataEvento,
    this.log_VideoMonitoramento,
  });

  factory OcorrenciaPost.fromMap(Map<String, dynamic> map) {
    return OcorrenciaPost(
      ocorrencia_id: map['ocorrencia_id'],
      cpfUsuarioAbertura: map['cpfUsuarioAbertura'],
      data_abertura_ocorrencia: map['data_abertura_ocorrencia'] != null
          ? DateTime.parse(map['data_abertura_ocorrencia'])
          : null,
      protocolo_ocorrencia: map['protocolo_ocorrencia'],
      origem_ocorrencia_id: map['origem_ocorrencia_id'],
      natureza_ocorrencia_id: map['natureza_ocorrencia_id'],
      status_ocorrencia_id: map['status_ocorrencia_id'],
      tipo_ocorrencia_id: map['tipo_ocorrencia_id'],
      dia_informado_ocorrencia: map['dia_informado_ocorrencia'] != null
          ? DateTime.parse(map['dia_informado_ocorrencia'])
          : null,
      hora_informada_ocorrencia: map['hora_informada_ocorrencia'] != null
          ? Duration(
              hours: int.parse(map['hora_informada_ocorrencia'].split(':')[0]),
              minutes:
                  int.parse(map['hora_informada_ocorrencia'].split(':')[1]),
            )
          : null,
      relato_autor_registro_ocorrencia: map['relato_autor_registro_ocorrencia'],
      relato_atendente_ocorrencia: map['relato_atendente_ocorrencia'],
      observacoes_finais_ocorrencia: map['observacoes_finais_ocorrencia'],
      endereco_ocorrencia: map['endereco_ocorrencia'],
      numero_endereco_ocorrencia: map['numero_endereco_ocorrencia'],
      complemento_endereco_ocorrencia: map['complemento_endereco_ocorrencia'],
      bairro_ocorrencia: map['bairro_ocorrencia'],
      cidade_ocorrencia: map['cidade_ocorrencia'],
      uf_ocorrencia: map['uf_ocorrencia'],
      cep_ocorrencia: map['cep_ocorrencia'],
      usuario_id: map['usuario_id'],
      pessoa_id: map['pessoa_id'],
      classificacao_gravidade_id: map['classificacao_gravidade_id'],
      latitude: map['latitude'],
      longitude: map['longitude'],
      dataEvento:
          map['dataEvento'] != null ? DateTime.parse(map['dataEvento']) : null,
      
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'ocorrencia_id': ocorrencia_id,
      'cpfUsuarioAbertura': cpfUsuarioAbertura,
      'data_abertura_ocorrencia': data_abertura_ocorrencia?.toIso8601String(),
      'protocolo_ocorrencia': protocolo_ocorrencia,
      'origem_ocorrencia_id': origem_ocorrencia_id,
      'natureza_ocorrencia_id': natureza_ocorrencia_id,
      'status_ocorrencia_id': status_ocorrencia_id,
      'tipo_ocorrencia_id': tipo_ocorrencia_id,
      'dia_informado_ocorrencia': dia_informado_ocorrencia?.toIso8601String(),
      'hora_informada_ocorrencia': hora_informada_ocorrencia != null
          ? "${hora_informada_ocorrencia!.inHours}:${(hora_informada_ocorrencia!.inMinutes % 60).toString().padLeft(2, '0')}"
          : null,
      'relato_autor_registro_ocorrencia': relato_autor_registro_ocorrencia,
      'relato_atendente_ocorrencia': relato_atendente_ocorrencia,
      'observacoes_finais_ocorrencia': observacoes_finais_ocorrencia,
      'endereco_ocorrencia': endereco_ocorrencia,
      'numero_endereco_ocorrencia': numero_endereco_ocorrencia,
      'complemento_endereco_ocorrencia': complemento_endereco_ocorrencia,
      'bairro_ocorrencia': bairro_ocorrencia,
      'cidade_ocorrencia': cidade_ocorrencia,
      'uf_ocorrencia': uf_ocorrencia,
      'cep_ocorrencia': cep_ocorrencia,
      'usuario_id': usuario_id,
      'pessoa_id': pessoa_id,
      'classificacao_gravidade_id': classificacao_gravidade_id,
      'latitude': latitude,
      'longitude': longitude,
      'log_VideoMonitoramento': log_VideoMonitoramento != null
          ? List<dynamic>.from(
              log_VideoMonitoramento!.map((x) => x.toMap()),
            )
          : null,
    };
  }
}

class LogVideoMonitoramento {
  int? log_VideoMonitoramento_id;
  String? placa;
  DateTime? data_evento;
  DateTime? data_cadastro;
  double? latitude;
  double? longitude;
  String? codEquipamento;
  List<ImagensMonitoramento>? imagens_monitoramento;

  LogVideoMonitoramento({
    this.log_VideoMonitoramento_id,
    this.placa,
    this.data_evento,
    this.data_cadastro,
    this.latitude,
    this.longitude,
    this.codEquipamento,
    this.imagens_monitoramento,
  });

  // Método para converter um Map (como JSON) para um objeto LogVideoMonitoramento
  factory LogVideoMonitoramento.fromMap(Map<String, dynamic> map) {
    return LogVideoMonitoramento(
      log_VideoMonitoramento_id: map['log_VideoMonitoramento_id'],
      placa: map['placa'],
      data_evento: map['data_evento'] != null
          ? DateTime.parse(map['data_evento'])
          : null,
      data_cadastro: map['data_cadastro'] != null
          ? DateTime.parse(map['data_cadastro'])
          : null,
      latitude: map['latitude']?.toDouble(),
      longitude: map['longitude']?.toDouble(),
      codEquipamento: map['codEquipamento'],
      imagens_monitoramento: map['imagens_monitoramento'] != null
          ? List<ImagensMonitoramento>.from(
              map['imagens_monitoramento'].map(
                (x) => ImagensMonitoramento.fromMap(x),
              ),
            )
          : null,
    );
  }

  // Método para converter um objeto LogVideoMonitoramento para Map (para envio de JSON)
  Map<String, dynamic> toMap() {
    return {
      'log_VideoMonitoramento_id': log_VideoMonitoramento_id,
      'placa': placa,
      'data_evento': data_evento?.toIso8601String(),
      'data_cadastro': data_cadastro?.toIso8601String(),
      'latitude': latitude,
      'longitude': longitude,
      'codEquipamento': codEquipamento,
      'imagens_monitoramento': imagens_monitoramento != null
          ? List<dynamic>.from(imagens_monitoramento!.map((x) => x.toMap()))
          : null,
    };
  }
}

class ImagensMonitoramento {
  int? imagem_monitoramento_id;
  DateTime? data_evento;
  String? placa;
  String? nome_imagem;
  String? foto_base64;
  int? log_VideoMonitoramento_id;
  String? endereco_imagem;
  LogVideoMonitoramento? log_VideoMonitoramento;

  ImagensMonitoramento({
    this.imagem_monitoramento_id,
    this.data_evento,
    this.placa,
    this.nome_imagem,
    this.foto_base64,
    this.log_VideoMonitoramento_id,
    this.endereco_imagem,
    this.log_VideoMonitoramento,
  });

  // Método para converter de Map para ImagensMonitoramento
  factory ImagensMonitoramento.fromMap(Map<String, dynamic> map) {
    return ImagensMonitoramento(
      imagem_monitoramento_id: map['imagem_monitoramento_id'],
      data_evento: map['data_evento'] != null
          ? DateTime.parse(map['data_evento'])
          : null,
      placa: map['placa'],
      nome_imagem: map['nome_imagem'],
      foto_base64: map['foto_base64'],
      log_VideoMonitoramento_id: map['log_VideoMonitoramento_id'],
      endereco_imagem: map['endereco_imagem'],
      log_VideoMonitoramento: map['log_VideoMonitoramento'] != null
          ? LogVideoMonitoramento.fromMap(map['log_VideoMonitoramento'])
          : null,
    );
  }

  // Método para converter ImagensMonitoramento para Map
  Map<String, dynamic> toMap() {
    return {
      'imagem_monitoramento_id': imagem_monitoramento_id,
      'data_evento': data_evento?.toIso8601String(),
      'placa': placa,
      'nome_imagem': nome_imagem,
      'foto_base64': foto_base64,
      'log_VideoMonitoramento_id': log_VideoMonitoramento_id,
      'endereco_imagem': endereco_imagem,
      'log_VideoMonitoramento': log_VideoMonitoramento?.toMap(),
    };
  }
}
