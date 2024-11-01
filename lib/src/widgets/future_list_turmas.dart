import 'package:controle_saida_aluno/src/firebase/firebase.dart';
import 'package:controle_saida_aluno/src/models/turmas.dart';
import 'package:controle_saida_aluno/src/screens/tela_alunos_turma.dart';
import 'package:flutter/material.dart';

class ListTurmas {
  future(String turno) {
    return FutureBuilder(
        future: Firebaseclasse().calcularQuantidadePorTurma(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return const Center(child: Text("Erro ao carregar dados!"));
          }
          List<Map<String, dynamic>> lista = snapshot.data!;
          List<Map<String, dynamic>> novaLista =
              retornaListaTurno(turno, lista);
          // print(novaLista);
          return listView(novaLista);
        });
  }

  retornaListaTurno(String turno, List<Map<String, dynamic>> lista) {
    List<Map<String, dynamic>> listaPorTurno = [];
    Map<String, dynamic> map = {};
    switch (turno) {
      case 'matutino':
        listaPorTurno = adicionaMapALista(lista, turno);
        return listaPorTurno;
      case 'vespertino':
        listaPorTurno = adicionaMapALista(lista, turno);
        return listaPorTurno;
    }
  }

  adicionaMapALista(List<Map<String, dynamic>> list, String turno) {
    List<Map<String, dynamic>> listaPorTurno = [];
    for (Map<String, dynamic> map in list) {
      if (map.containsValue(turno)) {
        listaPorTurno.add(map);
      }
    }
    return listaPorTurno;
  }

  listView(List<Map<String, dynamic>> novaLista) {
    return Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          gradient: const LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: [
              Color.fromARGB(255, 198, 0, 0),
              Color.fromARGB(255, 0, 0, 128),
            ],
          ),
        ),
        child: ListView.builder(
          itemCount: novaLista.length,
          itemBuilder: (context, index) {
            var item = novaLista[index];
            Turmas turmas = Turmas();
            turmas.setNomeTurma = item["turma"];
            turmas.setTurno = item["turno"];
            String doc = item["documento"] ?? 'vazio';
            //print(item);
            return Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: Colors.white),
                child: ListTile(
                  title: Text(
                    'Turma: ${item["turma"]}',
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.primary,
                        fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    'quantidade de alunos: ${item["quantidade"].toString()}',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  trailing: IconButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => AlunosTurma(
                                      turmas: turmas,
                                      doc: doc,
                                    )));
                      },
                      icon: Icon(
                        color: Theme.of(context).colorScheme.secondary,
                        Icons.list,
                        size: 30,
                      )),
                ),
              ),
            );
          },
        ));
  }
}
