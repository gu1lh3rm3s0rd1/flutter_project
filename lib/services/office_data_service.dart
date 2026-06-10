import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

import '../models/cliente_veiculo_record.dart';
import '../models/ordem_servico_record.dart';
import 'app_environment.dart';

class OfficeDataService {
  OfficeDataService._();

  static final OfficeDataService instance = OfficeDataService._();

  final Map<String, List<ClienteVeiculoRecord>> _clientesPorUsuario = {
    'demo-user': [
      ClienteVeiculoRecord.create(
        id: 'cliente-demo-1',
        userId: 'demo-user',
        nome: 'Ana Martins',
        telefone: '(16) 99111-1122',
        email: 'ana@exemplo.com',
        veiculo: 'Honda Fit 2019',
        placa: 'FZT-4821',
        observacao: 'Cliente com manutencao preventiva em dia.',
      ),
      ClienteVeiculoRecord.create(
        id: 'cliente-demo-2',
        userId: 'demo-user',
        nome: 'Carlos Reis',
        telefone: '(16) 98888-7788',
        email: 'carlos@exemplo.com',
        veiculo: 'Onix 1.0 Turbo',
        placa: 'MOP-7783',
        observacao: 'Veiculo em acompanhamento de garantia.',
      ),
    ],
  };

  final Map<String, List<OrdemServicoRecord>> _ordensPorUsuario = {
    'demo-user': [
      OrdemServicoRecord.create(
        id: 'ordem-demo-1',
        userId: 'demo-user',
        codigo: 'OS-1024',
        cliente: 'Ana Martins',
        telefone: '(16) 99111-1122',
        veiculo: 'Honda Fit 2019',
        placa: 'FZT-4821',
        servico: 'Troca de pastilhas',
        status: 'Em execucao',
        valor: 420,
        observacao: 'Revisar fluido de freio na entrega.',
        dataEntrada: DateTime.now().subtract(const Duration(days: 2)),
        dataPrevista: DateTime.now().add(const Duration(days: 1)),
      ),
      OrdemServicoRecord.create(
        id: 'ordem-demo-2',
        userId: 'demo-user',
        codigo: 'OS-1025',
        cliente: 'Carlos Reis',
        telefone: '(16) 98888-7788',
        veiculo: 'Onix 1.0 Turbo',
        placa: 'MOP-7783',
        servico: 'Revisao de 40.000 km',
        status: 'Aguardando peca',
        valor: 890,
        observacao: 'Aguardar chegada do filtro original.',
        dataEntrada: DateTime.now().subtract(const Duration(days: 1)),
        dataPrevista: DateTime.now().add(const Duration(days: 3)),
      ),
    ],
  };

  final StreamController<void> _changes = StreamController<void>.broadcast();

  bool get _firebaseReady => AppEnvironment.useFirebase && Firebase.apps.isNotEmpty;

  Stream<List<ClienteVeiculoRecord>> watchClientes(String userId) {
    if (_firebaseReady) {
      return FirebaseFirestore.instance
          .collection('clientes_veiculos')
          .where('userId', isEqualTo: userId)
          .snapshots()
          .map((snapshot) {
            final items = snapshot.docs
                .map((doc) => ClienteVeiculoRecord.fromMap(doc.data(), doc.id))
                .toList();
            items.sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
            return items;
          });
    }

    return Stream<List<ClienteVeiculoRecord>>.multi((controller) {
      void emit() {
        final items = List<ClienteVeiculoRecord>.from(_clientesPorUsuario[userId] ?? []);
        items.sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
        controller.add(items);
      }

      emit();
      final subscription = _changes.stream.listen((_) => emit());
      controller.onCancel = () => subscription.cancel();
    });
  }

  Stream<List<OrdemServicoRecord>> watchOrdens(String userId) {
    if (_firebaseReady) {
      return FirebaseFirestore.instance
          .collection('ordens_servico')
          .where('userId', isEqualTo: userId)
          .snapshots()
          .map((snapshot) {
            final items = snapshot.docs
                .map((doc) => OrdemServicoRecord.fromMap(doc.data(), doc.id))
                .toList();
            items.sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
            return items;
          });
    }

    return Stream<List<OrdemServicoRecord>>.multi((controller) {
      void emit() {
        final items = List<OrdemServicoRecord>.from(_ordensPorUsuario[userId] ?? []);
        items.sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
        controller.add(items);
      }

      emit();
      final subscription = _changes.stream.listen((_) => emit());
      controller.onCancel = () => subscription.cancel();
    });
  }

  Future<void> saveCliente(ClienteVeiculoRecord record) async {
    final now = DateTime.now();
    final item = record.copyWith(updatedAt: now);

    if (_firebaseReady) {
      final collection = FirebaseFirestore.instance.collection('clientes_veiculos');
      if (record.id.isEmpty) {
        await collection.add(item.copyWith(createdAt: now).toMap());
      } else {
        await collection.doc(record.id).set(item.toMap(), SetOptions(merge: true));
      }
      return;
    }

    final items = _clientesPorUsuario.putIfAbsent(record.userId, () => []);
    final index = items.indexWhere((element) => element.id == record.id && record.id.isNotEmpty);
    final saved = record.id.isEmpty ? item.copyWith(id: _newId('cliente')) : item;

    if (index >= 0) {
      items[index] = saved;
    } else {
      items.insert(0, saved);
    }

    _changes.add(null);
  }

  Future<void> saveOrdem(OrdemServicoRecord record) async {
    final now = DateTime.now();
    final codigo = record.codigo.isEmpty ? _nextCodigoOrdem(record.userId) : record.codigo;
    final item = record.copyWith(codigo: codigo, updatedAt: now);

    if (_firebaseReady) {
      final collection = FirebaseFirestore.instance.collection('ordens_servico');
      if (record.id.isEmpty) {
        await collection.add(item.copyWith(createdAt: now).toMap());
      } else {
        await collection.doc(record.id).set(item.toMap(), SetOptions(merge: true));
      }
      return;
    }

    final items = _ordensPorUsuario.putIfAbsent(record.userId, () => []);
    final index = items.indexWhere((element) => element.id == record.id && record.id.isNotEmpty);
    final saved = record.id.isEmpty ? item.copyWith(id: _newId('ordem')) : item;

    if (index >= 0) {
      items[index] = saved;
    } else {
      items.insert(0, saved);
    }

    _changes.add(null);
  }

  Future<void> deleteCliente(String id, String userId) async {
    if (_firebaseReady) {
      await FirebaseFirestore.instance.collection('clientes_veiculos').doc(id).delete();
      return;
    }

    _clientesPorUsuario[userId]?.removeWhere((item) => item.id == id);
    _changes.add(null);
  }

  Future<void> deleteOrdem(String id, String userId) async {
    if (_firebaseReady) {
      await FirebaseFirestore.instance.collection('ordens_servico').doc(id).delete();
      return;
    }

    _ordensPorUsuario[userId]?.removeWhere((item) => item.id == id);
    _changes.add(null);
  }

  String _newId(String prefix) => '$prefix-${DateTime.now().microsecondsSinceEpoch}';

  String _nextCodigoOrdem(String userId) {
    final total = _ordensPorUsuario[userId]?.length ?? 0;
    return 'OS-${1024 + total + 1}';
  }
}