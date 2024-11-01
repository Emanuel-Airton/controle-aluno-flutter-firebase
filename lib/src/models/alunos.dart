import 'package:cloud_firestore/cloud_firestore.dart';

class Alunos {
  late String _nomeAluno;
  late String _telefone;

  get nome => _nomeAluno;

  set nome(value) => _nomeAluno = value;

  get telefone => _telefone;

  set telefone(value) => _telefone = value;

  Map<String, dynamic> mapa() {
    Map<String, dynamic> map = {
      "nome": nome,
      "telefone": telefone,
    };
    return map;
  }

  cadastrar(String id, Alunos alunos) async {
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    await firebaseFirestore
        .collection("turmas")
        .doc(id)
        .collection("alunos")
        .add(alunos.mapa());
  }
}
