import 'package:controle_saida_aluno/src/models/alunos.dart';
import 'package:flutter/material.dart';

class ListAlunosState extends ChangeNotifier {
  List<Alunos> listaAlunos = [];
  set setListaAluno(List<Alunos> list) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      listaAlunos = list;
      notifyListeners();
    });
  }

  get lista => listaAlunos;
  String item = "Últimos 7 dias";
  String get selectItem => item;

  void updateSelectedItem(String value) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      item = value;
      notifyListeners();
    });
  }

  void apagarLista() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      listaAlunos.clear();
      notifyListeners();
    });
  }

  void receberLista(List<Alunos> listaRecebida) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      listaAlunos = listaRecebida;
      notifyListeners();
    });
  }
}
