import 'package:controle_saida_aluno/src/utils/list_alunos_state.dart';
import 'package:controle_saida_aluno/src/widgets/Future_list_turmas.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TelaAunosTurma extends StatelessWidget {
  late String turno;
  TelaAunosTurma({super.key, required this.turno});

  @override
  Widget build(BuildContext context) {
    return Consumer<ListAlunosState>(
      builder: (BuildContext context, ListAlunosState value, Widget? child) {
        return Scaffold(
            appBar: AppBar(
              backgroundColor: Theme.of(context).colorScheme.primary,
              title: Text(
                turno,
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
            body: Container(
              padding: const EdgeInsets.all(5),
              child: ListTurmas().future(turno),
            ));
      },
    );
  }
}
