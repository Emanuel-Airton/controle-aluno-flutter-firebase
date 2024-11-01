import 'package:controle_saida_aluno/src/firebase/firebase.dart';
import 'package:controle_saida_aluno/src/screens/pdf_visualizacao.dart';
import 'package:flutter/material.dart';

class QuantidadeAlunosTurma extends StatefulWidget {
  //final Future<List<Map>> future;
  const QuantidadeAlunosTurma({super.key});

  @override
  _QuantidadeAlunosTurmaState createState() => _QuantidadeAlunosTurmaState();
}

class _QuantidadeAlunosTurmaState extends State<QuantidadeAlunosTurma> {
  List<Map<dynamic, dynamic>> list = [];
  List<Map<dynamic, dynamic>> list2 = [];
  List<Map<dynamic, dynamic>> mapteste = [];
  late Future<List<Map<String, dynamic>>> quantidadeTurmas;

  @override
  void initState() {
    // TODO: implement initState
    quantidadeTurmas = Firebaseclasse().calcularQuantidadePorTurma();
    super.initState();
  }

  List<Map<dynamic, dynamic>> adicionarLista(
      List<Map<dynamic, dynamic>> listaOriginal) {
    Map<String, int> quantidadePorTurno =
        calcularQuantidadePorTurno(listaOriginal);
    int quantidadeTotal = calcularQuantidadeTotal(quantidadePorTurno);
    quantidadePorTurno['total de alunos'] = quantidadeTotal;
    listaOriginal.add(quantidadePorTurno);
    return listaOriginal;
  }

  Map<String, int> calcularQuantidadePorTurno(
      List<Map<dynamic, dynamic>> lista) {
    Map<String, int> quantidadePorTurno = {};
    for (var item in lista) {
      String turno = item['turno'] ?? 'indefinido';
      int quantidade = item['quantidade'] ?? 0;
      quantidadePorTurno.update('total $turno', (value) => value + quantidade,
          ifAbsent: () => quantidade);
    }
    return quantidadePorTurno;
  }

  int calcularQuantidadeTotal(Map<String, int> quantidadePorTurno) {
    return quantidadePorTurno.values
        .fold(0, (total, quantidade) => total + quantidade);
  }

  Widget futureLista() {
    mapteste.clear();
    return FutureBuilder(
      future: quantidadeTurmas,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return const Center(child: Text("Erro ao carregar dados"));
        }
        final List<Map<dynamic, dynamic>> list = snapshot.data!;
        mapteste = adicionarLista(list);
        // print(mapteste);
        return Column(
          children: [
            _buildListView(context, mapteste),
          ],
        );
      },
    );
  }

  List<Map> _filterListByTurno(List<Map> list, String turno) {
    return list.where((item) => item["turno"] == turno).toList();
  }

  Widget _buildListView(BuildContext context, List<Map> list) {
    Map<String, dynamic> map = {};
    for (var item in list) {
      map = {
        "total matutino": item["total matutino"],
        "total vespertino": item["total vespertino"],
        "total de alunos": item['total de alunos']
      };
    }
    return Expanded(
      child: ListView(
        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildListItem(context, map),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildListItem(BuildContext context, Map item) {
    int totalMatutino = item["total matutino"];
    int totalVespertino = item["total vespertino"];
    int totalAlunos = item["total de alunos"];

    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 30),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
            boxShadow: const [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 5,
                spreadRadius: 3,
                offset: Offset(0, 3),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(child: Image.asset("assets/logoJASF.png", height: 60)),
                const SizedBox(height: 10),
                _buildInfoTable(totalMatutino, totalVespertino, totalAlunos),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoTable(
      int totalMatutino, int totalVespertino, int totalAlunos) {
    return Table(
      border: TableBorder.symmetric(
        inside: BorderSide(color: Colors.grey.shade300),
      ),
      columnWidths: const {
        0: FlexColumnWidth(3),
        1: FlexColumnWidth(2),
      },
      children: [
        _buildTableRow("Matutino", totalMatutino),
        _buildTableRow("Vespertino", totalVespertino),
        _buildTableRow("Total de alunos", totalAlunos),
      ],
    );
  }

  TableRow _buildTableRow(String title, int value) {
    return TableRow(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 10),
          child: Text(
            title,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.grey.shade700,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 10),
          child: Text(
            value.toString(),
            style: const TextStyle(fontSize: 16, color: Colors.black87),
          ),
        ),
      ],
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
              builder: (context) => PdfVizualizacao(
                list: mapteste,
              ),
            ),
          );
        },
      ),
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          "Turmas",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      body: Container(
        padding: const EdgeInsets.all(0),
        child: futureLista(),
      ),
    );
  }
}
