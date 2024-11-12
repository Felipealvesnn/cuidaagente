import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import 'package:cuidaagente/app/data/models/ocorrencia.dart';

class natureza_ocorrencia {
  int? natureza_ocorrencia_id;
  String? descricao_natureza_ocorrencia;
  DateTime? data_ativacao_natureza_ocorrencia;
  DateTime? data_desativacao_natureza_ocorrencia;

  // Relacionamentos com outras classes (definidos como dynamic)
  List<Ocorrencia>? ocorrencia;
  List<dynamic>? tipo_ocorrencia;
  natureza_ocorrencia({
    this.natureza_ocorrencia_id,
    this.descricao_natureza_ocorrencia,
    this.data_ativacao_natureza_ocorrencia,
    this.data_desativacao_natureza_ocorrencia,
    this.ocorrencia,
    this.tipo_ocorrencia,
  });

 

  natureza_ocorrencia copyWith({
    ValueGetter<int?>? natureza_ocorrencia_id,
    ValueGetter<String?>? descricao_natureza_ocorrencia,
    ValueGetter<DateTime?>? data_ativacao_natureza_ocorrencia,
    ValueGetter<DateTime?>? data_desativacao_natureza_ocorrencia,
    ValueGetter<List<Ocorrencia>?>? ocorrencia,
    ValueGetter<List<dynamic>?>? tipo_ocorrencia,
  }) {
    return natureza_ocorrencia(
      natureza_ocorrencia_id: natureza_ocorrencia_id != null ? natureza_ocorrencia_id() : this.natureza_ocorrencia_id,
      descricao_natureza_ocorrencia: descricao_natureza_ocorrencia != null ? descricao_natureza_ocorrencia() : this.descricao_natureza_ocorrencia,
      data_ativacao_natureza_ocorrencia: data_ativacao_natureza_ocorrencia != null ? data_ativacao_natureza_ocorrencia() : this.data_ativacao_natureza_ocorrencia,
      data_desativacao_natureza_ocorrencia: data_desativacao_natureza_ocorrencia != null ? data_desativacao_natureza_ocorrencia() : this.data_desativacao_natureza_ocorrencia,
      ocorrencia: ocorrencia != null ? ocorrencia() : this.ocorrencia,
      tipo_ocorrencia: tipo_ocorrencia != null ? tipo_ocorrencia() : this.tipo_ocorrencia,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'natureza_ocorrencia_id': natureza_ocorrencia_id,
      'descricao_natureza_ocorrencia': descricao_natureza_ocorrencia,
      'data_ativacao_natureza_ocorrencia': data_ativacao_natureza_ocorrencia?.millisecondsSinceEpoch,
      'data_desativacao_natureza_ocorrencia': data_desativacao_natureza_ocorrencia?.millisecondsSinceEpoch,
      'ocorrencia': ocorrencia?.map((x) => x?.toMap())?.toList(),
      'tipo_ocorrencia': tipo_ocorrencia,
    };
  }

  factory natureza_ocorrencia.fromMap(Map<String, dynamic> map) {
    return natureza_ocorrencia(
      natureza_ocorrencia_id: map['natureza_ocorrencia_id']?.toInt(),
      descricao_natureza_ocorrencia: map['descricao_natureza_ocorrencia'],
      data_ativacao_natureza_ocorrencia: map['data_ativacao_natureza_ocorrencia'] != null 
    ? DateTime.parse(map['data_ativacao_natureza_ocorrencia']) 
    : null,data_desativacao_natureza_ocorrencia: map['data_desativacao_natureza_ocorrencia'] != null ? DateTime.fromMillisecondsSinceEpoch(map['data_desativacao_natureza_ocorrencia']) : null,
      ocorrencia: map['ocorrencia'] != null ? List<Ocorrencia>.from(map['ocorrencia']?.map((x) => Ocorrencia.fromMap(x))) : null,
      tipo_ocorrencia: List<dynamic>.from(map['tipo_ocorrencia']),
    );
  }

  String toJson() => json.encode(toMap());

  factory natureza_ocorrencia.fromJson(String source) => natureza_ocorrencia.fromMap(json.decode(source));

  @override
  String toString() {
    return 'natureza_ocorrencia(natureza_ocorrencia_id: $natureza_ocorrencia_id, descricao_natureza_ocorrencia: $descricao_natureza_ocorrencia, data_ativacao_natureza_ocorrencia: $data_ativacao_natureza_ocorrencia, data_desativacao_natureza_ocorrencia: $data_desativacao_natureza_ocorrencia, ocorrencia: $ocorrencia, tipo_ocorrencia: $tipo_ocorrencia)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is natureza_ocorrencia &&
      other.natureza_ocorrencia_id == natureza_ocorrencia_id &&
      other.descricao_natureza_ocorrencia == descricao_natureza_ocorrencia &&
      other.data_ativacao_natureza_ocorrencia == data_ativacao_natureza_ocorrencia &&
      other.data_desativacao_natureza_ocorrencia == data_desativacao_natureza_ocorrencia &&
      listEquals(other.ocorrencia, ocorrencia) &&
      listEquals(other.tipo_ocorrencia, tipo_ocorrencia);
  }

  @override
  int get hashCode {
    return natureza_ocorrencia_id.hashCode ^
      descricao_natureza_ocorrencia.hashCode ^
      data_ativacao_natureza_ocorrencia.hashCode ^
      data_desativacao_natureza_ocorrencia.hashCode ^
      ocorrencia.hashCode ^
      tipo_ocorrencia.hashCode;
  }
}
