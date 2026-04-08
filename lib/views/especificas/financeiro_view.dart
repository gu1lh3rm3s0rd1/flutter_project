import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../controllers/financeiro_controller.dart';

class FinanceiroView extends StatelessWidget {
  const FinanceiroView({super.key});

  String _currency(double value) {
    final fixed = value.toStringAsFixed(2);
    return fixed.replaceAll('.', ',');
  }

  @override
  Widget build(BuildContext context) {
    final financeiro = context.watch<FinanceiroController>();
    final despesas = financeiro.despesas;
    final totalDespesas = _currency(financeiro.totalDespesas);
    final receitas = _currency(financeiro.receitas);
    final saldo = _currency(financeiro.saldo);

    return Scaffold(
      appBar: AppBar(title: const Text("Financeiro da Oficina")),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            color: const Color(0xFF1E3A5F).withValues(alpha: 0.1),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Total do Mês:", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                Text(
                  'R\$ $totalDespesas',
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.red),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Receitas: R\$ $receitas', style: const TextStyle(color: Colors.green)),
                Text('Saldo: R\$ $saldo', style: const TextStyle(fontWeight: FontWeight.bold)),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: despesas.length,
              itemBuilder: (context, index) {
                final despesa = despesas[index];
                final valor = _currency((despesa['valor'] as num).toDouble());

                return ListTile(
                  title: Text(despesa['item'] as String),
                  subtitle: Text(despesa['data'] as String),
                  trailing: Text('R\$ $valor', style: const TextStyle(color: Colors.red)),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}