import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../controllers/auth_controller.dart';
import '../../models/ordem_servico_record.dart';
import '../../services/office_data_service.dart';

class PesquisaOrdensView extends StatefulWidget {
  const PesquisaOrdensView({super.key});

  @override
  State<PesquisaOrdensView> createState() => _PesquisaOrdensViewState();
}

class _PesquisaOrdensViewState extends State<PesquisaOrdensView> {
  final TextEditingController _searchController = TextEditingController();
  String _sortKey = 'recentes';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const Color primaryColor = Color(0xFF1E3A5F);
    final userId = context.watch<AuthController>().userId;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Pesquisa de Ordens'),
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
      ),
      body: userId == null
          ? const Center(child: Text('Faça login para pesquisar dados.'))
          : Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  TextField(
                    controller: _searchController,
                    onChanged: (_) => setState(() {}),
                    decoration: InputDecoration(
                      labelText: 'Pesquisar ordem',
                      border: const OutlineInputBorder(),
                      prefixIcon: const Icon(Icons.search),
                      suffixIcon: _searchController.text.isEmpty
                          ? null
                          : IconButton(
                              onPressed: () {
                                _searchController.clear();
                                setState(() {});
                              },
                              icon: const Icon(Icons.clear),
                            ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<String>(
                    initialValue: _sortKey,
                    decoration: const InputDecoration(border: OutlineInputBorder(), labelText: 'Ordenar por'),
                    items: const [
                      DropdownMenuItem(value: 'recentes', child: Text('Mais recentes')),
                      DropdownMenuItem(value: 'alfabetica', child: Text('Ordem alfabética')),
                      DropdownMenuItem(value: 'valor', child: Text('Maior valor')),
                    ],
                    onChanged: (value) {
                      if (value == null) return;
                      setState(() => _sortKey = value);
                    },
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: StreamBuilder<List<OrdemServicoRecord>>(
                      stream: OfficeDataService.instance.watchOrdens(userId),
                      builder: (context, snapshot) {
                        if (snapshot.hasError) {
                          return const Center(child: Text('Falha ao pesquisar ordens.'));
                        }

                        if (!snapshot.hasData) {
                          return const Center(child: CircularProgressIndicator());
                        }

                        final query = _searchController.text.trim().toLowerCase();
                        final ordens = snapshot.data!
                            .where((item) {
                              if (query.isEmpty) return true;
                              return [
                                item.codigo,
                                item.cliente,
                                item.veiculo,
                                item.placa,
                                item.servico,
                                item.status,
                              ].any((field) => field.toLowerCase().contains(query));
                            })
                            .toList();

                        ordens.sort((a, b) {
                          switch (_sortKey) {
                            case 'alfabetica':
                              return a.cliente.toLowerCase().compareTo(b.cliente.toLowerCase());
                            case 'valor':
                              return b.valor.compareTo(a.valor);
                            default:
                              return b.updatedAt.compareTo(a.updatedAt);
                          }
                        });

                        if (ordens.isEmpty) {
                          return const Center(child: Text('Nenhum resultado encontrado.'));
                        }

                        return ListView.separated(
                          itemCount: ordens.length,
                          separatorBuilder: (context, index) => const SizedBox(height: 12),
                          itemBuilder: (context, index) {
                            final ordem = ordens[index];
                            return Card(
                              child: ListTile(
                                title: Text(ordem.codigo, style: const TextStyle(fontWeight: FontWeight.bold)),
                                subtitle: Text('${ordem.cliente} • ${ordem.servico}\n${ordem.status}'),
                                isThreeLine: true,
                                trailing: Text('R\$ ${ordem.valor.toStringAsFixed(2)}'),
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}