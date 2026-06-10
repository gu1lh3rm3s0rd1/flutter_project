import 'package:flutter/material.dart';

import '../services/office_auth_service.dart';

class AuthController extends ChangeNotifier {
  final OfficeAuthService _service = OfficeAuthService.instance;

  bool _isLoading = false;
  String? _errorMessage;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get estaLogado => _service.isLoggedIn;
  String? get userId => _service.currentUserId;
  String? get nomeUsuario => _service.currentUserName;
  String? get emailUsuario => _service.currentUserEmail;
  String? get telefoneUsuario => _service.currentUserPhone;

  Future<bool> login(String email, String senha) async {
    _setLoading(true);
    try {
      await _service.login(email: email.trim().toLowerCase(), password: senha);
      _errorMessage = null;
      return true;
    } on OfficeAuthException catch (error) {
      _errorMessage = error.message;
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> cadastrarUsuario({
    required String nome,
    required String email,
    required String telefone,
    required String senha,
  }) async {
    _setLoading(true);
    try {
      await _service.register(
        nome: nome,
        email: email,
        telefone: telefone,
        password: senha,
      );
      _errorMessage = null;
      return true;
    } on OfficeAuthException catch (error) {
      _errorMessage = error.message;
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> recuperarSenha(String email) async {
    _setLoading(true);
    try {
      await _service.recoverPassword(email.trim().toLowerCase());
      _errorMessage = null;
      return true;
    } on OfficeAuthException catch (error) {
      _errorMessage = error.message;
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<void> logout() async {
    await _service.logout();
    _errorMessage = null;
    notifyListeners();
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
}