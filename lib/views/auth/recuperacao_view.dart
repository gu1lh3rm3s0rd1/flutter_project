import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../controllers/auth_controller.dart';

class RecuperacaoView extends StatefulWidget {
  const RecuperacaoView({super.key});

  @override
  State<RecuperacaoView> createState() => _RecuperacaoViewState();
}

class _RecuperacaoViewState extends State<RecuperacaoView> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();

  Future<void> _recuperarSenha() async {
    if (_formKey.currentState!.validate()) {
      final auth = context.read<AuthController>();
      final encontrado = await auth.recuperarSenha(_emailController.text.trim().toLowerCase());
      if (!mounted) return;

      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(encontrado ? 'Recuperacao iniciada' : 'Conta nao encontrada'),
          content: Text(
            encontrado
                ? 'Instrucoes de redefinicao foram enviadas para ${_emailController.text}.'
                : 'Nao existe conta vinculada a este e-mail.',
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text("OK"))
          ],
        ),
      );
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Recuperar acesso")),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              const Text('Informe o e-mail cadastrado para receber as instrucoes de recuperacao.'),
              const SizedBox(height: 20),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: 'E-mail', border: OutlineInputBorder()),
                validator: (v) => (v == null || !v.contains('@')) ? 'E-mail invalido' : null,
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _recuperarSenha,
                  style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF1E3A5F), foregroundColor: Colors.white),
                  child: const Text("Enviar instrucoes"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}