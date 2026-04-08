import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../controllers/os_controller.dart';

class CadastroOSView extends StatefulWidget {
  const CadastroOSView({super.key});

  @override
  State<CadastroOSView> createState() => _CadastroOSViewState();
}

class _CadastroOSViewState extends State<CadastroOSView> {
  final _formKey = GlobalKey<FormState>();
  final _veiculoController = TextEditingController();
  final _servicoController = TextEditingController();
  final _valorController = TextEditingController();

  void _salvarOrdem() {
    if (_formKey.currentState!.validate()) {
      context.read<OSController>().cadastrarOrdem(
        veiculo: _veiculoController.text,
        servico: _servicoController.text,
        valor: _valorController.text,
      );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Ordem registrada com sucesso.'),
          backgroundColor: Color(0xFF1E3A5F),
        ),
      );
      Navigator.pop(context);
    }
  }

  @override
  void dispose() {
    _veiculoController.dispose();
    _servicoController.dispose();
    _valorController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Nova Ordem de Servico")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _veiculoController,
                decoration: const InputDecoration(labelText: 'Veiculo', border: OutlineInputBorder()),
                validator: (v) => (v == null || v.isEmpty) ? 'Informe o veiculo' : null,
              ),
              const SizedBox(height: 15),
              TextFormField(
                controller: _servicoController,
                decoration: const InputDecoration(labelText: 'Servico solicitado', border: OutlineInputBorder()),
                validator: (v) => (v == null || v.isEmpty) ? 'Informe o servico' : null,
              ),
              const SizedBox(height: 15),
              TextFormField(
                controller: _valorController,
                decoration: const InputDecoration(labelText: 'Valor estimado (ex: 450,00)', border: OutlineInputBorder()),
                keyboardType: TextInputType.number,
                validator: (v) => (v == null || v.isEmpty) ? 'Informe o valor estimado' : null,
              ),
              const SizedBox(height: 25),
              ElevatedButton(
                onPressed: _salvarOrdem,
                style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF1E3A5F), minimumSize: const Size(double.infinity, 50)),
                child: const Text("Salvar Ordem", style: TextStyle(color: Colors.white)),
              )
            ],
          ),
        ),
      ),
    );
  }
}