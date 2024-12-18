class LogAgenteDemanda {
  int? id;
  int? usuarioId;
  double? latitude;
  double? longitude;
  int? demandaId;
  DateTime? dataIniciado;
  bool? ativo;
  String? nomeUsuario;

  LogAgenteDemanda({
    this.id,
    this.usuarioId,
    this.latitude,
    this.longitude,
    this.demandaId,
    this.dataIniciado,
    this.ativo,
    this.nomeUsuario,
  });

  // Método para converter um Map (ex: JSON) para uma instância de LogAgenteDemanda
  factory LogAgenteDemanda.fromMap(Map<String, dynamic> map) {
    return LogAgenteDemanda(
      id: map['id'],
      usuarioId: map['usuario_id'],
      latitude: map['latitude'],
      nomeUsuario: map['usuario_sistema']['nome'],
      longitude: map['longitude'],
      demandaId: map['demanda_id'],
      dataIniciado: map['dataIniciado'] != null ? DateTime.parse(map['dataIniciado']) : null,
      ativo: map['ativo'],
    );
  }

  // Método para converter uma instância de LogAgenteDemanda para um Map (ex: para enviar como JSON)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'usuario_id': usuarioId,
      'latitude': latitude,
      'longitude': longitude,
      'demanda_id': demandaId,
      'dataIniciado': dataIniciado?.toIso8601String(),
      'ativo': ativo,
    };
  }
}
