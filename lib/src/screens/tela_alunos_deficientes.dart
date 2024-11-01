import 'package:controle_saida_aluno/src/screens/pdf_visualizacao.dart';
import 'package:flutter/material.dart';

class TelaAlunosDeficientes extends StatefulWidget {
  late Future<List<Map<String, dynamic>>> list;

  TelaAlunosDeficientes({super.key, required this.list});

  @override
  State<TelaAlunosDeficientes> createState() => _TelaAlunosDeficientesState();
}

class _TelaAlunosDeficientesState extends State<TelaAlunosDeficientes> {
  //late Future<List<Map<String, dynamic>>> list;
  List<Map<dynamic, dynamic>> listaSnapshot = [];
  TextStyle estilo1 =
      TextStyle(fontWeight: FontWeight.bold, color: Colors.grey.shade700);

  future() {
    return FutureBuilder(
      future: widget.list,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        if (snapshot.hasError) {
          return const Center(
            child: Text("Erro ao carregar dados"),
          );
        }
        listaSnapshot = snapshot.data!;
        return ordenaListaPorData();
      },
    );
  }

  ordenaListaPorData() {
    listaSnapshot.sort(((a, b) {
      String nomeA = a["nome"];
      String nomeB = b["nome"];
      return nomeA.compareTo(nomeB);
    }));
    return listView();
  }

  listView() {
    return ListView.builder(
      itemCount: listaSnapshot.length,
      itemBuilder: (context, index) {
        Map<dynamic, dynamic> map = listaSnapshot[index];
        return container(map);
      },
    );
  }

  container(Map<dynamic, dynamic> map) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: [
              Color.fromARGB(255, 198, 0, 0),
              Color.fromARGB(255, 0, 0, 128),
            ]),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(15, 10, 15, 10),
        child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 5,
                  spreadRadius: 5,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            child: card(map)),
      ),
    );
  }

  card(Map<dynamic, dynamic> map) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(6.0),
        child: Table(
          border: TableBorder(
              verticalInside: BorderSide(width: 1, color: Colors.grey.shade700),
              horizontalInside:
                  BorderSide(width: 1, color: Colors.grey.shade700)),
          columnWidths: const {
            0: FlexColumnWidth(1),
            1: FlexColumnWidth(2),
          },
          children: [
            TableRow(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('Nome', style: estilo1),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(map["nome"],
                      style: TextStyle(color: Colors.grey.shade700)),
                ),
              ],
            ),
            TableRow(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('Deficiência', style: estilo1),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(map["deficiencia"],
                      style: TextStyle(color: Colors.grey.shade700)),
                ),
              ],
            ),
            TableRow(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('Monitor', style: estilo1),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(map["monitor"],
                      style: TextStyle(color: Colors.grey.shade700)),
                ),
              ],
            ),
            TableRow(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('Turma', style: estilo1),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Text(
                        map["turma"],
                        style: TextStyle(color: Colors.grey.shade700),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 3),
                        child: Text(
                          map["turno"],
                          style: TextStyle(color: Colors.grey.shade700),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).colorScheme.primary,
        child: const Icon(
          Icons.picture_as_pdf,
          color: Colors.white,
        ),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PdfVizualizacao(list: listaSnapshot),
            ),
          );
        },
      ),
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: const Text("Alunos especiais",
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        centerTitle: true,
      ),
      body: Container(
        padding: const EdgeInsets.all(5),
        child: future(),
      ),
    );
  }
}
