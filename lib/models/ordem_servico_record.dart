import 'package:cloud_firestore/cloud_firestore.dart';

class OrdemServicoRecord {
  final String id;
  final String userId;
  final String codigo;
  final String cliente;
  final String telefone;
  final String veiculo;
  final String placa;
  final String servico;
  final String status;
  final double valor;
  final String observacao;
  final DateTime dataEntrada;
  final DateTime dataPrevista;
  final DateTime createdAt;
  final DateTime updatedAt;

  OrdemServicoRecord({
    required this.id,
    required this.userId,
    required this.codigo,
    required this.cliente,
    required this.telefone,
    required this.veiculo,
    required this.placa,
    required this.servico,
    required this.status,
    required this.valor,
    required this.observacao,
    required this.dataEntrada,
    required this.dataPrevista,
    required this.createdAt,
    required this.updatedAt,
  });

  factory OrdemServicoRecord.create({
    required String userId,
    required String cliente,
    required String telefone,
    required String veiculo,
    required String placa,
    required String servico,
    required String status,
    required double valor,
    required String observacao,
    required DateTime dataEntrada,
    required DateTime dataPrevista,
    String codigo = '',
    String id = '',
  }) {
    final now = DateTime.now();
    return OrdemServicoRecord(
      id: id,
      userId: userId,
      codigo: codigo,
      cliente: cliente.trim(),
      telefone: telefone.trim(),
      veiculo: veiculo.trim(),
      placa: placa.trim().toUpperCase(),
      servico: servico.trim(),
      status: status.trim(),
      valor: valor,
      observacao: observacao.trim(),
      dataEntrada: dataEntrada,
      dataPrevista: dataPrevista,
      createdAt: now,
      updatedAt: now,
    );
  }

  factory OrdemServicoRecord.fromMap(Map<String, dynamic> map, String id) {
    return OrdemServicoRecord(
      id: id,
      userId: map['userId']?.toString() ?? '',
      codigo: map['codigo']?.toString() ?? '',
      cliente: map['cliente']?.toString() ?? '',
      telefone: map['telefone']?.toString() ?? '',
      veiculo: map['veiculo']?.toString() ?? '',
      placa: map['placa']?.toString() ?? '',
      servico: map['servico']?.toString() ?? '',
      status: map['status']?.toString() ?? '',
      valor: (map['valor'] as num?)?.toDouble() ?? double.tryParse(map['valor']?.toString() ?? '') ?? 0,
      observacao: map['observacao']?.toString() ?? '',
      dataEntrada: _readDate(map['dataEntrada']),
      dataPrevista: _readDate(map['dataPrevista']),
      createdAt: _readDate(map['createdAt']),
      updatedAt: _readDate(map['updatedAt']),
    );
  }

  OrdemServicoRecord copyWith({
    String? id,
    String? userId,
    String? codigo,
    String? cliente,
    String? telefone,
    String? veiculo,
    String? placa,
    String? servico,
    String? status,
    double? valor,
    String? observacao,
    DateTime? dataEntrada,
    DateTime? dataPrevista,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return OrdemServicoRecord(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      codigo: codigo ?? this.codigo,
      cliente: cliente ?? this.cliente,
      telefone: telefone ?? this.telefone,
      veiculo: veiculo ?? this.veiculo,
      placa: placa ?? this.placa,
      servico: servico ?? this.servico,
      status: status ?? this.status,
      valor: valor ?? this.valor,
      observacao: observacao ?? this.observacao,
      dataEntrada: dataEntrada ?? this.dataEntrada,
      dataPrevista: dataPrevista ?? this.dataPrevista,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'codigo': codigo,
      'cliente': cliente,
      'telefone': telefone,
      'veiculo': veiculo,
      'placa': placa,
      'servico': servico,
      'status': status,
      'valor': valor,
      'observacao': observacao,
      'dataEntrada': dataEntrada,
      'dataPrevista': dataPrevista,
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