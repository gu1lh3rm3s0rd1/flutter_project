import 'package:flutter/material.dart';

class InsumoController extends ChangeNotifier {
  final List<Map<String, dynamic>> _estoque = [
    {'nome': 'Filtro de oleo', 'quantidade': 24, 'unidade': 'un'},
    {'nome': 'Jogo de velas', 'quantidade': 18, 'unidade': 'kits'},
    {'nome': 'Pneu aro 15', 'quantidade': 12, 'unidade': 'un'},
  ];

  List<Map<String, dynamic>> get estoque => List.unmodifiable(_estoque);

  void baixarEstoque(int index, int quantidade) {
    if (index >= 0 && index < _estoque.length && _estoque[index]['quantidade'] >= quantidade) {
      _estoque[index]['quantidade'] -= quantidade;
      notifyListeners();
    }
  }
}