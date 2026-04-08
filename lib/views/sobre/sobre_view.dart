import 'package:flutter/material.dart';

class SobreView extends StatelessWidget {
  const SobreView({super.key});

  @override
  Widget build(BuildContext context) {
    const Color primaryColor = Color(0xFF1E3A5F);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Sobre o Aplicativo"),
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Center(
              child: Icon(
                Icons.info_outline,
                size: 80,
                color: primaryColor,
              ),
            ),
            const SizedBox(height: 24),
            
            
            const Text(
              "Objetivo",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: primaryColor),
            ),
            const SizedBox(height: 8),
            const Text(
              "O AutoFlow foi desenhado para apoiar oficinas mecanicas no controle de clientes, "
              "veiculos, ordens de servico, estoque e acompanhamento de entregas.",
              style: TextStyle(fontSize: 16),
            ),
            
            const Divider(height: 40),

            
            const Text(
              "Equipe de Desenvolvimento",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: primaryColor),
            ),
            const SizedBox(height: 8),
            const Text("• Guilherme Benjamim Sordi", style: TextStyle(fontSize: 16)),
            
            const SizedBox(height: 24),
            
            const Text(
              "Informações Institucionais",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: primaryColor),
            ),
            const SizedBox(height: 12),
            
            Table(
              columnWidths: const {
                0: FlexColumnWidth(1),
                1: FlexColumnWidth(2),
              },
              children: const [
                TableRow(children: [
                  Padding(padding: EdgeInsets.symmetric(vertical: 4), child: Text("Instituição:", style: TextStyle(fontWeight: FontWeight.bold))),
                  Padding(padding: EdgeInsets.symmetric(vertical: 4), child: Text("UNAERP - Universidade de Ribeirão Preto")),
                ]),
                TableRow(children: [
                  Padding(padding: EdgeInsets.symmetric(vertical: 4), child: Text("Professor:", style: TextStyle(fontWeight: FontWeight.bold))),
                  Padding(padding: EdgeInsets.symmetric(vertical: 4), child: Text("Rodrigo de Oliveira Plotze")),
                ]),
                TableRow(children: [
                  Padding(padding: EdgeInsets.symmetric(vertical: 4), child: Text("Curso:", style: TextStyle(fontWeight: FontWeight.bold))),
                  Padding(padding: EdgeInsets.symmetric(vertical: 4), child: Text("Engenharia de Software (7ª Etapa)")),
                ]),
                TableRow(children: [
                  Padding(padding: EdgeInsets.symmetric(vertical: 4), child: Text("Versão:", style: TextStyle(fontWeight: FontWeight.bold))),
                  Padding(padding: EdgeInsets.symmetric(vertical: 4), child: Text("1.0.0")),
                ]),
              ],
            ),
            
            const SizedBox(height: 40),
            const Center(
              child: Text(
                "Ribeirão Preto, 2026",
                style: TextStyle(color: Colors.grey),
              ),
            ),
          ],
        ),
      ),
    );
  }
}