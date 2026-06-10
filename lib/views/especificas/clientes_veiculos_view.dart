import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../controllers/auth_controller.dart';
import '../../models/cliente_veiculo_record.dart';
import '../../services/office_data_service.dart';
import '../../widgets/dialogs_helper.dart';

class ClientesVeiculosView extends StatefulWidget {
  const ClientesVeiculosView({super.key});

  @override
  State<ClientesVeiculosView> createState() => _ClientesVeiculosViewState();
}

class _ClientesVeiculosViewState extends State<ClientesVeiculosView> {
  final OfficeDataService _dataService = OfficeDataService.instance;

  Future<void> _abrirFormulario({ClienteVeiculoRecord? existing}) async {
    final auth = context.read<AuthController>();
    final userId = auth.userId;
    if (userId == null) {
      DialogsHelper.showSnackBar(context, 'Faça login novamente para continuar.');
      return;
    }

    final formKey = GlobalKey<FormState>();
    final nomeController = TextEditingController(text: existing?.nome ?? '');
    final telefoneController = TextEditingController(text: existing?.telefone ?? '');
    final emailController = TextEditingController(text: existing?.email ?? '');
    final veiculoController = TextEditingController(text: existing?.veiculo ?? '');
    final placaController = TextEditingController(text: existing?.placa ?? '');
    final observacaoController = TextEditingController(text: existing?.observacao ?? '');

    final saved = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (sheetContext) {
        return Padding(
          padding: EdgeInsets.only(
            left: 20,
            right: 20,
            top: 20,
            bottom: MediaQuery.of(sheetContext).viewInsets.bottom + 20,
          ),
          child: Form(
            key: formKey,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    existing == null ? 'Novo cliente e veiculo' : 'Editar cliente e veiculo',
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: nomeController,
                    decoration: const InputDecoration(labelText: 'Nome do cliente', border: OutlineInputBorder()),
                    validator: (value) => value == null || value.isEmpty ? 'Informe o nome' : null,
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: telefoneController,
                    decoration: const InputDecoration(labelText: 'Telefone', border: OutlineInputBorder()),
                    keyboardType: TextInputType.phone,
                    validator: (value) => value == null || value.isEmpty ? 'Informe o telefone' : null,
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: emailController,
                    decoration: const InputDecoration(labelText: 'E-mail', border: OutlineInputBorder()),
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) => value == null || !value.contains('@') ? 'E-mail inválido' : null,
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: veiculoController,
                    decoration: const InputDecoration(labelText: 'Veiculo', border: OutlineInputBorder()),
                    validator: (value) => value == null || value.isEmpty ? 'Informe o veículo' : null,
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: placaController,
                    decoration: const InputDecoration(labelText: 'Placa', border: OutlineInputBorder()),
                    textCapitalization: TextCapitalization.characters,
                    validator: (value) => value == null || value.isEmpty ? 'Informe a placa' : null,
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: observacaoController,
                    decoration: const InputDecoration(labelText: 'Observacao', border: OutlineInputBorder()),
                    maxLines: 3,
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () async {
                        if (!formKey.currentState!.validate()) {
                          return;
                        }

                        final record = existing == null
                            ? ClienteVeiculoRecord.create(
                                userId: userId,
                                nome: nomeController.text,
                                telefone: telefoneController.text,
                                email: emailController.text,
                                veiculo: veiculoController.text,
                                placa: placaController.text,
                                observacao: observacaoController.text,
                              )
                            : existing.copyWith(
                                nome: nomeController.text.trim(),
                                telefone: telefoneController.text.trim(),
                                email: emailController.text.trim().toLowerCase(),
                                veiculo: veiculoController.text.trim(),
                                placa: placaController.text.trim().toUpperCase(),
                                observacao: observacaoController.text.trim(),
                                updatedAt: DateTime.now(),
                              );

                        try {
                          await _dataService.saveCliente(record);
                          if (sheetContext.mounted) {
                            Navigator.pop(sheetContext, true);
                          }
                        } catch (_) {
                          if (sheetContext.mounted) {
                            DialogsHelper.showSnackBar(sheetContext, 'Nao foi possivel salvar o cliente.');
                          }
                        }
                      },
                      child: Text(existing == null ? 'Salvar' : 'Atualizar'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );

    if (!mounted || saved != true) {
      return;
    }

    DialogsHelper.showSnackBar(
      context,
      existing == null ? 'Cliente inserido com sucesso.' : 'Cliente atualizado com sucesso.',
    );
  }

  Future<void> _excluirCliente(ClienteVeiculoRecord record) async {
    final auth = context.read<AuthController>();
    final userId = auth.userId;
    if (userId == null) return;

    await _dataService.deleteCliente(record.id, userId);
    if (!mounted) return;
    DialogsHelper.showSnackBar(context, 'Cliente removido.');
  }

  @override
  Widget build(BuildContext context) {
    const Color primaryColor = Color(0xFF1E3A5F);
    final userId = context.watch<AuthController>().userId;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Clientes e Veiculos'),
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
      ),
      body: userId == null
          ? const Center(child: Text('Faça login para acessar os dados.'))
          : StreamBuilder<List<ClienteVeiculoRecord>>(
              stream: _dataService.watchClientes(userId),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return const Center(child: Text('Falha ao carregar clientes.'));
                }

                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }

                final itens = snapshot.data!;
                if (itens.isEmpty) {
                  return const Center(child: Text('Nenhum cliente cadastrado ainda.'));
                }

                return ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: itens.length,
                  separatorBuilder: (context, index) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final item = itens[index];
                    return Card(
                      elevation: 2,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: primaryColor.withValues(alpha: 0.1),
                          child: const Icon(Icons.directions_car, color: primaryColor),
                        ),
                        title: Text(item.nome, style: const TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: Padding(
                          padding: const EdgeInsets.only(top: 6.0),
                          child: Text(
                            '${item.veiculo}\n${item.telefone} • ${item.placa}\n${item.email}',
                          ),
                        ),
                        isThreeLine: true,
                        trailing: PopupMenuButton<String>(
                          onSelected: (value) {
                            if (value == 'edit') {
                              _abrirFormulario(existing: item);
                            } else if (value == 'delete') {
                              _excluirCliente(item);
                            }
                          },
                          itemBuilder: (context) => const [
                            PopupMenuItem(value: 'edit', child: Text('Editar')),
                            PopupMenuItem(value: 'delete', child: Text('Excluir')),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _abrirFormulario(),
        backgroundColor: primaryColor,
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text('Novo cliente', style: TextStyle(color: Colors.white)),
      ),
    );
  }
}