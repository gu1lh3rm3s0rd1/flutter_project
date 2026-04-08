import 'package:flutter/material.dart';

class OSController extends ChangeNotifier {
  final List<Map<String, String>> _ordens = [
    {
      'codigo': 'OS-1024',
      'veiculo': 'Honda Fit 2019',
      'servico': 'Troca de pastilhas',
      'status': 'Em execucao',
      'valor': 'R\$ 420,00',
    },
    {
      'codigo': 'OS-1025',
      'veiculo': 'Onix 1.0 Turbo',
      'servico': 'Revisao de 40.000 km',
      'status': 'Aguardando peca',
      'valor': 'R\$ 890,00',
    },
  ];

  List<Map<String, String>> get ordens => List.unmodifiable(_ordens);

  void cadastrarOrdem({
    required String veiculo,
    required String servico,
    required String valor,
  }) {
    final proximoCodigo = 'OS-${1024 + _ordens.length + 1}';
    _ordens.insert(0, {
      'codigo': proximoCodigo,
      'veiculo': veiculo.trim(),
      'servico': servico.trim(),
      'status': 'Recebido',
      'valor': 'R\$ ${valor.trim()}',
    });
    notifyListeners();
  }
}