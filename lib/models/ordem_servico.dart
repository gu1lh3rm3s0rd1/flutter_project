class OrdemServico {
  final String id;
  final String codigo;
  final String veiculo;
  final String servico;
  final String status;
  final double valor;

  OrdemServico({
    required this.id,
    required this.codigo,
    required this.veiculo,
    required this.servico,
    required this.status,
    required this.valor,
  });

  factory OrdemServico.fromMap(Map<String, dynamic> map) {
    return OrdemServico(
      id: map['id'] ?? '',
      codigo: map['codigo'] ?? '',
      veiculo: map['veiculo'] ?? '',
      servico: map['servico'] ?? '',
      status: map['status'] ?? '',
      valor: double.tryParse(map['valor'].toString()) ?? 0.0,
    );
  }
}