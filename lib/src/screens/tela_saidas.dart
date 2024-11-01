import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:controle_saida_aluno/src/models/saida.dart';
import 'package:controle_saida_aluno/src/widgets/dropDownEscolha.dart';
import 'package:controle_saida_aluno/src/widgets/stream_list_saidas.dart';
import 'package:controle_saida_aluno/src/widgets/stream_list_saidas.dart';
import 'package:flutter/material.dart';

class TelaSaidas extends StatefulWidget {
  const TelaSaidas({super.key});

  @override
  State<TelaSaidas> createState() => _TelaSaidasState();
}

class _TelaSaidasState extends State<TelaSaidas> {
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  List<Saida> listaSaida = [];
  List<Saida> listaSaidaReserva = [];
  static const String userDirecao = 'direção/coordenação';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        DropDownEscolha().dropDownEscolha(),
        SaidaStream(user: userDirecao)
      ],
    ));
  }
}
