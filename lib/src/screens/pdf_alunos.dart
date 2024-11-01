import 'package:controle_saida_aluno/home.dart';
import 'package:controle_saida_aluno/src/itens/generatePDFAlunos.dart';
import 'package:controle_saida_aluno/src/utils/list_alunos_state.dart';
import 'package:flutter/material.dart';
import 'package:printing/printing.dart';
import 'package:provider/provider.dart';

class PdfAlunos extends StatelessWidget {
  String turma;
  PdfAlunos({super.key, required this.turma});

  @override
  Widget build(BuildContext context) {
    return Consumer<ListAlunosState>(
      builder: (context, value, child) {
        return Scaffold(
          appBar: AppBar(
            leading: IconButton(
                onPressed: () {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => HomePage()),
                    ModalRoute.withName('/'),
                  );
                },
                icon: const Icon(
                  Icons.home,
                  color: Colors.white,
                )),
            backgroundColor: Theme.of(context).colorScheme.primary,
          ),
          body: PdfPreview(
              shouldRepaint: false,
              canDebug: false,
              canChangeOrientation: false,
              canChangePageFormat: false,
              build: (context) {
                return GeneratePdfAlunos().gerarPDF(value.listaAlunos, turma);
              }),
        );
      },
    );
  }
}
