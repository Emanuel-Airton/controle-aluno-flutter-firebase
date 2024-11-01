import 'package:controle_saida_aluno/home.dart';
import 'package:controle_saida_aluno/src/itens/generatePDF.dart';
import 'package:controle_saida_aluno/src/itens/generatePDFAlunosDeficientes.dart';
import "package:flutter/material.dart";
import 'package:printing/printing.dart';

// ignore: must_be_immutable
class PdfVizualizacao extends StatelessWidget {
  late List<Map<dynamic, dynamic>> list;
  PdfVizualizacao({super.key, required this.list});

  @override
  Widget build(BuildContext context) {
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
        title: const Text(
          "PDF",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      body: PdfPreview(
          shouldRepaint: false,
          canDebug: false,
          canChangeOrientation: false,
          canChangePageFormat: false,
          build: (context) {
            return list.any((element) => element["deficiente"] != null)
                ? GeneratePdfAlunosDeficientes().gerarPdf(list)
                : GeneratePDF().gerarPDFListaTurmas(list);
          }),
    );
  }
}
