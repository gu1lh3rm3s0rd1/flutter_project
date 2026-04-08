import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../controllers/insumo_controller.dart';

class EstoquePecasView extends StatelessWidget {
  const EstoquePecasView({super.key});

  @override
  Widget build(BuildContext context) {
    const Color primaryColor = Color(0xFF1E3A5F);
    final estoque = context.watch<InsumoController>().estoque;

    return Scaffold(
      appBar: AppBar(title: const Text("Estoque de Pecas")),
      body: ListView.separated(
        itemCount: estoque.length,
        separatorBuilder: (context, index) => const Divider(),
        itemBuilder: (context, index) {
          final item = estoque[index];
          return ListTile(
            leading: const Icon(Icons.inventory_2, color: primaryColor),
            title: Text(item['nome'] as String),
            subtitle: Text('Unidade: ${item['unidade']}'),
            trailing: Text(
              '${item['quantidade']} ${item['unidade']}',
              style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.blueGrey),
            ),
            onTap: () {
              context.read<InsumoController>().baixarEstoque(index, 1);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('1 unidade baixada de ${item['nome']}')),
              );
            },
          );
        },
      ),
    );
  }
}