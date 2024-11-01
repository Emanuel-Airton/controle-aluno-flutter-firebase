import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Turma {
  final String nome;
  final String turno;
  final String id;

  Turma({required this.nome, required this.turno, required this.id});
}

class Aluno {
  final String nome;
//  final String turno;

  Aluno({required this.nome});
}

class TurmasPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('turmas').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          List<Turma> turmas = [];
          snapshot.data!.docs.forEach((doc) {
            turmas
                .add(Turma(nome: doc['nome'], turno: doc['turno'], id: doc.id));
          });

          Map<String, int> quantidadePorTurno = {};
          turmas.forEach((turma) {
            quantidadePorTurno[turma.turno] = 0;
          });

          return FutureBuilder(
            future: calcularQuantidadeAlunosPorTurno(turmas),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }

              if (snapshot.hasError) {
                return const Center(
                  child: Text('Erro ao carregar os dados'),
                );
              }

              Map<String, int> quantidadeAlunos =
                  snapshot.data as Map<String, int>;

              return ListView.builder(
                itemCount: quantidadeAlunos.length,
                itemBuilder: (context, index) {
                  //  print(quantidadeAlunos.length.toString());
                  String turno = quantidadeAlunos.keys.elementAt(index);
                  int quantidade = quantidadeAlunos[turno]!;

                  return ListTile(
                    title: Text('$turno: $quantidade alunos'),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }

  Future<Map<String, int>> calcularQuantidadeAlunosPorTurno(
      List<Turma> turmas) async {
    Map<String, int> quantidadePorTurno = {};

    for (var turma in turmas) {
      //  print(turma.nome);
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('turmas')
          .doc(turma.id)
          .collection('alunos')
          .get();

      int quantidadeAlunosTurma = querySnapshot.docs.length;
      //  print(quantidadeAlunosTurma.toString());
      //  List<Aluno> list = [];
      /*   querySnapshot.docs.forEach((element) {
        list.clear();
        list.add(Aluno(nome: element["nome"]));
      });*/

      // print(querySnapshot.docs.length);
      quantidadePorTurno.update(
          turma.turno, (value) => value + quantidadeAlunosTurma,
          ifAbsent: () => quantidadeAlunosTurma);
    }

    return quantidadePorTurno;
  }
}
