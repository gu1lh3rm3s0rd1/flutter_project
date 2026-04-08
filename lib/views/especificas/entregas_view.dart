import 'package:flutter/material.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/dialogs_helper.dart';

class EntregasView extends StatelessWidget {
  const EntregasView({super.key});

  @override
  Widget build(BuildContext context) {
    const Color primaryColor = Color(0xFF1E3A5F);

    final List<Map<String, String>> entregas = [
      {'ordem': 'OS-1018', 'cliente': 'Ana Martins', 'satisfacao': '5.0/5'},
      {'ordem': 'OS-1019', 'cliente': 'Lucas Pereira', 'satisfacao': '4.8/5'},
      {'ordem': 'OS-1020', 'cliente': 'Sandra Melo', 'satisfacao': '4.9/5'},
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text("Entregas e Pos-venda"),
      ),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: primaryColor,
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Indice de satisfacao da oficina",
                  style: TextStyle(color: Colors.white70, fontSize: 14),
                ),
                SizedBox(height: 5),
                Text(
                  "4.9 / 5.0",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),

          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Entregas recentes",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: primaryColor),
              ),
            ),
          ),

          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: entregas.length,
              itemBuilder: (context, index) {
                final item = entregas[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: ListTile(
                    leading: const Icon(Icons.check_circle, color: Colors.green),
                    title: Text(item['ordem']!, style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text(item['cliente']!),
                    trailing: Text(
                      item['satisfacao']!,
                      style: const TextStyle(fontWeight: FontWeight.bold, color: primaryColor),
                    ),
                  ),
                );
              },
            ),
          ),
        
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: CustomButton(
              texto: "Registrar entrega",
              onPressed: () {
                DialogsHelper.showAlert(
                  context,
                  'Registro rapido',
                  'Fluxo de confirmacao de entrega aberto.',
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}