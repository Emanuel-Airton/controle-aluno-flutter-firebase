import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:controle_saida_aluno/src/controllers/push_notification.dart';
import 'package:controle_saida_aluno/src/models/alunos.dart';
import 'package:controle_saida_aluno/src/models/saida.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

FirebaseFirestore db = FirebaseFirestore.instance;

class Firebaseclasse {
  List<Saida> list = [];
  static const colecaoSaida = "saida";
  static const colecaoTurmas = "turmas";
  static const colecaoAlunos = "alunos";
  late Map<String, dynamic> turmaMap;

  inserir(Saida anotacao) async {
    Uuid uuid = const Uuid();
    String v1 = uuid.v1();
    anotacao.id = v1;
    db
        .collection(colecaoSaida)
        .doc(anotacao.id)
        .set(anotacao.map())
        .then((value) {
      //  Cloud_menssaging().enviarNotificacaoPush(anotacao);
      PushNotificationService().sendNotification(anotacao);
    }).catchError((Error) {
      ArgumentError("Erro ao cadastrar$Error");
    });
  }

  Future<void> excluirRegistroDeSaida(var id) async {
    try {
      await db
          .collection(colecaoSaida)
          .doc(id)
          .delete()
          .then((value) => debugPrint("Documento apagado com sucesso"));
    } on FirebaseException catch (e) {
      throw Exception("Erro desconhecido: $e");
    }
  }

  String ultima = "";
  //retorna o ultimo documento de saida de aluno de acordo com a ordem do firebase
  Future listarSaidaDoUltimoAlunoFirebase() async {
    QuerySnapshot querySnapshot = await db.collection(colecaoSaida).get();
    List list = [];
    for (DocumentSnapshot documentSnapshot in querySnapshot.docs) {
      Map<String, dynamic> map =
          documentSnapshot.data() as Map<String, dynamic>;
      list.add(map["nome"]);
      ultima = list.last;
      list.clear();
    }
    return ultima;
  }

  Future listarAlunosPorTurma(String nomeTurma) async {
    List<Alunos> list = [];
    QuerySnapshot querySnapshot = await db
        .collection(colecaoTurmas)
        .doc(nomeTurma)
        .collection("alunos")
        .orderBy("nome")
        .get();
    for (DocumentSnapshot documentSnapshot in querySnapshot.docs) {
      Map<String, dynamic> map =
          documentSnapshot.data() as Map<String, dynamic>;
      Alunos alunos = Alunos();
      alunos.nome = map["nome"];
      alunos.telefone = map["telefone"];
      list.add(alunos);
    }
    return list;
  }

  //metodo que atualiza todos os registros de saida no firebase e converte o campo data de String para Timestemp
  atualizarStringParaTimesTemp() async {
    QuerySnapshot querySnapshot = await db.collection(colecaoSaida).get();
    List list = [];
    Timestamp timestamp;
    for (DocumentSnapshot documentSnapshot in querySnapshot.docs) {
      list.clear();
      Map<String, dynamic> mapa =
          documentSnapshot.data() as Map<String, dynamic>;

      try {
        DateFormat dateFormat = DateFormat("dd/MM/yyyy").add_Hm();
        DateTime convert = dateFormat.parse(mapa["data"]);
        convert = convert.add(const Duration(hours: 3));

        timestamp = Timestamp.fromDate(convert);
        list.add({mapa["nome"], timestamp.toDate()});
        await documentSnapshot.reference.update({"data": timestamp});
      } catch (e) {
        debugPrint("Invalid format data: $e");
        return null;
      }
      await db.collection(colecaoSaida).doc().update({"data": timestamp});
    }
    list.clear();
  }

  atualizarData() async {
    DocumentSnapshot documentSnapshot = await db
        .collection(colecaoSaida)
        .doc("0b8dfef0-890f-1fbc-b0c4-094fc1b0bd06")
        .get();

    Map map = documentSnapshot.data() as Map;
    DateFormat dateFormat = DateFormat("dd/MM/yyyy").add_Hm();
    DateTime dateTime = dateFormat.parse(map["data"]);
    dateTime = dateTime.add(const Duration(hours: 3));
    Timestamp timestamp = Timestamp.fromDate(dateTime);
    documentSnapshot.reference.update({"data": timestamp});
  }

  Future<Map<String, dynamic>> obterInformacoesTurma(
      DocumentSnapshot documentSnapshot) async {
    Map<String, dynamic> map = documentSnapshot.data() as Map<String, dynamic>;
    String turma = map['nome'];
    String turno = map['turno'];
    String id = documentSnapshot.id;

    QuerySnapshot alunosSnapshot = await db
        .collection(colecaoTurmas)
        .doc(id)
        .collection(colecaoAlunos)
        .get();

    int quantidadeAlunos = alunosSnapshot.docs.length;
    return {
      "turma": turma,
      "turno": turno,
      "quantidadeAlunos": quantidadeAlunos,
    };
  }

  Future<Map<String, int>> calcularQuantidadeAlunosPorTurno() async {
    Map<String, int> quantidadePorTurno = {};
    QuerySnapshot turmasSnapshot = await db.collection(colecaoTurmas).get();

    for (DocumentSnapshot documentSnapshot in turmasSnapshot.docs) {
      Map<String, dynamic> info = await obterInformacoesTurma(documentSnapshot);
      String turno = info['turno'];
      int quantidadeAlunos = info['quantidadeAlunos'];

      quantidadePorTurno.update(
        turno,
        (value) => value + quantidadeAlunos,
        ifAbsent: () => quantidadeAlunos,
      );
    }
    return quantidadePorTurno;
  }

  Future<List<Map<String, dynamic>>> calcularQuantidadePorTurma() async {
    List<Map<String, dynamic>> lista = [];
    QuerySnapshot turmasSnapshot = await db.collection(colecaoTurmas).get();

    for (DocumentSnapshot documentSnapshot in turmasSnapshot.docs) {
      Map<String, dynamic> info = await obterInformacoesTurma(documentSnapshot);
      lista.add({
        "turma": info['turma'],
        "quantidade": info['quantidadeAlunos'],
        "turno": info['turno'],
        "documento": documentSnapshot.id
      });
    }
    return lista;
  }

  Stream<List<Map<String, dynamic>>> retornarUltimasTresSaidasComoStream() {
    return db.collection(colecaoSaida).snapshots().asyncMap((event) async {
      List<Map<String, dynamic>> list = [];
      List<Map<String, dynamic>> ultimasSaidas = [];

      for (DocumentSnapshot documentSnapshot in event.docs) {
        Map<String, dynamic> map =
            documentSnapshot.data() as Map<String, dynamic>;
        list.add(map);
      }
      list.sort(
        (a, b) {
          Timestamp dataA = (a["data"]);
          Timestamp dataB = (b["data"]);
          return dataB.compareTo(dataA);
        },
      );
      // Pegue os primeiros três itens ou menos se a lista for menor que 3
      int primeirosTresItens = list.length < 3 ? list.length : 3;
      for (int i = 0; i < primeirosTresItens; i++) {
        ultimasSaidas.add(list[i]);
      }

      return ultimasSaidas;
    });
  }

  Future<List<Map<String, dynamic>>> listarAlunosDeficientes() async {
    List<Map<String, dynamic>> listaAlunosDeficientes = [];
    QuerySnapshot querySnapshot = await db.collection(colecaoTurmas).get();
    for (DocumentSnapshot documentSnapshot in querySnapshot.docs) {
      Map<String, dynamic> map =
          documentSnapshot.data() as Map<String, dynamic>;
      String nomeTurma = map["nome"];
      String turno = map["turno"];

      String idTurma = documentSnapshot.id;
      QuerySnapshot alunoDeficiente = await db
          .collection(colecaoTurmas)
          .doc(idTurma)
          .collection(colecaoAlunos)
          .where('deficiente', isEqualTo: true)
          .get();
      for (DocumentSnapshot docAlunoDeficiente in alunoDeficiente.docs) {
        Map<String, dynamic> mapAlunoDeficiente =
            docAlunoDeficiente.data() as Map<String, dynamic>;
        // print("nome");
        String nome = mapAlunoDeficiente["nome"];
        bool deficiente = mapAlunoDeficiente["deficiente"];
        String deficiencia = mapAlunoDeficiente["deficiencia"];
        String monitor = mapAlunoDeficiente["monitor"];
        Map<String, dynamic> novoMap = {
          "nome": nome,
          "deficiente": deficiente,
          "deficiencia": deficiencia,
          "monitor": monitor,
          "turma": nomeTurma,
          "turno": turno,
        };
        listaAlunosDeficientes.add(novoMap);
      }
    }
    // print(listaAlunosDeficientes);
    return listaAlunosDeficientes;
  }
}
