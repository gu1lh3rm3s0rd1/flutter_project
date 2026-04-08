import 'package:flutter/material.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    const Color primaryColor = Color(0xFF1E3A5F);

    final List<Map<String, dynamic>> modulos = [
      {'titulo': 'Clientes e Veiculos', 'icon': Icons.directions_car, 'route': '/clientes'},
      {'titulo': 'Ordens de Servico', 'icon': Icons.assignment, 'route': '/ordens-servico'},
      {'titulo': 'Estoque de Pecas', 'icon': Icons.inventory, 'route': '/estoque'},
      {'titulo': 'Financeiro', 'icon': Icons.payments, 'route': '/financeiro'},
      {'titulo': 'Entregas', 'icon': Icons.local_shipping, 'route': '/entregas'},
      {'titulo': 'Sobre', 'icon': Icons.info, 'route': '/sobre'},
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text("Painel da Oficina"),
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.exit_to_app),
            onPressed: () => Navigator.pushReplacementNamed(context, '/'),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, // 2 colunas
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
          ),
          itemCount: modulos.length,
          itemBuilder: (context, index) {
            return InkWell(
              onTap: () => Navigator.pushNamed(context, modulos[index]['route']),
              child: Card(
                elevation: 4,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(modulos[index]['icon'], size: 50, color: primaryColor),
                    const SizedBox(height: 10),
                    Text(modulos[index]['titulo'], style: const TextStyle(fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}