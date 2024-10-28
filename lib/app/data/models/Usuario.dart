import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import 'package:cuidaagente/app/data/models/ocorrencia.dart';

import 'dart:convert';

class Usuario {
  final String? loginUsuario;
  final String? senhaUsuario;
  final int? usuarioId;
  final String? nome;
  final String? email;
  final String? cpf;
  final bool? primeiroAcesso;
  final DateTime? dataCadastro;
  final bool? ativo;
  final String? token;
  final int? idRoles;
  final String? matricula;
  final List<Ocorrencia>? ocorrencia;
  final List<OrgaoSetorUsuario>? orgaoSetorUsuario;
  final Roles? roles;

  Usuario({
    this.loginUsuario,
    this.senhaUsuario,
    this.usuarioId,
    this.nome,
    this.email,
    this.cpf,
    this.primeiroAcesso,
    this.dataCadastro,
    this.ativo,
    this.token,
    this.idRoles,
    this.matricula,
    this.ocorrencia,
    this.orgaoSetorUsuario,
    this.roles,
  });

  // Método copyWith para criar uma nova instância com valores modificados
  Usuario copyWith({
    String? loginUsuario,
    String? senhaUsuario,
    int? usuarioId,
    String? nome,
    String? email,
    String? cpf,
    bool? primeiroAcesso,
    DateTime? dataCadastro,
    bool? ativo,
    String? token,
    int? idRoles,
    String? matricula,
    List<Ocorrencia>? ocorrencia,
    List<OrgaoSetorUsuario>? orgaoSetorUsuario,
    Roles? roles,
  }) {
    return Usuario(
      loginUsuario: loginUsuario ?? this.loginUsuario,
      senhaUsuario: senhaUsuario ?? this.senhaUsuario,
      usuarioId: usuarioId ?? this.usuarioId,
      nome: nome ?? this.nome,
      email: email ?? this.email,
      cpf: cpf ?? this.cpf,
      primeiroAcesso: primeiroAcesso ?? this.primeiroAcesso,
      dataCadastro: dataCadastro ?? this.dataCadastro,
      ativo: ativo ?? this.ativo,
      token: token ?? this.token,
      idRoles: idRoles ?? this.idRoles,
      matricula: matricula ?? this.matricula,
      ocorrencia: ocorrencia ?? this.ocorrencia,
      orgaoSetorUsuario: orgaoSetorUsuario ?? this.orgaoSetorUsuario,
      roles: roles ?? this.roles,
    );
  }

  // Converter a classe para Map (para JSON)
  Map<String, dynamic> toMap() {
    return {
      'login_usuario': loginUsuario,
      'senha_usuario': senhaUsuario,
      'usuario_id': usuarioId,
      'nome': nome,
      'email': email,
      'cpf': cpf,
      'primeiro_acesso': primeiroAcesso,
      'data_cadastro': dataCadastro?.toIso8601String(),
      'ativo': ativo,
      'token': token,
      'idroles': idRoles,
      'matricula': matricula,
      'ocorrencia': ocorrencia?.map((x) => x.toMap()).toList(),
      'orgao_setor_usuario': orgaoSetorUsuario?.map((x) => x.toMap()).toList(),
      'roles': roles?.toMap(),
    };
  }

  // Criar uma instância de Usuario a partir de um Map (de JSON)
  factory Usuario.fromMap(Map<String, dynamic> map) {
    return Usuario(
      loginUsuario: map['login_usuario'],
      senhaUsuario: map['senha_usuario'],
      usuarioId: map['usuario_id']?.toInt(),
      nome: map['nome'],
      email: map['email'],
      cpf: map['cpf'],
      primeiroAcesso: map['primeiro_acesso'],
      dataCadastro: map['data_cadastro'] != null
          ? DateTime.parse(map['data_cadastro'])
          : null,
      ativo: map['ativo'],
      token: map['token'],
      idRoles: map['idroles']?.toInt(),
      matricula: map['matricula'],
      ocorrencia: map['ocorrencia'] != null
          ? List<Ocorrencia>.from(map['ocorrencia']?.map((x) => Ocorrencia.fromMap(x)))
          : null,
      orgaoSetorUsuario: map['orgao_setor_usuario'] != null
          ? List<OrgaoSetorUsuario>.from(map['orgao_setor_usuario']?.map((x) => OrgaoSetorUsuario.fromMap(x)))
          : null,
      roles: map['roles'] != null ? Roles.fromMap(map['roles']) : null,
    );
  }

  // Serializar para JSON
  String toJson() => json.encode(toMap());

  // Deserializar de JSON
  factory Usuario.fromJson(String source) => Usuario.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Usuario(loginUsuario: $loginUsuario, senhaUsuario: $senhaUsuario, usuarioId: $usuarioId, nome: $nome, email: $email, cpf: $cpf, primeiroAcesso: $primeiroAcesso, dataCadastro: $dataCadastro, ativo: $ativo, token: $token, idRoles: $idRoles, matricula: $matricula, ocorrencia: $ocorrencia, orgaoSetorUsuario: $orgaoSetorUsuario, roles: $roles)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Usuario &&
        other.loginUsuario == loginUsuario &&
        other.senhaUsuario == senhaUsuario &&
        other.usuarioId == usuarioId &&
        other.nome == nome &&
        other.email == email &&
        other.cpf == cpf &&
        other.primeiroAcesso == primeiroAcesso &&
        other.dataCadastro == dataCadastro &&
        other.ativo == ativo &&
        other.token == token &&
        other.idRoles == idRoles &&
        other.matricula == matricula &&
        listEquals(other.ocorrencia, ocorrencia) &&
        listEquals(other.orgaoSetorUsuario, orgaoSetorUsuario) &&
        other.roles == roles;
  }

  @override
  int get hashCode {
    return loginUsuario.hashCode ^
        senhaUsuario.hashCode ^
        usuarioId.hashCode ^
        nome.hashCode ^
        email.hashCode ^
        cpf.hashCode ^
        primeiroAcesso.hashCode ^
        dataCadastro.hashCode ^
        ativo.hashCode ^
        token.hashCode ^
        idRoles.hashCode ^
        matricula.hashCode ^
        ocorrencia.hashCode ^
        orgaoSetorUsuario.hashCode ^
        roles.hashCode;
  }
}


class OrgaoSetorUsuario {
  final int orgaoId;
  final int usuarioId;
  final int setorId;
  OrgaoSetorUsuario({
    required this.orgaoId,
    required this.usuarioId,
    required this.setorId,
  });


 

  OrgaoSetorUsuario copyWith({
    int? orgaoId,
    int? usuarioId,
    int? setorId,
  }) {
    return OrgaoSetorUsuario(
      orgaoId: orgaoId ?? this.orgaoId,
      usuarioId: usuarioId ?? this.usuarioId,
      setorId: setorId ?? this.setorId,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'orgaoId': orgaoId,
      'usuarioId': usuarioId,
      'setorId': setorId,
    };
  }

  factory OrgaoSetorUsuario.fromMap(Map<String, dynamic> map) {
    return OrgaoSetorUsuario(
      orgaoId: map['orgaoId']?.toInt() ?? 0,
      usuarioId: map['usuarioId']?.toInt() ?? 0,
      setorId: map['setorId']?.toInt() ?? 0,
    );
  }

  String toJson() => json.encode(toMap());

  factory OrgaoSetorUsuario.fromJson(String source) => OrgaoSetorUsuario.fromMap(json.decode(source));

  @override
  String toString() => 'OrgaoSetorUsuario(orgaoId: $orgaoId, usuarioId: $usuarioId, setorId: $setorId)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is OrgaoSetorUsuario &&
      other.orgaoId == orgaoId &&
      other.usuarioId == usuarioId &&
      other.setorId == setorId;
  }

  @override
  int get hashCode => orgaoId.hashCode ^ usuarioId.hashCode ^ setorId.hashCode;
}

class Roles {
  final int id;
  final String descricao;
  final List<Usuario>? usuarioSistema;
  Roles({
    required this.id,
    required this.descricao,
     this.usuarioSistema,
  });

  

  Roles copyWith({
    int? id,
    String? descricao,
    List<Usuario>? usuarioSistema,
  }) {
    return Roles(
      id: id ?? this.id,
      descricao: descricao ?? this.descricao,
      usuarioSistema: usuarioSistema ?? this.usuarioSistema,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'descricao': descricao,
     // 'usuarioSistema': usuarioSistema.map((x) => x.toMap()).toList(),
    };
  }

  factory Roles.fromMap(Map<String, dynamic> map) {
    return Roles(
      id: map['id']?.toInt() ?? 0,
      descricao: map['descricao'] ?? '',
      //usuarioSistema: List<Usuario>.from(map['usuarioSistema']?.map((x) => Usuario.fromMap(x))),
    );
  }

  String toJson() => json.encode(toMap());

  factory Roles.fromJson(String source) => Roles.fromMap(json.decode(source));

  @override
  String toString() => 'Roles(id: $id, descricao: $descricao, usuarioSistema: $usuarioSistema)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is Roles &&
      other.id == id &&
      other.descricao == descricao &&
      listEquals(other.usuarioSistema, usuarioSistema);
  }

  @override
  int get hashCode => id.hashCode ^ descricao.hashCode ^ usuarioSistema.hashCode;
}
