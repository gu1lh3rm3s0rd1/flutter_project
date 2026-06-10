import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

import 'app_environment.dart';

class OfficeAuthException implements Exception {
  final String message;

  OfficeAuthException(this.message);

  @override
  String toString() => message;
}

class _DemoUser {
  _DemoUser({
    required this.id,
    required this.nome,
    required this.email,
    required this.telefone,
    required this.senha,
  });

  final String id;
  String nome;
  final String email;
  String telefone;
  String senha;
}

class OfficeAuthService {
  OfficeAuthService._();

  static final OfficeAuthService instance = OfficeAuthService._();

  final Map<String, _DemoUser> _demoUsersByEmail = {
    'marina@autoflow.com': _DemoUser(
      id: 'demo-user',
      nome: 'Marina Costa',
      email: 'marina@autoflow.com',
      telefone: '(16) 99111-2233',
      senha: '123456',
    ),
  };

  _DemoUser? _currentDemoUser;

  bool get _firebaseReady => AppEnvironment.useFirebase && Firebase.apps.isNotEmpty;

  bool get isLoggedIn => _firebaseReady ? FirebaseAuth.instance.currentUser != null : _currentDemoUser != null;

  String? get currentUserId => _firebaseReady ? FirebaseAuth.instance.currentUser?.uid : _currentDemoUser?.id;

  String? get currentUserName => _firebaseReady
      ? FirebaseAuth.instance.currentUser?.displayName ?? FirebaseAuth.instance.currentUser?.email
      : _currentDemoUser?.nome;

  String? get currentUserEmail => _firebaseReady ? FirebaseAuth.instance.currentUser?.email : _currentDemoUser?.email;

  String? get currentUserPhone => _firebaseReady ? null : _currentDemoUser?.telefone;

  Future<void> login({required String email, required String password}) async {
    if (_firebaseReady) {
      try {
        await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email,
          password: password,
        );
        return;
      } on FirebaseAuthException catch (error) {
        throw OfficeAuthException(_readAuthError(error));
      }
    }

    await Future<void>.delayed(const Duration(milliseconds: 500));
    final demoUser = _demoUsersByEmail[email.trim().toLowerCase()];
    if (demoUser == null || demoUser.senha != password) {
      throw OfficeAuthException('Credenciais invalidas.');
    }
    _currentDemoUser = demoUser;
  }

  Future<void> register({
    required String nome,
    required String email,
    required String telefone,
    required String password,
  }) async {
    if (_firebaseReady) {
      try {
        final credential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );

        await credential.user?.updateDisplayName(nome.trim());
        await _saveUserProfile(
          uid: credential.user!.uid,
          nome: nome,
          email: email,
          telefone: telefone,
        );
        return;
      } on FirebaseAuthException catch (error) {
        throw OfficeAuthException(_readAuthError(error));
      }
    }

    await Future<void>.delayed(const Duration(milliseconds: 500));
    final normalizedEmail = email.trim().toLowerCase();
    if (_demoUsersByEmail.containsKey(normalizedEmail)) {
      throw OfficeAuthException('Este e-mail ja esta cadastrado.');
    }

    _demoUsersByEmail[normalizedEmail] = _DemoUser(
      id: 'demo-${DateTime.now().microsecondsSinceEpoch}',
      nome: nome.trim(),
      email: normalizedEmail,
      telefone: telefone.trim(),
      senha: password,
    );
  }

  Future<void> recoverPassword(String email) async {
    if (_firebaseReady) {
      try {
        await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
        return;
      } on FirebaseAuthException catch (error) {
        throw OfficeAuthException(_readAuthError(error));
      }
    }

    await Future<void>.delayed(const Duration(milliseconds: 500));
    final exists = _demoUsersByEmail.containsKey(email.trim().toLowerCase());
    if (!exists) {
      throw OfficeAuthException('Nao existe conta vinculada a este e-mail.');
    }
  }

  Future<void> logout() async {
    if (_firebaseReady) {
      await FirebaseAuth.instance.signOut();
      return;
    }

    _currentDemoUser = null;
  }

  Future<void> _saveUserProfile({
    required String uid,
    required String nome,
    required String email,
    required String telefone,
  }) async {
    await FirebaseFirestore.instance.collection('usuarios').doc(uid).set({
      'uid': uid,
      'nome': nome.trim(),
      'email': email.trim().toLowerCase(),
      'telefone': telefone.trim(),
      'createdAt': DateTime.now(),
      'updatedAt': DateTime.now(),
    }, SetOptions(merge: true));
  }

  String _readAuthError(FirebaseAuthException error) {
    switch (error.code) {
      case 'invalid-email':
        return 'E-mail invalido.';
      case 'user-not-found':
        return 'Usuario nao encontrado.';
      case 'wrong-password':
        return 'Senha incorreta.';
      case 'email-already-in-use':
        return 'Este e-mail ja esta cadastrado.';
      case 'weak-password':
        return 'A senha deve ter pelo menos 6 caracteres.';
      case 'network-request-failed':
        return 'Falha de rede ao comunicar com o Firebase.';
      default:
        return error.message ?? 'Nao foi possivel concluir a operacao.';
    }
  }
}