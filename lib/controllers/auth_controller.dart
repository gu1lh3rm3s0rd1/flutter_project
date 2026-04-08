import 'package:flutter/material.dart';

class AuthController extends ChangeNotifier {
  bool _estaLogado = false;
  bool get estaLogado => _estaLogado;

  final List<Map<String, String>> _usuarios = [
    {
      'nome': 'Marina Costa',
      'email': 'marina@autoflow.com',
      'telefone': '(16) 99111-2233',
      'senha': '123456',
    },
  ];

  Future<bool> login(String email, String senha) async {
    final encontrado = _usuarios.any(
      (u) => u['email'] == email.trim() && u['senha'] == senha,
    );

    _estaLogado = encontrado;
    notifyListeners();
    return encontrado;
  }

  bool cadastrarUsuario({
    required String nome,
    required String email,
    required String telefone,
    required String senha,
  }) {
    final emailNormalizado = email.trim().toLowerCase();
    final emailExistente = _usuarios.any((u) => u['email'] == emailNormalizado);
    if (emailExistente) return false;

    _usuarios.add({
      'nome': nome.trim(),
      'email': emailNormalizado,
      'telefone': telefone.trim(),
      'senha': senha,
    });
    notifyListeners();
    return true;
  }

  Future<bool> recuperarSenha(String email) async {
    await Future.delayed(const Duration(milliseconds: 700));
    return _usuarios.any((u) => u['email'] == email.trim().toLowerCase());
  }

  void logout() {
    _estaLogado = false;
    notifyListeners();
  }
}