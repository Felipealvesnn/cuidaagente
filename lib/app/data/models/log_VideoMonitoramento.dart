import 'package:get/get_rx/src/rx_types/rx_types.dart';

class LogVideoMonitoramento {
  int logVideoMonitoramentoId;
  String? placa;
  DateTime dataEvento;
  DateTime dataCadastro;
  double? latitude;
  double? longitude;
  String? codEquipamento;
  int ocorrenciaId;
  String? endereco;
  RxList<ImagensMonitoramento>? imagensMonitoramento =
      <ImagensMonitoramento>[].obs; // Observável

  LogVideoMonitoramento({
    required this.logVideoMonitoramentoId,
    this.placa,
    required this.dataEvento,
    required this.dataCadastro,
    this.latitude,
    this.longitude,
    this.codEquipamento,
    required this.ocorrenciaId,
    this.endereco,
    this.imagensMonitoramento,
  }) {
    imagensMonitoramento?.value ??= [];
  }

  factory LogVideoMonitoramento.fromJson(Map<String, dynamic> json) {
    return LogVideoMonitoramento(
      logVideoMonitoramentoId: json['log_VideoMonitoramento_id'],
      placa: json['placa'],
      dataEvento: DateTime.parse(json['data_evento']),
      dataCadastro: DateTime.parse(json['data_cadastro']),
      latitude: json['latitude'],
      longitude: json['longitude'],
      codEquipamento: json['codEquipamento'],
      ocorrenciaId: json['ocorrencia_id'],
      endereco: json['endereco'],
      imagensMonitoramento: json['imagens_monitoramento'] != null
          ? RxList<ImagensMonitoramento>(
              (json['imagens_monitoramento'] as List)
                  .map((v) => ImagensMonitoramento.fromJson(v))
                  .toList(),
            )
          : <ImagensMonitoramento>[].obs,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'log_VideoMonitoramento_id': logVideoMonitoramentoId,
      'placa': placa,
      'data_evento': dataEvento.toIso8601String(),
      'data_cadastro': dataCadastro.toIso8601String(),
      'latitude': latitude,
      'longitude': longitude,
      'codEquipamento': codEquipamento,
      'ocorrencia_id': ocorrenciaId,
      'endereco': endereco,
      'imagens_monitoramento':
          imagensMonitoramento?.map((item) => item.toJson()).toList(),
    };
  }
}

class ImagensMonitoramento {
  int imagemMonitoramentoId;
  DateTime dataEvento;
  String? placa;
  String nomeImagem;
  String? fotoBase64;
  int logVideoMonitoramentoId;
  String enderecoImagem;

  ImagensMonitoramento({
    required this.imagemMonitoramentoId,
    required this.dataEvento,
    this.placa,
    required this.nomeImagem,
    this.fotoBase64,
    required this.logVideoMonitoramentoId,
    required this.enderecoImagem,
  });

  factory ImagensMonitoramento.fromJson(Map<String, dynamic> json) {
    return ImagensMonitoramento(
      imagemMonitoramentoId: json['imagem_monitoramento_id'],
      dataEvento: DateTime.parse(json['data_evento']),
      placa: json['placa'],
      nomeImagem: json['nome_imagem'],
      fotoBase64: json['foto_base64'],
      logVideoMonitoramentoId: json['log_VideoMonitoramento_id'],
      enderecoImagem: json['endereco_imagem'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'imagem_monitoramento_id': imagemMonitoramentoId,
      'data_evento': dataEvento.toIso8601String(),
      'placa': placa,
      'nome_imagem': nomeImagem,
      'foto_base64': fotoBase64,
      'log_VideoMonitoramento_id': logVideoMonitoramentoId,
      'endereco_imagem': enderecoImagem,
    };
  }
}
