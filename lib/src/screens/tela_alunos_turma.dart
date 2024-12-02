import 'package:controle_saida_aluno/src/models/alunos.dart';
import 'package:controle_saida_aluno/src/models/turmas.dart';
import 'package:controle_saida_aluno/src/screens/pdf_alunos.dart';
import 'package:controle_saida_aluno/src/utils/list_alunos_state.dart';
import 'package:controle_saida_aluno/src/widgets/Future_list_alunos.dart';
import 'package:flutter/material.dart';

class AlunosTurma extends StatefulWidget {
  Turmas turmas;
  late String doc;
  AlunosTurma({super.key, required this.turmas, required this.doc});

  @override
  State<AlunosTurma> createState() => _AlunosTurmaState();
}

class _AlunosTurmaState extends State<AlunosTurma> {
  late ListAlunosState listAlunosState;
  List<Alunos> lista = [];
  @override
  Widget build(BuildContext context) {
    String turma = widget.turmas.nomeTurma;
    return Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => PdfAlunos(
                          turma: turma,
                        )));
          },
          backgroundColor: Theme.of(context).colorScheme.primary,
          child: const Icon(
            Icons.picture_as_pdf,
            color: Colors.white,
          ),
        ),
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.primary,
          title: Text(
            turma,
            style: const TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
            color: Colors.white,
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(5.0),
          child: Container(
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
              padding: const EdgeInsets.all(5),
              child: ListAlunosTurma(
                escolha: '',
                nomeTurma: turma,
                ocultarTrailing: true,
              )),
        ));
  }
}
