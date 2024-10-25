import 'dart:convert';

import 'package:flutter/widgets.dart';

class Orgao {
  final int orgaoId;
  final String nomeAbreviadoOrgao;
  final DateTime dataAtivacaoOrgao;
  final DateTime? dataDesativacaoOrgao;
  Orgao({
    required this.orgaoId,
    required this.nomeAbreviadoOrgao,
    required this.dataAtivacaoOrgao,
    this.dataDesativacaoOrgao,
  });



  Orgao copyWith({
    int? orgaoId,
    String? nomeAbreviadoOrgao,
    DateTime? dataAtivacaoOrgao,
    ValueGetter<DateTime?>? dataDesativacaoOrgao,
  }) {
    return Orgao(
      orgaoId: orgaoId ?? this.orgaoId,
      nomeAbreviadoOrgao: nomeAbreviadoOrgao ?? this.nomeAbreviadoOrgao,
      dataAtivacaoOrgao: dataAtivacaoOrgao ?? this.dataAtivacaoOrgao,
      dataDesativacaoOrgao: dataDesativacaoOrgao != null ? dataDesativacaoOrgao() : this.dataDesativacaoOrgao,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'orgaoId': orgaoId,
      'nomeAbreviadoOrgao': nomeAbreviadoOrgao,
      'dataAtivacaoOrgao': dataAtivacaoOrgao.millisecondsSinceEpoch,
      'dataDesativacaoOrgao': dataDesativacaoOrgao?.millisecondsSinceEpoch,
    };
  }

  factory Orgao.fromMap(Map<String, dynamic> map) {
    return Orgao(
      orgaoId: map['orgao_id']?.toInt() ?? 0,
      nomeAbreviadoOrgao: map['nome_abreviado_orgao'] ?? '',
      dataDesativacaoOrgao: map['data_desativacao_orgao'] != null ? DateTime.parse(map['data_desativacao_orgao']) : null,
      dataAtivacaoOrgao: DateTime.parse(map['data_ativacao_orgao']),
    );
  }

  String toJson() => json.encode(toMap());

  factory Orgao.fromJson(String source) => Orgao.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Orgao(orgaoId: $orgaoId, nomeAbreviadoOrgao: $nomeAbreviadoOrgao, dataAtivacaoOrgao: $dataAtivacaoOrgao, dataDesativacaoOrgao: $dataDesativacaoOrgao)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is Orgao &&
      other.orgaoId == orgaoId &&
      other.nomeAbreviadoOrgao == nomeAbreviadoOrgao &&
      other.dataAtivacaoOrgao == dataAtivacaoOrgao &&
      other.dataDesativacaoOrgao == dataDesativacaoOrgao;
  }

  @override
  int get hashCode {
    return orgaoId.hashCode ^
      nomeAbreviadoOrgao.hashCode ^
      dataAtivacaoOrgao.hashCode ^
      dataDesativacaoOrgao.hashCode;
  }
}
