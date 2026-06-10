import 'package:cloud_firestore/cloud_firestore.dart';

class ClienteVeiculoRecord {
  final String id;
  final String userId;
  final String nome;
  final String telefone;
  final String email;
  final String veiculo;
  final String placa;
  final String observacao;
  final DateTime createdAt;
  final DateTime updatedAt;

  ClienteVeiculoRecord({
    required this.id,
    required this.userId,
    required this.nome,
    required this.telefone,
    required this.email,
    required this.veiculo,
    required this.placa,
    required this.observacao,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ClienteVeiculoRecord.create({
    required String userId,
    required String nome,
    required String telefone,
    required String email,
    required String veiculo,
    required String placa,
    required String observacao,
    String id = '',
  }) {
    final now = DateTime.now();
    return ClienteVeiculoRecord(
      id: id,
      userId: userId,
      nome: nome.trim(),
      telefone: telefone.trim(),
      email: email.trim().toLowerCase(),
      veiculo: veiculo.trim(),
      placa: placa.trim().toUpperCase(),
      observacao: observacao.trim(),
      createdAt: now,
      updatedAt: now,
    );
  }

  factory ClienteVeiculoRecord.fromMap(Map<String, dynamic> map, String id) {
    return ClienteVeiculoRecord(
      id: id,
      userId: map['userId']?.toString() ?? '',
      nome: map['nome']?.toString() ?? '',
      telefone: map['telefone']?.toString() ?? '',
      email: map['email']?.toString() ?? '',
      veiculo: map['veiculo']?.toString() ?? '',
      placa: map['placa']?.toString() ?? '',
      observacao: map['observacao']?.toString() ?? '',
      createdAt: _readDate(map['createdAt']),
      updatedAt: _readDate(map['updatedAt']),
    );
  }

  ClienteVeiculoRecord copyWith({
    String? id,
    String? userId,
    String? nome,
    String? telefone,
    String? email,
    String? veiculo,
    String? placa,
    String? observacao,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return ClienteVeiculoRecord(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      nome: nome ?? this.nome,
      telefone: telefone ?? this.telefone,
      email: email ?? this.email,
      veiculo: veiculo ?? this.veiculo,
      placa: placa ?? this.placa,
      observacao: observacao ?? this.observacao,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'nome': nome,
      'telefone': telefone,
      'email': email,
      'veiculo': veiculo,
      'placa': placa,
      'observacao': observacao,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }

  static DateTime _readDate(dynamic value) {
    if (value is DateTime) {
      return value;
    }
    if (value is Timestamp) {
      return value.toDate();
    }
    if (value is String) {
      return DateTime.tryParse(value) ?? DateTime.now();
    }
    return DateTime.now();
  }
}