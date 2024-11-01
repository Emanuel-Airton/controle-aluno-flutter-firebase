import 'dart:typed_data';

import 'package:flutter/services.dart';
import 'package:pdf/widgets.dart' as pw;

class GeneratePDF {
  Future<Uint8List> gerarPDFListaTurmas(List<Map> list) async {
    final image = await rootBundle.load('assets/logoJASF.png');
    final imageBytes = image.buffer.asUint8List();
    pw.Image imageLogo = pw.Image(pw.MemoryImage(imageBytes));
    final pdf = pw.Document();
    List<Map> listaMatutino = [];
    List<Map> listaVespertino = [];
    List<Map> listaTotal = [];
    for (var doc in list) {
      if (doc["turno"] == "matutino") {
        listaMatutino.add(doc);
        //print(listaMatutino);
      } else if (doc["turno"] == "vespertino") {
        listaVespertino.add(doc);
      } else {
        listaTotal.add(doc);
      }
    }

    pdf.addPage(pw.Page(
        margin: const pw.EdgeInsets.all(20),
        build: (context) {
          return pw.Column(
              //  mainAxisAlignment: pw.MainAxisAlignment.spaceAround,
              children: [
                pw.Container(
                    alignment: pw.Alignment.center,
                    height: 60,
                    child: imageLogo),
                pw.Text("COLÉGIO MUNICIPAL JOAQUIM ALEXANDRE DA SILVA FILHO",
                    style: const pw.TextStyle(fontSize: 12)),
                //  pw.Image(),
                pw.SizedBox(height: 20),
                pw.Text("Quantidade de Alunos por turma",
                    style: pw.TextStyle(
                        fontWeight: pw.FontWeight.bold, fontSize: 18)),
                pw.Padding(
                  padding: const pw.EdgeInsets.only(bottom: 20, top: 20),
                  // ignore: deprecated_member_use
                  child: pw.Table.fromTextArray(
                      cellAlignment: pw.Alignment.center,
                      headerStyle: pw.TextStyle(
                          fontWeight: pw.FontWeight.bold, fontSize: 15),
                      headers: ["turma", "turno", "quantidade"],
                      data: listaMatutino
                          .map((item) => [
                                item["turma"],
                                item["turno"],
                                item["quantidade"]
                              ])
                          .toList()),
                ),
                // ignore: deprecated_member_use
                pw.Table.fromTextArray(
                    border: pw.TableBorder.all(width: 1),
                    cellAlignment: pw.Alignment.center,
                    headerStyle: pw.TextStyle(
                        fontWeight: pw.FontWeight.bold, fontSize: 15),
                    headers: ["turma", "turno", "quantidade"],
                    data: listaVespertino
                        .map((item) =>
                            [item["turma"], item["turno"], item["quantidade"]])
                        .toList()),
                pw.Padding(
                  padding: const pw.EdgeInsets.only(top: 20),
                  // ignore: deprecated_member_use
                  child: pw.Table.fromTextArray(
                      border: pw.TableBorder.all(width: 1),
                      cellAlignment: pw.Alignment.center,
                      headerStyle: pw.TextStyle(
                          fontWeight: pw.FontWeight.bold, fontSize: 15),
                      headers: ["matutino", "vespertino", "total"],
                      data: listaTotal
                          .map((item) => [
                                item["total matutino"],
                                item["total vespertino"],
                                item["total de alunos"]
                              ])
                          .toList()),
                )
              ]);
        }));
    return pdf.save();
  }
}
