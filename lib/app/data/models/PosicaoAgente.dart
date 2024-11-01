class PosicaoAgente {
  int? id;
  double? latitude;
  double? longitude;
  DateTime? ultimoHorario;
  int? usuarioId;

  PosicaoAgente({
     this.id,
     this.latitude,
     this.longitude,
     this.ultimoHorario,
     this.usuarioId,
  });

  // Construtor para criar a instância a partir de um mapa (ex.: JSON)
  factory PosicaoAgente.fromMap(Map<String, dynamic> map) {
    return PosicaoAgente(
      id: map['id'] ?? 0,
      latitude: map['latitude'] ?? 0.0,
      longitude: map['longitude'] ?? 0.0,
      ultimoHorario: DateTime.parse(map['ultimoHorario']),
      usuarioId: map['usuario_id'] ?? 0,
    );
  }

  // Método para converter a instância em um mapa (ex.: para enviar como JSON)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'latitude': latitude,
      'longitude': longitude,
      'ultimoHorario': ultimoHorario?.toIso8601String(),
      'usuario_id': usuarioId,
    };
  }
}
