import 'package:flutter/material.dart';

class ClienteController extends ChangeNotifier {
  final List<Map<String, String>> _veiculos = [
    {'cliente': 'Ana Martins', 'veiculo': 'Honda Fit 2019', 'placa': 'FZT-4821'},
    {'cliente': 'Joao Prado', 'veiculo': 'Fiat Toro 2022', 'placa': 'RNP-6A41'},
    {'cliente': 'Carlos Reis', 'veiculo': 'Onix 1.0 Turbo', 'placa': 'MOP-7783'},
  ];

  List<Map<String, String>> get veiculos => List.unmodifiable(_veiculos);

  void adicionarVeiculo({
    required String cliente,
    required String veiculo,
    required String placa,
  }) {
    _veiculos.add({
      'cliente': cliente.trim(),
      'veiculo': veiculo.trim(),
      'placa': placa.trim().toUpperCase(),
    });
    notifyListeners();
  }
}