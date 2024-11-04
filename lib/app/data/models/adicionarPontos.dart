import 'dart:convert';

import 'package:flutter/widgets.dart';

class adicionarPontos {
  final double? latitude;
  final double? longitude;
  final int? demanda_id;
  final int? usuario_id;
  adicionarPontos({
    this.latitude,
    this.longitude,
    this.demanda_id,
    this.usuario_id,
  });

  adicionarPontos copyWith({
    ValueGetter<double?>? latitude,
    ValueGetter<double?>? longitude,
    ValueGetter<int?>? demanda_id,
    ValueGetter<int?>? usuario_id,
  }) {
    return adicionarPontos(
      latitude: latitude != null ? latitude() : this.latitude,
      longitude: longitude != null ? longitude() : this.longitude,
      demanda_id: demanda_id != null ? demanda_id() : this.demanda_id,
      usuario_id: usuario_id != null ? usuario_id() : this.usuario_id,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'latitude': latitude,
      'longitude': longitude,
      'demanda_id': demanda_id,
      'usuario_id': usuario_id,
    };
  }

  factory adicionarPontos.fromMap(Map<String, dynamic> map) {
    return adicionarPontos(
      latitude: map['latitude']?.toDouble(),
      longitude: map['longitude']?.toDouble(),
      demanda_id: map['demanda_id']?.toInt(),
      usuario_id: map['usuario_id']?.toInt(),
    );
  }

  String toJson() => json.encode(toMap());

  factory adicionarPontos.fromJson(String source) =>
      adicionarPontos.fromMap(json.decode(source));

  @override
  String toString() {
    return 'adicionarPontos(latitude: $latitude, longitude: $longitude, demanda_id: $demanda_id, usuario_id: $usuario_id)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is adicionarPontos &&
        other.latitude == latitude &&
        other.longitude == longitude &&
        other.demanda_id == demanda_id &&
        other.usuario_id == usuario_id;
  }

  @override
  int get hashCode {
    return latitude.hashCode ^
        longitude.hashCode ^
        demanda_id.hashCode ^
        usuario_id.hashCode;
  }
}
