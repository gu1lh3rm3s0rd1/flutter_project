import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../controllers/os_controller.dart';

class OrdensServicoView extends StatelessWidget {
  const OrdensServicoView({super.key});

  @override
  Widget build(BuildContext context) {
    const Color primaryColor = Color(0xFF1E3A5F);
    final ordens = context.watch<OSController>().ordens;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Ordens de Servico"),
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(12.0),
        itemCount: ordens.length,
        itemBuilder: (context, index) {
          final ordem = ordens[index];

          return Card(
            elevation: 3,
            margin: const EdgeInsets.symmetric(vertical: 8),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: primaryColor.withValues(alpha: 0.1),
                child: const Icon(Icons.build, color: primaryColor),
              ),
              title: Text(
                ordem['codigo']!,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text('${ordem['veiculo']} - ${ordem['servico']}'),
              trailing: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: _getStatusColor(ordem['status']!).withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  ordem['status']!,
                  style: TextStyle(
                    color: _getStatusColor(ordem['status']!),
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Valor previsto: ${ordem['valor']}'),
                    duration: const Duration(seconds: 1),
                  ),
                );
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.pushNamed(context, '/cadastro-os'),
        backgroundColor: primaryColor,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }


  Color _getStatusColor(String status) {
    switch (status) {
      case 'Concluido':
        return Colors.green;
      case 'Em execucao':
        return Colors.blue;
      case 'Aguardando peca':
        return Colors.deepOrange;
      default:
        return Colors.grey;
    }
  }
}