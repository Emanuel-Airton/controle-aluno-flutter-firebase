import 'package:controle_saida_aluno/src/controllers/controllerFCM.dart';
import 'package:controle_saida_aluno/src/widgets/dropDownEscolha.dart';
import 'package:controle_saida_aluno/src/widgets/stream_list_saidas.dart';
import 'package:controle_saida_aluno/src/screens/tela_inicial.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TelaPortaria extends StatefulWidget {
  const TelaPortaria({super.key});

  @override
  State<TelaPortaria> createState() => _TelaPortariaState();
}

class _TelaPortariaState extends State<TelaPortaria> {
  List<String> list = ["sair"];
  String userPortaria = "portaria";

  dialog(BuildContext context, RemoteMessage remoteMessage) {
    Map<String, dynamic> map = remoteMessage.data;
    var dados = map["message"];
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text("Aluno liberado!"),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [Text(dados)],
            ),
          );
        });
  }

  sair(String string) async {
    String valor = "sem valor";
    final user = await SharedPreferences.getInstance();
    user.setString('username', valor);
    String? nome = user.getString('username');
    //  print(string);
    if (string == "sair") {
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
              builder: (context) => TelaInicial(valorRecebido: valor)),
          (Route route) => false);
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    //   _configureFCMListeners();
    // ControllerFCM();
    ControllerFCM(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          actions: [
            PopupMenuButton(
                iconColor: Colors.white,
                onSelected: sair,
                itemBuilder: (context) => list.map((e) {
                      return PopupMenuItem(value: e, child: Text(e));
                    }).toList())
          ],
          backgroundColor: Theme.of(context).colorScheme.primary,
          title: const Text(
            "Portaria",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
        ),
        body: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            DropDownEscolha().dropDownEscolha(),
            SaidaStream(user: userPortaria)
          ],
        ));
  }
}
