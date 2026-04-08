import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../controllers/cliente_controller.dart';

class ClientesVeiculosView extends StatelessWidget {
  const ClientesVeiculosView({super.key});

  @override
  Widget build(BuildContext context) {
    const Color primaryColor = Color(0xFF1E3A5F);
    final veiculos = context.watch<ClienteController>().veiculos;

    return Scaffold(
      appBar: AppBar(title: const Text("Clientes e Veiculos"), backgroundColor: primaryColor, foregroundColor: Colors.white),
      body: GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, crossAxisSpacing: 10, mainAxisSpacing: 10),
        itemCount: veiculos.length,
        itemBuilder: (context, index) {
          final item = veiculos[index];
          return Card(
            color: primaryColor.withValues(alpha: 0.05),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.directions_car, size: 40, color: primaryColor),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(item['veiculo']!, textAlign: TextAlign.center, style: const TextStyle(fontWeight: FontWeight.bold)),
                ),
                Text(item['cliente']!, style: const TextStyle(fontSize: 12, color: Colors.black54)),
                Text(item['placa']!, style: const TextStyle(fontSize: 12, color: Colors.black54)),
              ],
            ),
          );
        },
      ),
    );
  }
}