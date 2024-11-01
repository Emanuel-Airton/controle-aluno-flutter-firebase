import 'package:cloud_firestore/cloud_firestore.dart';

class Turmas {
  String nomeTurma = "";
  String turno = "";

  get getNomeTurma => nomeTurma;

  set setNomeTurma(nomeTurma) => this.nomeTurma = nomeTurma;

  get getTurno => turno;

  set setTurno(turno) => this.turno = turno;

  Map<String, dynamic> mapa() {
    Map<String, dynamic> map = {
      "nome": nomeTurma,
      "turno": turno,
    };
    return map;
  }

  cadastrar() async {
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    await firebaseFirestore.collection("turmas").add(mapa());
  }
}
