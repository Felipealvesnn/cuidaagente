// ignore: file_names, camel_case_types
import 'package:cuidaagente/app/data/models/Usuario.dart';

class Log_alteracao_demanda {
  int? Log_alteracao_Demanda_Id;
  int? demanda_id;
  int? status_demanda_id;
  int? acao_demanda_id;
  int? orgao_id;
  double? ocorrencia_id;
  String? protocolo_ocorrencia;
  int? solicitante_ocorrencia_codigo_pessoa;
  int? solicitante_ocorrencia_codigo_sexo;
  int? solicitante_ocorrencia_codigo_orientacao_sexual;
  int? tipo_ocorrencia_id;
  int? classificacao_gravidade_id;
  int? natureza_ocorrencia_id;
  int? origem_ocorrencia_id;
  int? status_ocorrencia_id;
  String? acao_realizada;
  DateTime? data_alteracao;
  String? hora_alteracao;
  int? usuario_alteracao_id;
  Usuario? usuario_sistema;

  // Construtor com todos os parâmetros opcionais
  Log_alteracao_demanda({
    this.Log_alteracao_Demanda_Id,
    this.demanda_id,
    this.status_demanda_id,
    this.acao_demanda_id,
    this.orgao_id,
    this.ocorrencia_id,
    this.protocolo_ocorrencia,
    this.solicitante_ocorrencia_codigo_pessoa,
    this.solicitante_ocorrencia_codigo_sexo,
    this.solicitante_ocorrencia_codigo_orientacao_sexual,
    this.tipo_ocorrencia_id,
    this.classificacao_gravidade_id,
    this.natureza_ocorrencia_id,
    this.origem_ocorrencia_id,
    this.status_ocorrencia_id,
    this.acao_realizada,
    this.data_alteracao,
    this.hora_alteracao,
    this.usuario_alteracao_id,
    this.usuario_sistema,
  });

  // Método para converter de Map (ex: JSON) para Log_alteracao_demanda
  factory Log_alteracao_demanda.fromMap(Map<String, dynamic> map) {
    return Log_alteracao_demanda(
      Log_alteracao_Demanda_Id: map['Log_alteracao_Demanda_Id'],
      demanda_id: map['demanda_id'],
      status_demanda_id: map['status_demanda_id'],
      acao_demanda_id: map['acao_demanda_id'],
      orgao_id: map['orgao_id'],
      ocorrencia_id: map['ocorrencia_id']?.toDouble(),
      protocolo_ocorrencia: map['protocolo_ocorrencia'],
      solicitante_ocorrencia_codigo_pessoa: map['solicitante_ocorrencia_codigo_pessoa'],
      solicitante_ocorrencia_codigo_sexo: map['solicitante_ocorrencia_codigo_sexo'],
      solicitante_ocorrencia_codigo_orientacao_sexual: map['solicitante_ocorrencia_codigo_orientacao_sexual'],
      tipo_ocorrencia_id: map['tipo_ocorrencia_id'],
      classificacao_gravidade_id: map['classificacao_gravidade_id'],
      natureza_ocorrencia_id: map['natureza_ocorrencia_id'],
      origem_ocorrencia_id: map['origem_ocorrencia_id'],
      status_ocorrencia_id: map['status_ocorrencia_id'],
      acao_realizada: map['acao_realizada'],
      data_alteracao: map['data_alteracao'] != null ? DateTime.parse(map['data_alteracao']) : null,
      hora_alteracao: map['hora_alteracao'],
      usuario_alteracao_id: map['usuario_alteracao_id'],
      usuario_sistema: map['usuario_sistema'] != null ? Usuario.fromMap(map['usuario_sistema']) : null,
    );
  }

  // Método para converter a classe para Map (ex: para enviar como JSON)
  Map<String, dynamic> toMap() {
    return {
      'Log_alteracao_Demanda_Id': Log_alteracao_Demanda_Id,
      'demanda_id': demanda_id,
      'status_demanda_id': status_demanda_id,
      'acao_demanda_id': acao_demanda_id,
      'orgao_id': orgao_id,
      'ocorrencia_id': ocorrencia_id,
      'protocolo_ocorrencia': protocolo_ocorrencia,
      'solicitante_ocorrencia_codigo_pessoa': solicitante_ocorrencia_codigo_pessoa,
      'solicitante_ocorrencia_codigo_sexo': solicitante_ocorrencia_codigo_sexo,
      'solicitante_ocorrencia_codigo_orientacao_sexual': solicitante_ocorrencia_codigo_orientacao_sexual,
      'tipo_ocorrencia_id': tipo_ocorrencia_id,
      'classificacao_gravidade_id': classificacao_gravidade_id,
      'natureza_ocorrencia_id': natureza_ocorrencia_id,
      'origem_ocorrencia_id': origem_ocorrencia_id,
      'status_ocorrencia_id': status_ocorrencia_id,
      'acao_realizada': acao_realizada,
      'data_alteracao': data_alteracao?.toIso8601String(),
      'hora_alteracao': hora_alteracao,
      'usuario_alteracao_id': usuario_alteracao_id,
    };
  }
}
