import 'package:flutter/services.dart';
import 'package:pdf/widgets.dart' as widget;
import 'package:pdf/widgets.dart';

class GeneratePdfAlunosDeficientes {
  Future<Uint8List> gerarPdf(List<Map> list) async {
    final image = await rootBundle.load('assets/logoJASF.png');
    final imageByte = image.buffer.asUint8List();
    widget.Image image1 = widget.Image(widget.MemoryImage(imageByte));
    var pdf = widget.Document();

    pdf.addPage(widget.Page(
      orientation: PageOrientation.natural,
      // pageFormat: PdfPageFormat.a4.landscape,
      margin: const widget.EdgeInsets.fromLTRB(20, 50, 20, 20),
      build: (context) {
        return widget.Column(children: [
          widget.Container(
              alignment: widget.Alignment.center, height: 60, child: image1),
          widget.Text("COLÉGIO MUNICIPAL JOAQUIM ALEXANDRE DA SILVA FILHO",
              style: const widget.TextStyle(fontSize: 12)),
          //  pw.Image(),
          widget.SizedBox(height: 20),
          widget.Text("Alunos com algum tipo de deficiência ",
              style: widget.TextStyle(
                  fontWeight: widget.FontWeight.bold, fontSize: 18)),
          widget.Padding(
              padding: const widget.EdgeInsets.only(top: 20),
              // ignore: deprecated_member_use
              child: widget.Table.fromTextArray(
                  cellPadding: const widget.EdgeInsets.all(3),
                  cellAlignment: widget.Alignment.center,
                  border: widget.TableBorder.all(width: 1),
                  headerStyle: widget.TextStyle(
                      fontWeight: widget.FontWeight.bold, fontSize: 15),
                  cellStyle: const widget.TextStyle(fontSize: 10),
                  columnWidths: {
                    0: const widget.FlexColumnWidth(1.6),
                    1: const widget.FlexColumnWidth(1.8),
                    2: const widget.FlexColumnWidth(1.6),
                  },
                  data: list
                      .map((item) => [
                            item["nome"],
                            item["deficiencia"],
                            item["monitor"],
                            item["turma"],
                            item["turno"]
                          ])
                      .toList(),
                  headers: [
                    "nome",
                    "deficiencia",
                    "monitor",
                    "turma",
                    "turno"
                  ]))
        ]);
      },
    ));
    return pdf.save();
  }
}
