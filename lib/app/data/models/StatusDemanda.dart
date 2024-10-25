import 'dart:convert';

class StatusDemanda {
  final int statusDemandaId;
  final String descricaoStatusDemanda;
  StatusDemanda({
    required this.statusDemandaId,
    required this.descricaoStatusDemanda,
  });
  

  

  StatusDemanda copyWith({
    int? statusDemandaId,
    String? descricaoStatusDemanda,
  }) {
    return StatusDemanda(
      statusDemandaId: statusDemandaId ?? this.statusDemandaId,
      descricaoStatusDemanda: descricaoStatusDemanda ?? this.descricaoStatusDemanda,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'statusDemandaId': statusDemandaId,
      'descricaoStatusDemanda': descricaoStatusDemanda,
    };
  }

  factory StatusDemanda.fromMap(Map<String, dynamic> map) {
    return StatusDemanda(
      statusDemandaId: map['status_demanda_id']?.toInt() ?? 0,
      descricaoStatusDemanda: map['descricao_status_demanda'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory StatusDemanda.fromJson(String source) => StatusDemanda.fromMap(json.decode(source));

  @override
  String toString() => 'StatusDemanda(statusDemandaId: $statusDemandaId, descricaoStatusDemanda: $descricaoStatusDemanda)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is StatusDemanda &&
      other.statusDemandaId == statusDemandaId &&
      other.descricaoStatusDemanda == descricaoStatusDemanda;
  }

  @override
  int get hashCode => statusDemandaId.hashCode ^ descricaoStatusDemanda.hashCode;
}


