import 'package:flutter/material.dart';

class FinanceiroController extends ChangeNotifier {
  final List<Map<String, dynamic>> _despesas = [
    {'item': 'Compra de filtros', 'valor': 620.00, 'data': '04/04/2026'},
    {'item': 'Pagamento de eletricista', 'valor': 380.00, 'data': '02/04/2026'},
    {'item': 'Assinatura sistema fiscal', 'valor': 149.90, 'data': '01/04/2026'},
  ];

  double _receitas = 4830.00;

  List<Map<String, dynamic>> get despesas => List.unmodifiable(_despesas);
  double get receitas => _receitas;

  double get totalDespesas {
    return _despesas.fold<double>(0, (acumulado, item) {
      final valor = item['valor'] as double? ?? 0;
      return acumulado + valor;
    });
  }

  double get saldo => receitas - totalDespesas;

  void adicionarDespesa({
    required String item,
    required double valor,
    required String data,
  }) {
    _despesas.insert(0, {
      'item': item.trim(),
      'valor': valor,
      'data': data.trim(),
    });
    notifyListeners();
  }

  void atualizarReceitas(double novoValor) {
    _receitas = novoValor;
    notifyListeners();
  }
}