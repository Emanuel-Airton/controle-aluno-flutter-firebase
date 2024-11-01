import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:controle_saida_aluno/src/models/saida.dart';
import 'package:controle_saida_aluno/src/utils/drop_down_state.dart';
import 'package:controle_saida_aluno/src/widgets/dialog_excluir.dart';
import 'package:controle_saida_aluno/src/widgets/dialog_list.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class SaidaStream extends StatefulWidget {
  late String user;
  SaidaStream({super.key, required this.user});

  @override
  State<SaidaStream> createState() => _SaidaStreamState();
}

class _SaidaStreamState extends State<SaidaStream> {
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  final String _userPortaria = "portaria";
  final List<Saida> _listaSaida = [];
  List<Saida> _listaSaidaReserva = [];

  // Método principal para construir o StreamBuilder
  Widget buildStreamBuilder() {
    return Consumer<DropDownState>(
      builder: (context, value, child) {
        return Expanded(
          child: StreamBuilder(
            stream: _firebaseFirestore.collection("saida").snapshots(),
            builder: (context, snapshot) {
              return _buildStreamContent(
                  context, snapshot, value.selectItem, widget.user);
            },
          ),
        );
      },
    );
  }

  // Método para construir o conteúdo do StreamBuilder
  Widget _buildStreamContent(BuildContext context,
      AsyncSnapshot<QuerySnapshot> snapshot, String selectedItem, String user) {
    if (snapshot.connectionState == ConnectionState.waiting) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }
    if (snapshot.connectionState == ConnectionState.active) {
      if (snapshot.hasError) {
        return const Center(
          child: Text("Erro ao carregar dados!"),
        );
      }
      _processSnapshotData(snapshot.data!.docs, selectedItem);
      return _buildSaidaList(context, user);
    }
    return Container();
  }

  // Método para processar os dados do snapshot
  void _processSnapshotData(
      List<QueryDocumentSnapshot> docs, String selectedItem) {
    _listaSaida.clear();
    docs.sort((a, b) {
      Timestamp dataA = a["data"];
      Timestamp dataB = b["data"];
      return dataB.compareTo(dataA);
    });

    for (var item in docs) {
      Map<String, dynamic> map = item.data() as Map<String, dynamic>;
      Saida saida = Saida(
        id: item.id,
        map["nome"],
        map["telefone"],
        map["serie"],
        map["motivo"],
        map["autorizacao"],
        map["data"],
      );
      _listaSaida.add(saida);
    }
    _listaSaidaReserva =
        Saida.semDados().listarPordata(_listaSaida, selectedItem);
  }

  // Método para construir a lista de Saídas
  Widget _buildSaidaList(BuildContext context, String user) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          gradient: const LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: [
              Color.fromARGB(255, 198, 0, 0),
              Color.fromARGB(255, 0, 0, 128),
            ],
          ),
        ),
        child: ListView.builder(
          itemCount: _listaSaidaReserva.length,
          itemBuilder: (context, indice) {
            return _buildSaidaItem(context, indice, user);
          },
        ),
      ),
    );
  }

  // Método para construir cada item da lista de Saídas
  Widget _buildSaidaItem(BuildContext context, int indice, String user) {
    int cont = indice + 1;
    var item = _listaSaidaReserva[indice];
    Timestamp timestamp = _convertToTimestamp(item.getData);
    Saida saida = Saida(
      id: item.id,
      item.nome,
      item.telefone,
      item.getSerie,
      item.getMotivo,
      item.getAutorizacao,
      timestamp,
    );
    return GestureDetector(
      onTap: () {
        Dialog_list().dialogList(context, saida, usuario: user);
      },
      child: Padding(
        padding: const EdgeInsets.only(bottom: 8.0),
        child: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15), color: Colors.white),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: Theme.of(context).colorScheme.primary,
              child: Text(
                cont.toString(),
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            title: Text(
              item.nome.toString(),
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            trailing: user == 'portaria'
                ? null
                : IconButton(
                    color: const Color.fromARGB(255, 0, 0, 128),
                    onPressed: () {
                      print("numero do id: ${item.id}");
                      Dialog_excluir().dialogExcluir(context, id: item.id);
                    },
                    icon: const Icon(Icons.delete),
                  ),
            subtitle: Text(
              saida.getData,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.secondary,
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Método para converter string de data para Timestamp
  Timestamp _convertToTimestamp(String data) {
    DateFormat dateFormat = DateFormat("dd/MM/yyyy").add_Hm();
    DateTime dateTime = dateFormat.parse(data);
    return Timestamp.fromDate(dateTime);
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return buildStreamBuilder();
  }
}
