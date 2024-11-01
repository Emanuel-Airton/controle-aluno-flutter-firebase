import 'package:controle_saida_aluno/src/models/alunos.dart';
import 'package:flutter/services.dart';
import 'package:pdf/widgets.dart' as widget;

class GeneratePdfAlunos {
  Future<Uint8List> gerarPDF(List<Alunos> list, String turma) async {
    final image = await rootBundle.load('assets/logoJASF.png');
    final imageByte = image.buffer.asUint8List();
    widget.Image image1 = widget.Image(widget.MemoryImage(imageByte));

    List<Map<String, dynamic>> listaMap = [];
    Map<String, dynamic> map = {};
    for (Alunos item in list) {
      map = {"nome": item.nome, "telefone": item.telefone};
      listaMap.add(map);
    }
    for (int i = 0; i < listaMap.length; i++) {
      map = {"numero": i + 1};
      listaMap[i].addAll(map);
    }
    // print(listaMap);

    var pdf = widget.Document();
    pdf.addPage(widget.Page(
        margin: const widget.EdgeInsets.all(20),
        build: (context) {
          return widget.Column(children: [
            widget.Container(
                alignment: widget.Alignment.center, height: 40, child: image1),
            widget.Text("COLÉGIO MUNICIPAL JOAQUIM ALEXANDRE DA SILVA FILHO",
                style: const widget.TextStyle(fontSize: 12)),
            widget.SizedBox(height: 10),
            widget.Text(turma,
                style: widget.TextStyle(
                    fontSize: 14, fontWeight: widget.FontWeight.bold)),
            //  pw.Image(),
            widget.SizedBox(height: 10),

            widget.Table.fromTextArray(
                cellPadding: const widget.EdgeInsets.all(3),
                cellAlignment: widget.Alignment.center,
                border: widget.TableBorder.all(width: 1),
                headerStyle: widget.TextStyle(
                    fontWeight: widget.FontWeight.bold, fontSize: 15),
                cellStyle: const widget.TextStyle(fontSize: 10),
                data: listaMap
                    .map((item) =>
                        [item["numero"], item["nome"], item["telefone"]])
                    .toList(),
                headers: <String>["N°", "Nome", "Telefone"])
          ]);
        }));
    return pdf.save();
  }
}
