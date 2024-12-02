import 'package:controle_saida_aluno/src/firebase/firebase.dart';
import 'package:controle_saida_aluno/src/models/alunos.dart';
import 'package:controle_saida_aluno/src/utils/list_alunos_state.dart';
import 'package:controle_saida_aluno/src/widgets/dialog_cadastro.dart';
import 'package:controle_saida_aluno/src/widgets/dialog_contato.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ListAlunosTurma extends StatefulWidget {
  late String nomeTurma;
  late String escolha;
  late bool ocultarTrailing;
  ListAlunosTurma(
      {super.key,
      required this.nomeTurma,
      required this.escolha,
      required this.ocultarTrailing});

  @override
  State<ListAlunosTurma> createState() => _ListAlunosTurmaState();
}

class _ListAlunosTurmaState extends State<ListAlunosTurma> {
  Widget buildFuture(String nomeTurma, {String? escolha}) {
    return FutureBuilder(
      future: Firebaseclasse().listarAlunosPorTurma(nomeTurma),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return _buildLoadingIndicator();
        } else if (snapshot.hasError) {
          return _buildErrorIndicator();
        }
        // Use addPostFrameCallback para garantir que a lista seja atualizada após a construção do widget

        WidgetsBinding.instance.addPostFrameCallback((_) {
          Provider.of<ListAlunosState>(context, listen: false)
              .receberLista(snapshot.data!);
        });

        return _buildAlunosList(context, snapshot.data, nomeTurma,
            widget.ocultarTrailing, escolha ?? 'nulo');
      },
    );
  }

  // Método para construir o indicador de carregamento
  Widget _buildLoadingIndicator() {
    return const Center(
      child: Column(
        children: [
          CircularProgressIndicator(
            color: Colors.white,
          ),
          Text(
            "Carregando dados...",
            style: TextStyle(color: Colors.white),
          )
        ],
      ),
    );
  }

  // Método para construir o indicador de erro
  Widget _buildErrorIndicator() {
    return const Center(child: Text("Erro ao carregar dados!"));
  }

  // Método para construir a lista de alunos
  Widget _buildAlunosList(BuildContext context, List<Alunos> alunosList,
      String nomeTurma, bool ocultarTrailing, String escolha) {
    return Padding(
      padding: const EdgeInsets.only(top: 15.0),
      child: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
              gradient: const LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: [
                    Color.fromARGB(255, 198, 0, 0),
                    Color.fromARGB(255, 0, 0, 128)
                  ]),
              //color: Theme.of(context).colorScheme.primary,
              borderRadius: BorderRadius.circular(15)),
          child: ListView.builder(
            // physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: alunosList.length,
            itemBuilder: (context, index) {
              return _buildAlunoItem(context, alunosList[index], index + 1,
                  nomeTurma, ocultarTrailing, escolha);
            },
          )),
    );
  }

  // Método para construir cada item da lista de alunos
  Widget _buildAlunoItem(BuildContext context, Alunos aluno, int index,
      String nomeTurma, bool ocultarTrailing, String escolha) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: Colors.white,
        ),
        child: ListTile(
          leading: CircleAvatar(
            backgroundColor: Theme.of(context).colorScheme.primary,
            child: Text(
              index.toString(),
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          title: Text(
            aluno.nome.toString(),
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.primary,
              fontSize: 12,
            ),
          ),
          subtitle: ocultarTrailing
              ? Row(
                  children: [
                    Icon(
                      Icons.phone,
                      color: Theme.of(context).colorScheme.secondary,
                      size: 20,
                    ),
                    Text(
                      aluno.telefone,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                    )
                  ],
                )
              : null,
          trailing: ocultarTrailing
              ? null
              : _buildTrailingIcons(context, aluno, nomeTurma, escolha),
        ),
      ),
    );
  }

  // Método para construir os ícones de ação no trailing
  Widget _buildTrailingIcons(
      BuildContext context, Alunos aluno, String nomeTurma, String escolha) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          onPressed: () {
            Dialog_contato().dialogTelefone(context, aluno);
          },
          icon: const Icon(
            Icons.phone,
            color: Color.fromARGB(255, 0, 0, 128),
          ),
        ),
        IconButton(
          onPressed: () {
            Dialog_cadastro().dialogInserir(
              context,
              alunos: aluno,
              escolha: escolha,
              nomeTurma: nomeTurma,
            );
          },
          icon: const Icon(
            Icons.add,
            color: Color.fromARGB(255, 198, 0, 0),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return buildFuture(widget.nomeTurma, escolha: widget.escolha);
  }
}
