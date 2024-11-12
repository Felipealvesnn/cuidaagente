class classificacao_gravidade {
  int? classificacao_gravidade_id;
  String? descricao_classificacao_gravidade;
  List<int>? sla_atendimento; // byte array convertido para List<int> em Dart

  // Relacionamentos com outras classes definidos como listas dinâmicas

  classificacao_gravidade({
    this.classificacao_gravidade_id,
    this.descricao_classificacao_gravidade,
    this.sla_atendimento,
  });

  // Método fromMap para criar uma instância a partir de um Map
  factory classificacao_gravidade.fromMap(Map<String, dynamic> map) {
    return classificacao_gravidade(
      classificacao_gravidade_id: map['classificacao_gravidade_id'],
      descricao_classificacao_gravidade:
          map['descricao_classificacao_gravidade'],
    );
  }
}
