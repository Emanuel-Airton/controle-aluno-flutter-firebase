import 'package:controle_saida_aluno/src/utils/list_alunos_state.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class teste extends StatelessWidget {
  const teste({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("data"),
      ),
      body: Consumer<ListAlunosState>(
        builder: (BuildContext context, ListAlunosState value, Widget? child) {
          for (var item in value.listaAlunos) {
            print(item.nome);
          }

          return Container(
              padding: EdgeInsets.all(5),
              child: ListView.builder(
                  itemCount: value.listaAlunos.length,
                  itemBuilder: (context, index) {
                    var item = value.listaAlunos[index];
                    return ListTile(
                      title: Text(item.nome),
                    );
                  }));
        },
      ),
    );
  }
}
