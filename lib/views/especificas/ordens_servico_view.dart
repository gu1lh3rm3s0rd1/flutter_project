import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../controllers/auth_controller.dart';
import '../../models/ordem_servico_record.dart';
import '../../services/office_data_service.dart';
import '../../widgets/dialogs_helper.dart';

class OrdensServicoView extends StatefulWidget {
  const OrdensServicoView({super.key});

  @override
  State<OrdensServicoView> createState() => _OrdensServicoViewState();
}

class _OrdensServicoViewState extends State<OrdensServicoView> {
  final OfficeDataService _dataService = OfficeDataService.instance;

  Future<void> _abrirFormulario({OrdemServicoRecord? existing}) async {
    final auth = context.read<AuthController>();
    final userId = auth.userId;
    if (userId == null) {
      DialogsHelper.showSnackBar(context, 'Faça login novamente para continuar.');
      return;
    }

    final formKey = GlobalKey<FormState>();
    final clienteController = TextEditingController(text: existing?.cliente ?? '');
    final telefoneController = TextEditingController(text: existing?.telefone ?? '');
    final veiculoController = TextEditingController(text: existing?.veiculo ?? '');
    final placaController = TextEditingController(text: existing?.placa ?? '');
    final servicoController = TextEditingController(text: existing?.servico ?? '');
    final observacaoController = TextEditingController(text: existing?.observacao ?? '');
    final valorController = TextEditingController(
      text: existing == null ? '' : existing.valor.toStringAsFixed(2).replaceAll('.', ','),
    );
    String statusSelecionado = existing?.status ?? 'Recebido';

    final saved = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (sheetContext) {
        return StatefulBuilder(
          builder: (context, setSheetState) {
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
                        existing == null ? 'Nova ordem de servico' : 'Editar ordem de servico',
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: clienteController,
                        decoration: const InputDecoration(labelText: 'Cliente', border: OutlineInputBorder()),
                        validator: (value) => value == null || value.isEmpty ? 'Informe o cliente' : null,
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
                        controller: servicoController,
                        decoration: const InputDecoration(labelText: 'Servico', border: OutlineInputBorder()),
                        validator: (value) => value == null || value.isEmpty ? 'Informe o serviço' : null,
                      ),
                      const SizedBox(height: 12),
                      DropdownButtonFormField<String>(
                        initialValue: statusSelecionado,
                        decoration: const InputDecoration(border: OutlineInputBorder(), labelText: 'Status'),
                        items: const [
                          DropdownMenuItem(value: 'Recebido', child: Text('Recebido')),
                          DropdownMenuItem(value: 'Em execucao', child: Text('Em execução')),
                          DropdownMenuItem(value: 'Aguardando peca', child: Text('Aguardando peça')),
                          DropdownMenuItem(value: 'Concluido', child: Text('Concluído')),
                        ],
                        onChanged: (value) {
                          if (value == null) return;
                          setSheetState(() => statusSelecionado = value);
                        },
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: valorController,
                        decoration: const InputDecoration(labelText: 'Valor', border: OutlineInputBorder()),
                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                        validator: (value) => value == null || value.isEmpty ? 'Informe o valor' : null,
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

                            final parsedValue = _parseValor(valorController.text);
                            final record = existing == null
                                ? OrdemServicoRecord.create(
                                    userId: userId,
                                    cliente: clienteController.text,
                                    telefone: telefoneController.text,
                                    veiculo: veiculoController.text,
                                    placa: placaController.text,
                                    servico: servicoController.text,
                                    status: statusSelecionado,
                                    valor: parsedValue,
                                    observacao: observacaoController.text,
                                    dataEntrada: DateTime.now(),
                                    dataPrevista: DateTime.now().add(const Duration(days: 3)),
                                  )
                                : existing.copyWith(
                                    cliente: clienteController.text.trim(),
                                    telefone: telefoneController.text.trim(),
                                    veiculo: veiculoController.text.trim(),
                                    placa: placaController.text.trim().toUpperCase(),
                                    servico: servicoController.text.trim(),
                                    status: statusSelecionado,
                                    valor: parsedValue,
                                    observacao: observacaoController.text.trim(),
                                    updatedAt: DateTime.now(),
                                  );

                            try {
                              await _dataService.saveOrdem(record);
                              if (sheetContext.mounted) {
                                Navigator.pop(sheetContext, true);
                              }
                            } catch (_) {
                              if (sheetContext.mounted) {
                                DialogsHelper.showSnackBar(sheetContext, 'Nao foi possivel salvar a ordem.');
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
      },
    );

    if (!mounted || saved != true) {
      return;
    }

    DialogsHelper.showSnackBar(
      context,
      existing == null ? 'Ordem inserida com sucesso.' : 'Ordem atualizada com sucesso.',
    );
  }

  Future<void> _excluirOrdem(OrdemServicoRecord record) async {
    final auth = context.read<AuthController>();
    final userId = auth.userId;
    if (userId == null) return;

    await _dataService.deleteOrdem(record.id, userId);
    if (!mounted) return;
    DialogsHelper.showSnackBar(context, 'Ordem removida.');
  }

  double _parseValor(String raw) {
    final text = raw.trim();
    if (text.contains(',') && text.contains('.')) {
      return double.tryParse(text.replaceAll('.', '').replaceAll(',', '.')) ?? 0;
    }
    return double.tryParse(text.replaceAll(',', '.')) ?? 0;
  }

  @override
  Widget build(BuildContext context) {
    const Color primaryColor = Color(0xFF1E3A5F);
    final userId = context.watch<AuthController>().userId;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Ordens de Servico'),
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
      ),
      body: userId == null
          ? const Center(child: Text('Faça login para acessar os dados.'))
          : StreamBuilder<List<OrdemServicoRecord>>(
              stream: _dataService.watchOrdens(userId),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return const Center(child: Text('Falha ao carregar ordens.'));
                }

                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }

                final ordens = snapshot.data!;
                if (ordens.isEmpty) {
                  return const Center(child: Text('Nenhuma ordem cadastrada ainda.'));
                }

                return ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: ordens.length,
                  separatorBuilder: (context, index) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final ordem = ordens[index];

                    return Card(
                      elevation: 2,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: primaryColor.withValues(alpha: 0.1),
                          child: const Icon(Icons.build, color: primaryColor),
                        ),
                        title: Text(
                          ordem.codigo,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Padding(
                          padding: const EdgeInsets.only(top: 6.0),
                          child: Text(
                            '${ordem.cliente} • ${ordem.veiculo}\n${ordem.servico}\n${ordem.status} • R\$ ${ordem.valor.toStringAsFixed(2)}',
                          ),
                        ),
                        isThreeLine: true,
                        trailing: PopupMenuButton<String>(
                          onSelected: (value) {
                            if (value == 'edit') {
                              _abrirFormulario(existing: ordem);
                            } else if (value == 'delete') {
                              _excluirOrdem(ordem);
                            }
                          },
                          itemBuilder: (context) => const [
                            PopupMenuItem(value: 'edit', child: Text('Editar')),
                            PopupMenuItem(value: 'delete', child: Text('Excluir')),
                          ],
                        ),
                        onTap: () {
                          DialogsHelper.showSnackBar(
                            context,
                            'Entrada: ${_formatDate(ordem.dataEntrada)} | Previsão: ${_formatDate(ordem.dataPrevista)}',
                          );
                        },
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
        label: const Text('Nova ordem', style: TextStyle(color: Colors.white)),
      ),
    );
  }


  String _formatDate(DateTime date) {
    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');
    return '$day/$month/${date.year}';
  }
}