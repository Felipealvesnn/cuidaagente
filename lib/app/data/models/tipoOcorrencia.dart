import 'dart:convert';

import 'package:cuidaagente/app/data/models/classificacao_gravidade.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import 'package:cuidaagente/app/data/models/naturezaOcorrencia.dart';
import 'package:cuidaagente/app/data/models/ocorrencia.dart';

class tipo_ocorrencia {
  int? tipo_ocorrencia_id;
  String? descricao_tipo_ocorrencia;
  int? classificacao_gravidade_id;
  int? natureza_ocorrencia_id;
  DateTime? data_ativacao_tipo_ocorrencia;
  DateTime? data_desativacao_tipo_ocorrencia;
  bool? useapp;

  // Relacionamentos com outras classes (definidos como dynamic)
  classificacao_gravidade? Classificacao_gravidade;
  natureza_ocorrencia? Natureza_ocorrencia;
  List<Ocorrencia>? ocorrencia;
  tipo_ocorrencia({
    this.tipo_ocorrencia_id,
    this.descricao_tipo_ocorrencia,
    this.classificacao_gravidade_id,
    this.natureza_ocorrencia_id,
    this.data_ativacao_tipo_ocorrencia,
    this.data_desativacao_tipo_ocorrencia,
    this.useapp,
     this.Classificacao_gravidade,
    this.Natureza_ocorrencia,
    this.ocorrencia,
  });

  tipo_ocorrencia copyWith({
    ValueGetter<int?>? tipo_ocorrencia_id,
    ValueGetter<String?>? descricao_tipo_ocorrencia,
    ValueGetter<int?>? classificacao_gravidade_id,
    ValueGetter<int?>? natureza_ocorrencia_id,
    ValueGetter<DateTime?>? data_ativacao_tipo_ocorrencia,
    ValueGetter<DateTime?>? data_desativacao_tipo_ocorrencia,
    ValueGetter<bool?>? useapp,
    dynamic? classificacao_gravidade,
    natureza_ocorrencia? Natureza_ocorrencia,
    ValueGetter<List<Ocorrencia>?>? ocorrencia,
  }) {
    return tipo_ocorrencia(
      tipo_ocorrencia_id: tipo_ocorrencia_id != null
          ? tipo_ocorrencia_id()
          : this.tipo_ocorrencia_id,
      descricao_tipo_ocorrencia: descricao_tipo_ocorrencia != null
          ? descricao_tipo_ocorrencia()
          : this.descricao_tipo_ocorrencia,
      classificacao_gravidade_id: classificacao_gravidade_id != null
          ? classificacao_gravidade_id()
          : this.classificacao_gravidade_id,
      natureza_ocorrencia_id: natureza_ocorrencia_id != null
          ? natureza_ocorrencia_id()
          : this.natureza_ocorrencia_id,
      data_ativacao_tipo_ocorrencia: data_ativacao_tipo_ocorrencia != null
          ? data_ativacao_tipo_ocorrencia()
          : this.data_ativacao_tipo_ocorrencia,
      data_desativacao_tipo_ocorrencia: data_desativacao_tipo_ocorrencia != null
          ? data_desativacao_tipo_ocorrencia()
          : this.data_desativacao_tipo_ocorrencia,
      useapp: useapp != null ? useapp() : this.useapp,
      Classificacao_gravidade:
          classificacao_gravidade ?? this.Classificacao_gravidade,
      Natureza_ocorrencia: Natureza_ocorrencia ?? this.Natureza_ocorrencia,
      ocorrencia: ocorrencia != null ? ocorrencia() : this.ocorrencia,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'tipo_ocorrencia_id': tipo_ocorrencia_id,
      'descricao_tipo_ocorrencia': descricao_tipo_ocorrencia,
      'classificacao_gravidade_id': classificacao_gravidade_id,
      'natureza_ocorrencia_id': natureza_ocorrencia_id,
      'data_ativacao_tipo_ocorrencia':
          data_ativacao_tipo_ocorrencia?.millisecondsSinceEpoch,
      'data_desativacao_tipo_ocorrencia':
          data_desativacao_tipo_ocorrencia?.millisecondsSinceEpoch,
      'useapp': useapp,
      'classificacao_gravidade': classificacao_gravidade,
      'natureza_ocorrencia': Natureza_ocorrencia?.toMap(),

      'ocorrencia': ocorrencia?.map((x) => x?.toMap())?.toList(),
    };
  }

  factory tipo_ocorrencia.fromMap(Map<String, dynamic> map) {
    return tipo_ocorrencia(
      tipo_ocorrencia_id: map['tipo_ocorrencia_id']?.toInt(),
      descricao_tipo_ocorrencia: map['descricao_tipo_ocorrencia'],
      classificacao_gravidade_id: map['classificacao_gravidade_id']?.toInt(),
      natureza_ocorrencia_id: map['natureza_ocorrencia_id']?.toInt(),
      useapp: map['useapp'] ?? false,
      Classificacao_gravidade: map['classificacao_gravidade'] != null
          ? classificacao_gravidade.fromMap(map['classificacao_gravidade'])
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory tipo_ocorrencia.fromJson(String source) =>
      tipo_ocorrencia.fromMap(json.decode(source));

  @override
  String toString() {
    return 'tipo_ocorrencia(tipo_ocorrencia_id: $tipo_ocorrencia_id, descricao_tipo_ocorrencia: $descricao_tipo_ocorrencia, classificacao_gravidade_id: $classificacao_gravidade_id, natureza_ocorrencia_id: $natureza_ocorrencia_id, data_ativacao_tipo_ocorrencia: $data_ativacao_tipo_ocorrencia, data_desativacao_tipo_ocorrencia: $data_desativacao_tipo_ocorrencia, useapp: $useapp, classificacao_gravidade: $classificacao_gravidade, Natureza_ocorrencia: $Natureza_ocorrencia, ocorrencia: $ocorrencia)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is tipo_ocorrencia &&
        other.tipo_ocorrencia_id == tipo_ocorrencia_id &&
        other.descricao_tipo_ocorrencia == descricao_tipo_ocorrencia &&
        other.classificacao_gravidade_id == classificacao_gravidade_id &&
        other.natureza_ocorrencia_id == natureza_ocorrencia_id &&
        other.data_ativacao_tipo_ocorrencia == data_ativacao_tipo_ocorrencia &&
        other.data_desativacao_tipo_ocorrencia ==
            data_desativacao_tipo_ocorrencia &&
        other.useapp == useapp &&
        other.Classificacao_gravidade == classificacao_gravidade &&
        other.Natureza_ocorrencia == Natureza_ocorrencia &&
        listEquals(other.ocorrencia, ocorrencia);
  }

  @override
  int get hashCode {
    return tipo_ocorrencia_id.hashCode ^
        descricao_tipo_ocorrencia.hashCode ^
        classificacao_gravidade_id.hashCode ^
        natureza_ocorrencia_id.hashCode ^
        data_ativacao_tipo_ocorrencia.hashCode ^
        data_desativacao_tipo_ocorrencia.hashCode ^
        useapp.hashCode ^
       // classificacao_gravidade.hashCode ^
        Natureza_ocorrencia.hashCode ^
        ocorrencia.hashCode;
  }
}
